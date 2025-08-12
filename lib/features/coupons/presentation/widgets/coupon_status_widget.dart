import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';

Widget CouponStatus(double screenHeight,double screenWidth,String status) {
  return Container(
  //  width: screenWidth*.16,
    padding: EdgeInsets.symmetric(
        vertical:screenHeight * .01, horizontal: screenWidth * .02),
    decoration: BoxDecoration(
      color: status == 'Active' ? AppColors.greenLight :AppColors.primaryLight ,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Center(
      child: Text(
        status,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: status == 'Active' ? AppColors.greenColor :
          AppColors.primary,

          fontSize: screenWidth * .035,
        ),
      ),
    ),
  );
}
