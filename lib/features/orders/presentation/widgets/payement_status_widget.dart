import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';



Widget BuildPaymentStatus(double screenWidth,double screenHeight,String status){
  return Container(
    width: screenWidth*.38,
    padding: EdgeInsetsGeometry.symmetric(vertical: screenHeight*.01,horizontal: screenWidth*.015),
    //   width:  screenWidth * .28,
    height: screenHeight * .047,
    decoration: BoxDecoration(
      border: Border.all(
        color:status=='Paid'? AppColors.greenColor:AppColors.orangeColor, // 👈 Border color
        width: 1.5,               // 👈 Optional: Border thickness
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Center(
      child: Text(
        status,
        style: TextStyle(
          color:status=='Paid'? AppColors.greenColor:AppColors.orangeColor,
          fontSize: screenWidth*.035,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}