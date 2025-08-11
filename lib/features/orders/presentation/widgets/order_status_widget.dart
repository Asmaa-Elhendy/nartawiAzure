import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
Widget BuildOrderStatus(double screenHeight,double screenWidth,String title) {
  return Container(
    width: screenWidth*.38,
    padding: EdgeInsets.symmetric(
        vertical: screenHeight * .01, horizontal: screenWidth * .02),
    decoration: BoxDecoration(
      color: title == 'Delivered' ? AppColors.greenLight :title=='Pending'?AppColors.orangeLight :AppColors.redLight,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Center(
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: title == 'Delivered' ? AppColors.greenColor :
          title=='Pending'?AppColors.orangeColor:
          AppColors
              .redColor,
          fontSize: screenWidth * .035,
        ),
      ),
    ),
  );
}
