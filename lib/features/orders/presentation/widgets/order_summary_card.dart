import 'package:flutter/material.dart';
import 'package:newwwwwwww/core/theme/text_styles.dart';

import '../../../../core/theme/colors.dart';

Widget OrderSummaryCard(double screenWidth, double screenHeight) {
  return Container(
    margin: EdgeInsets.symmetric(
      vertical: screenHeight * .0,
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
            'Order Summary',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: screenWidth * .04,
              color: AppColors.primary,
            ),
          ),
        ),
         SizedBox(height:screenHeight*.02 ),

        // Item 1
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hand Pump Dispenser', style: AppTextStyles.textSummaryStyle),
                  Text(
                    'Company Hand Pump Dispenser-Pure Natureal......',
                    style: TextStyle(
                      color: AppColors.greyDarktextIntExtFieldAndIconsHome,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('4*QAR 25.00', style: AppTextStyles.textSummaryStyle),
                Text('Subtotal : 100', style: AppTextStyles.textSummaryStyle),
              ],
            ),
          ],
        ),
        SizedBox(height:screenHeight*.01 ),
        Divider(color: AppColors.backgrounHome,),
        // Item 2
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('330 Ml x 24pcs (50packs)', style: AppTextStyles.textSummaryStyle),
                  Text(
                    'Company Boittles',
                    style: TextStyle(
                      color: AppColors.greyDarktextIntExtFieldAndIconsHome,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('1*QAR 24.00', style: AppTextStyles.textSummaryStyle),
                Text('Subtotal : 24', style: AppTextStyles.textSummaryStyle),
              ],
            ),
          ],
        ),
        SizedBox(height:screenHeight*.01 ),

         Divider(color: AppColors.backgrounHome,),

        SizedBox(height:screenHeight*.02 ),

        // Subtotal & Delivery Fee
        Row(
          children: [
            Expanded(
              child: SizedBox(height: screenHeight*.1,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Items Subtotal', style: AppTextStyles.textSummaryStyle),
                    SizedBox(height: 4),
                    Text('QAR 124,00', style: AppTextStyles.textSummaryStyle),
                  ],
                ),
              ),
            ),

            // هنا تعديل
            SizedBox(

              height: screenHeight * 0.1,
              width: 20,
              child: VerticalDivider(
                color: AppColors.backgrounHome,
                thickness: 1,
              ),
            ),

            Expanded(
              child: SizedBox(height: screenHeight*.1,
                child: Column(mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Delivery Fee', style: AppTextStyles.textSummaryStyle),
                    SizedBox(height: 4),
                    Text('QAR 10,00', style: AppTextStyles.textSummaryStyle),
                  ],
                ),
              ),
            ),
          ],
        ),

        SizedBox(height:screenHeight*.02 ),


        // Tax & Total
        Row(
          children: [
            Expanded(
              child: SizedBox(height: screenHeight*.1,
                child: Column(mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tax', style: AppTextStyles.textSummaryStyle),
                    SizedBox(height: 4),
                    Text('QAR 00,00', style: AppTextStyles.textSummaryStyle),
                  ],
                ),
              ),
            ),

            // هنا تعديل برضه
            SizedBox(
              height: screenHeight*.1,
              width: 20,
              child: VerticalDivider(
                color: AppColors.backgrounHome,
                thickness: 1,
              ),
            ),

            Expanded(
              child: SizedBox(height: screenHeight*.1,
                child: Container(
                  padding:  EdgeInsets.symmetric(
                    vertical: screenHeight*.02,
                    horizontal: screenWidth*.03,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.backgrounHome,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total :', style: AppTextStyles.textSummaryStyle),
                      SizedBox(height: 4),
                      Text('QAR 134', style: AppTextStyles.textSummaryStyle),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
