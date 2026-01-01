import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/components/coupon_status_widget.dart';
import '../../../../core/theme/colors.dart';
import '../../../profile/domain/models/coupon_balance_item.dart';
import 'custom_text.dart';


import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../../../core/services/auth_service.dart';
import 'package:newwwwwwww/features/auth/presentation/bloc/login_bloc.dart';

import '../../../../core/theme/colors.dart';

Widget latestCouponTrackerCarousSliderDynamic({
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
    return '${local.day.toString().padLeft(2, '0')}/'
        '${local.month.toString().padLeft(2, '0')}/'
        '${local.year}';
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
            customCouponPrimaryTitle('Coupon Balance', screenWidth, screenHeight),
            GestureDetector(
              onTap: () => onReorder(),
              child: CouponStatus(screenHeight, screenWidth, 'Re-Order'),
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
            customCouponSecondaryTitleCarous('$total Total', screenWidth, screenHeight),
            customCouponSecondaryTitleCarous('$used Used', screenWidth, screenHeight),
            customCouponSecondaryTitleCarous('$remaining Remaining', screenWidth, screenHeight),
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
                customCouponPrimaryTitle('Last Used', screenWidth, screenHeight),
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
                customCouponPrimaryTitle('Expiry', screenWidth, screenHeight),
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



class LatestCouponTrackerFromApi extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final int reloadTick; // just to force FutureBuilder refresh

  const LatestCouponTrackerFromApi({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.reloadTick,
  });

  Future<CouponBalanceItem?> _fetchLastCouponBalance() async {
    final dio = Dio();

    final token = await AuthService.getToken();
    if (token == null) return null;

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
        .map((e) => CouponBalanceItem.fromJson(e as Map<String, dynamic>))
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
    // ✅ reloadTick makes future "different" so it refetches
    return FutureBuilder<CouponBalanceItem?>(
      future: _fetchLastCouponBalance(),
      key: ValueKey(reloadTick),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            padding: EdgeInsets.all(screenWidth * .04),
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
            padding: EdgeInsets.all(screenWidth * .04),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              'No coupon balance found',
              style: TextStyle(
                fontSize: screenWidth * .04,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }

        // ✅ pass real values to your existing UI widget
        return latestCouponTrackerCarousSliderDynamic(
          screenWidth: screenWidth,
          screenHeight: screenHeight,
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
