import 'package:flutter/material.dart';
import 'package:newwwwwwww/core/theme/text_styles.dart';
import 'package:newwwwwwww/features/orders/presentation/widgets/payement_status_widget.dart';

import '../../../../core/theme/colors.dart';
import '../../domain/models/order_model.dart';

Widget OrderPaymentCard(double screenWidth, double screenHeight,String paymentStatus,ClientOrder clientOrder) {
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
            'Payment Summary',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Payment Method', style: AppTextStyles.textSummaryStyle),
                Text(
               clientOrder.paymentMethod??'',// clientOrder.isPaid!?  'eWallet':'Cash On Delivery',
                  style: TextStyle(
                    color: AppColors.greyDarktextIntExtFieldAndIconsHome,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            BuildPaymentStatus(screenWidth, screenHeight, paymentStatus,fromOrderDetail: true)
          ],
        ),


      ],
    ),
  );
}
