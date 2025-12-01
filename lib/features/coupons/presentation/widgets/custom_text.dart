import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';

Widget customCouponSecondaryTitle(String title,double width,double height){
  return Text(title,style: TextStyle(color: AppColors.primary,fontSize: width*.034,fontWeight: FontWeight.w400),);
}
Widget customCouponSecondaryTitleCarous(String title,double width,double height){
  return Text(title,style: TextStyle(color: AppColors.primary,fontSize: width*.032,fontWeight: FontWeight.w400),);
}


Widget customCouponPrimaryTitle(String title,double width,double height){
  return  Text(title,style: TextStyle(fontWeight: FontWeight.w700,fontSize: width*.036),);
}

Widget customCouponAlertTitle(String title,double width,double height){
  return  Text(title,style: TextStyle(fontWeight: FontWeight.w600,fontSize: width*.036),);
}

Widget TEXTextConfirmationAlertTitle(String title,double width,double height){
  return  Text(title,style: TextStyle(fontWeight: FontWeight.w600,fontSize: width*.034),);
}

Widget customCouponAlertSubTitle(String title,double width,double height){
return  Text(title,style: TextStyle(fontWeight: FontWeight.w400,fontSize: width*.036),);
}