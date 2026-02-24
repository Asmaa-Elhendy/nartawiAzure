import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:newwwwwwww/features/coupons/presentation/widgets/add_coupon_widget.dart';

import '../../../../core/theme/colors.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../home/presentation/bloc/product_quantity/product_quantity_bloc.dart';
import '../../../home/presentation/widgets/background_home_Appbar.dart';
import '../../../home/presentation/widgets/build_ForegroundAppBarHome.dart';
import '../provider/coupon_controller.dart';
import '../../../../core/services/dio_service.dart';
import '../../../auth/presentation/bloc/login_bloc.dart';
import '../widgets/coupon_card.dart';

class CouponsScreen extends StatefulWidget {
  final bool fromViewButton;

  const CouponsScreen({super.key, this.fromViewButton = false});

  @override
  State<CouponsScreen> createState() => _CouponsScreenState();
}

class _CouponsScreenState extends State<CouponsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final ProductQuantityBloc _quantityBloc;

  bool _isLoadingOverlay = false;
  late final CouponsController _couponsController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();

    _couponsController = CouponsController(dio: DioService.dio);


    _couponsController.fetchAllCoupons(); //get all coupons and filter with current  bundlePurchaseId last date
    _couponsController.fetchBundlePurchases();
    _couponsController.fetchScheduledOrders();//consider not used

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _couponsController.loadMoreBundlePurchases();
      }
    });

    _couponsController.addListener(() {
      if (!mounted) return;
      setState(() {
        _isLoadingOverlay = _couponsController.isLoadingBundles;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _couponsController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    await _couponsController.refreshAll();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final double topOffset =
        MediaQuery.of(context).padding.top + screenHeight * .08;
    final double bottomOffset = screenHeight * .05;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            width: screenWidth,
            height: screenHeight,
            color: AppColors.backgrounHome,
          ),
          buildBackgroundAppbar(screenWidth),
          BuildForegroundappbarhome(
            screenHeight: screenHeight,
            screenWidth: screenWidth,
            title: AppLocalizations.of(context)!.coupons,
            is_returned: widget.fromViewButton,
            disabledGallon: AppLocalizations.of(context)!.coupons,
          ),
          Positioned.fill(
            top: topOffset,
            bottom: bottomOffset,
            child: Padding(
              padding: EdgeInsets.only(bottom: screenHeight * .1),
              child: RefreshIndicator(color: AppColors.primary,
                onRefresh: _handleRefresh,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * .06,
                      vertical: screenHeight * .02,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.yourCoupons,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: screenWidth * .045,
                              ),
                            ),
                            AddCoupon(),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * .01,
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.bundlePurchaseHistory,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: screenWidth * .036,
                              color: AppColors.greyDarktextIntExtFieldAndIconsHome,
                            ),
                          ),
                        ),

                        AnimatedBuilder(
                          animation: _couponsController,
                          builder: (context, _) {
                            if (_couponsController.isLoadingBundles &&
                                _couponsController.bundlePurchases.isEmpty) {
                              return Padding(
                                padding: EdgeInsets.only(top: screenHeight * .15),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.primary,
                                    ),
                                  ),
                                ),
                              );
                            }

                            if (_couponsController.bundlesError != null &&
                                _couponsController.bundlePurchases.isEmpty) {
                              return Padding(
                                padding: EdgeInsets.only(top: screenHeight * .15),
                                child: Center(
                                  child: Text(
                                    _couponsController.bundlesError!,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ),
                              );
                            }

                            if (_couponsController.bundlePurchases.isEmpty) {
                              return Padding(
                                padding: EdgeInsets.only(top: screenHeight * .1),
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)!.noBundlesFound,
                                    style: TextStyle(
                                      fontSize: screenWidth * .04,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              );
                            }

                            return ListView.builder(
                              controller: _scrollController,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _couponsController.bundlePurchases.length +
                                  (_couponsController.isLoadingMoreBundles ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index >= _couponsController.bundlePurchases.length) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: screenHeight * .02,
                                    ),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          AppColors.primary,
                                        ),
                                      ),
                                    ),
                                  );
                                }

                                final bundle = _couponsController.bundlePurchases[index];

                                // ✅ آخر delivery (day+hour) = list
                                final lastDeliveredCoupons =
                                _couponsController.getCouponsInLastDeliveryDayHour(bundle.id);

                                return CouponeCard(
                                  bundle: bundle,
                                  currentCoupon: lastDeliveredCoupons, // ✅ دايمًا List
                                  disbute: lastDeliveredCoupons.any((c) => c.status == 'Disputed'),
                                  onReorder: () async => _handleRefresh(),
                                  couponsController: _couponsController,
                                );
                              },
                            );
                          },
                        ),

                        SizedBox(height: screenHeight * .04),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // if (_isLoadingOverlay)
          //   Positioned.fill(
          //     child: Container(
          //       margin: EdgeInsets.only(top: topOffset, bottom: bottomOffset),
          //       color: Colors.black54,
          //       child: Center(
          //         child: Container(
          //           padding: const EdgeInsets.all(20),
          //           decoration: BoxDecoration(
          //             color: Colors.white,
          //             borderRadius: BorderRadius.circular(10),
          //           ),
          //           child: Column(
          //             mainAxisSize: MainAxisSize.min,
          //             children: [
          //               CircularProgressIndicator(
          //                 valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          //               ),
          //               const SizedBox(height: 10),
          //               const Text(
          //                 'Please Wait...',
          //                 style: TextStyle(
          //                   color: Colors.black,
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }
}
