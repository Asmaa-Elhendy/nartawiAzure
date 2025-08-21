import 'package:flutter/material.dart';

import '../theme/colors.dart';

Widget CouponStatus(double screenHeight,double screenWidth,String status,{bool fromNotification=false}) {
  return Container(
  //  width: screenWidth*.16,
    padding: EdgeInsets.symmetric(
        vertical:screenHeight * .01, horizontal: screenWidth * .02),
    decoration: BoxDecoration(
      color:fromNotification==true&&status=='Read'?AppColors.BorderAnddividerAndIconColor.withValues(alpha: 0.26):
      fromNotification?AppColors.secondaryColorWithOpacity16: status == 'Active' ? AppColors.greenLight :AppColors.primaryLight ,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Center(
      child: Text(
        status,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color:fromNotification==true&&status=='Read'?AppColors.greyDarktextIntExtFieldAndIconsHome: fromNotification?AppColors.secondary:status == 'Active' ? AppColors.greenColor :
          AppColors.primary,

          fontSize: screenWidth * .035,
        ),
      ),
    ),
  );
}
