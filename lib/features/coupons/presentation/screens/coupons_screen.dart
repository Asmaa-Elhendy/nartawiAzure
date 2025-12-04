import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:newwwwwwww/features/coupons/presentation/widgets/add_coupon_widget.dart';
import '../../../../core/theme/colors.dart';
import '../../../home/presentation/bloc/product_quantity/product_quantity_bloc.dart';
import '../../../home/presentation/widgets/background_home_Appbar.dart';
import '../../../home/presentation/widgets/build_ForegroundAppBarHome.dart';
import '../widgets/coupon_card.dart';

class CouponsScreen extends StatefulWidget {
  final bool fromViewButton;

  CouponsScreen({this.fromViewButton = false});

  @override
  State<CouponsScreen> createState() => _CouponsScreenState();
}

class _CouponsScreenState extends State<CouponsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final ProductQuantityBloc _quantityBloc;
  bool newCoupon = false;
  bool _isLoading = false; // Add loading state

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String? imageUrl = null;

  // Handle refresh action
  Future<void> _handleRefresh() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          newCoupon = true;
        });
      }
    } catch (e) {
      log('Error refreshing coupons: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final double topOffset =
        MediaQuery.of(context).padding.top + screenHeight * .08;
    final double bottomOffset = screenHeight * .05; // زي favourites

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // الخلفية
          Container(
            width: screenWidth,
            height: screenHeight,
            color: AppColors.backgrounHome,
          ),

          buildBackgroundAppbar(screenWidth),

          BuildForegroundappbarhome(
            screenHeight: screenHeight,
            screenWidth: screenWidth,
            title: 'Coupons',
            is_returned: widget.fromViewButton,
            disabledGallon: 'Coupons',
          ),

          /// 👇 الكونتنت الأساسي زي favourites (bottom + padding داخلي)
          Positioned.fill(
            top: topOffset,
            bottom: bottomOffset,
            child: Padding(
              padding: EdgeInsets.only(
                // نفس الفكرة اللي في Favourites
                bottom: screenHeight * .1,
              ),
              child: RefreshIndicator(
                onRefresh: _handleRefresh,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * .06,
                      vertical: screenHeight*.02
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your Coupons',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: screenWidth * .045,
                              ),
                            ),
                            AddCoupon(context, screenWidth, screenHeight),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * .01,
                          ),
                          child: Text(
                            'Manage your water coupon bundles and delivery preferences',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: screenWidth * .036,
                              color: AppColors
                                  .greyDarktextIntExtFieldAndIconsHome,
                            ),
                          ),
                        ),
                        CouponeCard(
                          onReorder: () {
                            log("hello 1 - Reload triggered");
                            _handleRefresh();
                          },
                        ),
                        CouponeCard(
                          disbute: true,
                          onReorder: () {
                            log("hello 2 - Reload triggered");
                            _handleRefresh();
                          },
                        ),
                        newCoupon
                            ? CouponeCard(
                          disbute: true,
                          onReorder: () {
                            log("hello 3 - Reload triggered");
                            _handleRefresh();
                          },
                        )
                            : const SizedBox(),
                        SizedBox(height: screenHeight * .04),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          /// 👇 اللودينج أوفرلاي على نفس مساحة الكونتنت بالظبط
          if (_isLoading)
            Positioned.fill(
              child: Container(
                margin: EdgeInsets.only(
                  top: topOffset,
                  bottom: bottomOffset,
                ),
                color: Colors.black54,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Please Wait...',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
