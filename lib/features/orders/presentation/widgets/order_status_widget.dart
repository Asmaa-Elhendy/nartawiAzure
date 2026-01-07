import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
Widget BuildOrderStatus(double screenHeight,double screenWidth,String title,{bool fromOrderDetail=false,bool fromDeliveryMan=false}) {
  return Container(
    width:fromDeliveryMan?screenWidth*.25:fromOrderDetail? screenWidth*.3:screenWidth*.36,
    padding: EdgeInsets.symmetric(
        vertical:fromOrderDetail?screenHeight*.025: screenHeight * .01, horizontal: screenWidth * .02),
    decoration: BoxDecoration(
      color: title == 'Delivered' ? AppColors.greenLight :title=='Pending'?AppColors.orangeLight :title =='On The Way'||title=='one Time'?
      AppColors.secondaryColorWithOpacity16:title=='Coupon Based'?AppColors.secondaryColorWithOpacity8:AppColors.redLight,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Center(
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: title == 'Delivered' ? AppColors.greenColor :
          title=='Pending'?AppColors.orangeColor: title =='On The Way'||title=='one Time'?AppColors.secondary:title=='Coupon Based'?AppColors.secondary:
          AppColors
              .redColor,
          fontSize:fromDeliveryMan?screenWidth*.032: screenWidth * .034,
        ),
      ),
    ),
  );
}
