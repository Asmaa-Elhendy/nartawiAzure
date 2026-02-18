import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';

import '../../../../core/components/coupon_status_widget.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/services/dio_service.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../profile/domain/models/coupon_balance_item.dart';
import 'custom_text.dart';

import '../../../../../core/services/auth_service.dart';
import 'package:newwwwwwww/features/auth/presentation/bloc/login_bloc.dart';

Widget latestCouponTrackerCarousSliderDynamic({
  required BuildContext context,
  required double screenWidth,
  required double screenHeight,
  required int total,
  required int used,
  required int remaining,
  required DateTime? lastUsed,
  required DateTime? expiry,
  required Function onReorder,
}) {
  final progress = total <= 0 ? 0.0 : (used / total).clamp(0.0, 1.0);

  String fmt(DateTime? d) {
    if (d == null) return '-';
    final local = d.toLocal();

    // Sat : May 4, 2025
    return DateFormat('EEE : MMM d, y', 'en_US').format(local);
  }

  return Container(
    padding: EdgeInsets.only(
      left: screenWidth * .04,
      right: screenWidth * .04,
      top: screenHeight * .01,
      bottom: screenHeight * .01,
    ),
    decoration: BoxDecoration(
      color: AppColors.whiteColor,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            customCouponPrimaryTitle(AppLocalizations.of(context)!.couponBalance, screenWidth, screenHeight),
            GestureDetector(
              onTap: () => onReorder(),
              child: CouponStatus(screenHeight, screenWidth, '${AppLocalizations.of(context)!.reOrder}'),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: screenHeight * .01),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.primaryLight,
            minHeight: screenHeight * .01,
            borderRadius: BorderRadius.circular(10),
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            customCouponSecondaryTitleCarous('$total ${AppLocalizations.of(context)!.total}', screenWidth, screenHeight),
            customCouponSecondaryTitleCarous('$used ${AppLocalizations.of(context)!.used}', screenWidth, screenHeight),
            customCouponSecondaryTitleCarous('$remaining ${AppLocalizations.of(context)!.remaining}', screenWidth, screenHeight),
          ],
        ),
        SizedBox(height: screenHeight * .008),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customCouponPrimaryTitle(AppLocalizations.of(context)!.lastDelivered, screenWidth, screenHeight),
                Row(
                  children: [
                    SvgPicture.asset(
                      "assets/images/orders/calendar.svg",
                      width: screenWidth * .03,
                      color: AppColors.textLight,
                    ),
                    SizedBox(width: screenWidth * .01),
                    Text(fmt(lastUsed), style: TextStyle(fontSize: screenWidth * .03)),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customCouponPrimaryTitle(AppLocalizations.of(context)!.nextRefill, screenWidth, screenHeight),
                Row(
                  children: [
                    SvgPicture.asset(
                      "assets/images/orders/calendar.svg",
                      width: screenWidth * .03,
                      color: AppColors.textLight,
                    ),
                    SizedBox(width: screenWidth * .01),
                    Text(fmt(expiry), style: TextStyle(fontSize: screenWidth * .03)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}

/// ✅ IMPORTANT FIX:
/// - Make it Stateful
/// - Cache the Future in initState
/// - Recreate it ONLY when reloadTick changes
class LatestCouponTrackerFromApi extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;
  final int reloadTick;

  const LatestCouponTrackerFromApi({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.reloadTick,
  });

  @override
  State<LatestCouponTrackerFromApi> createState() => _LatestCouponTrackerFromApiState();
}

class _LatestCouponTrackerFromApiState extends State<LatestCouponTrackerFromApi> {
  late Future<CouponBalanceItem?> _future;

  @override
  void initState() {
    super.initState();
    _future = _fetchLastCouponBalance(); // ✅ fetch once
  }

  @override
  void didUpdateWidget(covariant LatestCouponTrackerFromApi oldWidget) {
    super.didUpdateWidget(oldWidget);

    // ✅ Only refetch when reloadTick changes (pull-to-refresh / init refresh)
    if (oldWidget.reloadTick != widget.reloadTick) {
      _future = _fetchLastCouponBalance();
    }
  }

  Future<CouponBalanceItem?> _fetchLastCouponBalance() async {
    final dio = DioService.dio;

    final token = await AuthService.getToken();
    print('🔑 LatestCouponTracker token = $token');

    // Don't check for null token - let the API call happen to trigger 401
    // This will allow AuthInterceptor to handle the 401 and navigate to login

    final url = '$base_url/v1/client/wallet/balance';

    final response = await dio.get(
      url,
      options: Options(
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode != 200) return null;

    final data = response.data;
    if (data is! Map) return null;

    final rawList = data['couponBalances'];
    final List<dynamic> list = rawList is List ? rawList : <dynamic>[];
    if (list.isEmpty) return null;

    final items = list
        .whereType<Map>()
        .map((e) => CouponBalanceItem.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    // ✅ last one by lastUsed (newest)
    items.sort((a, b) {
      final ad = a.lastUsed ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bd = b.lastUsed ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bd.compareTo(ad);
    });

    return items.first;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CouponBalanceItem?>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            padding: EdgeInsets.all(widget.screenWidth * .04),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        final item = snapshot.data;
        if (item == null) {
          return Container(
            padding: EdgeInsets.all(widget.screenWidth * .04),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              AppLocalizations.of(context)!.nocCouponBalanceFound,
              style: TextStyle(
                fontSize: widget.screenWidth * .04,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }

        return latestCouponTrackerCarousSliderDynamic(context: context,
          screenWidth: widget.screenWidth,
          screenHeight: widget.screenHeight,
          total: item.totalCoupons,
          used: item.usedCoupons,
          remaining: item.availableCoupons,
          lastUsed: item.lastUsed,
          expiry: item.expiryDate,
          onReorder: () {},
        );
      },
    );
  }
}
