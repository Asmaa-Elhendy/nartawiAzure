import 'package:flutter/material.dart';
import 'package:newwwwwwww/core/theme/text_styles.dart';

import '../../../../core/theme/colors.dart';

Widget OrderDeliveryCard(double screenWidth, double screenHeight) {
  return Container(
    margin: EdgeInsets.symmetric(
      vertical: screenHeight * .02,
    ),
    padding: EdgeInsets.symmetric(
      vertical: screenHeight * .02,
      horizontal: screenWidth * .03,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: AppColors.whiteColor,
      // boxShadow: [
      //   BoxShadow(
      //     color: AppColors.shadowColor,
      //     offset: Offset(0, 2),
      //     blurRadius: 8,
      //     spreadRadius: 0,
      //   ),
      // ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title
        Center(
          child: Text(
            'Delivery Summary',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: screenWidth * .04,
              color: AppColors.primary,
            ),
          ),
        ),
        SizedBox(height:screenHeight*.02 ),

        // Item 1

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Delivery Address', style: AppTextStyles.textSummaryStyle),
                Text(
                  'Zone abc, Street 20, Building 21, Flat 22',
                  style: TextStyle(
                    color: AppColors.greyDarktextIntExtFieldAndIconsHome,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),

        SizedBox(height:screenHeight*.01 ),
        Divider(color: AppColors.backgrounHome,),
        // Item 2

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Estimated Delivery', style: AppTextStyles.textSummaryStyle),
                Text(
                  'Within 24-48 hours',
                  style: TextStyle(
                    color: AppColors.greyDarktextIntExtFieldAndIconsHome,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),


      ],
    ),
  );
}
