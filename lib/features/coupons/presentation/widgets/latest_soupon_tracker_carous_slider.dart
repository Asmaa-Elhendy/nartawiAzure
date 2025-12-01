

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/components/coupon_status_widget.dart';
import '../../../../core/theme/colors.dart';
import 'custom_text.dart';

Widget latestCouponTrackerCarousSlider(double screenWidth,double screenHeight,Function onReorder){
  return
    Container(
      padding: EdgeInsets.only(
          left: screenWidth * .04,
          right: screenWidth * .04,
          top: screenHeight * .01,
        bottom: screenHeight*.01
      ),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(15)
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
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
              GestureDetector(
                  onTap: (){
                    onReorder();
                  },
                  child: CouponStatus(screenHeight, screenWidth, 'Re-Order')),
            ],
          ),//k

          /// Progress bar
          Padding(
            padding: EdgeInsets.symmetric(vertical: screenHeight * .01),
            child: LinearProgressIndicator(
              value: 0.4,
              backgroundColor: AppColors.primaryLight,
              minHeight: screenHeight * .01,//.012
              borderRadius: BorderRadius.circular(10),
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),

          /// Totals row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              customCouponSecondaryTitleCarous(
                '25 Total',
                screenWidth,
                screenHeight,
              ),
              customCouponSecondaryTitleCarous(
                '15 Used',
                screenWidth,
                screenHeight,
              ),
              customCouponSecondaryTitleCarous(
                '10 Remaining',
                screenWidth,
                screenHeight,
              ),
            ],
          ),
          SizedBox(height: screenHeight*.008,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  customCouponPrimaryTitle(
                    'Last Delivered',
                    screenWidth,
                    screenHeight,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        "assets/images/orders/calendar.svg",
                        width: screenWidth * .03,
                        color: AppColors.textLight,
                      ),
                      SizedBox(width: screenWidth*.01,),
                      Text("Sat : may 4, 2025 ",style: TextStyle(fontSize: screenWidth*.03),)
                    ],
                  ),
                ],
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  customCouponPrimaryTitle(
                    'Next Refill',
                    screenWidth,
                    screenHeight,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        "assets/images/orders/calendar.svg",
                        width: screenWidth * .03,
                        color: AppColors.textLight,
                      ),
                      SizedBox(width: screenWidth*.01,),
                      Text("Sat : may 4, 2025 ",style: TextStyle(fontSize: screenWidth*.03),)
                    ],
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
}