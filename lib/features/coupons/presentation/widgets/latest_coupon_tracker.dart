

import 'package:flutter/material.dart';

import '../../../../core/components/coupon_status_widget.dart';
import '../../../../core/theme/colors.dart';
import 'custom_text.dart';

Widget latestCouponTracker(double screenWidth,double screenHeight){
  return
      Column(mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              customCouponPrimaryTitle(
                'Coupon Balance',
                screenWidth,
                screenHeight,
              ),
              CouponStatus(screenHeight, screenWidth, '10 Left'),
            ],
          ),

          /// Progress bar
          Padding(
            padding: EdgeInsets.symmetric(vertical: screenHeight * .02),
            child: LinearProgressIndicator(
              value: 0.4,
              backgroundColor: AppColors.primaryLight,
              minHeight: screenHeight * .012,
              borderRadius: BorderRadius.circular(10),
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),

          /// Totals row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              customCouponSecondaryTitle(
                '25 Total',
                screenWidth,
                screenHeight,
              ),
              customCouponSecondaryTitle(
                '15 Used',
                screenWidth,
                screenHeight,
              ),
              customCouponSecondaryTitle(
                '10 Remaining',
                screenWidth,
                screenHeight,
              ),
            ],
          ),

        ],
      );
}