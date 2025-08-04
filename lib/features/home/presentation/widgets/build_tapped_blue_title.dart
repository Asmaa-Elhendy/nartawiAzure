import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';

Widget BuildTappedTitle(String title,double width){
  return Text(title,style: TextStyle(color: AppColors.primary,fontSize:width*.038,fontWeight: FontWeight.w600 ),);
}


Widget BuildStretchTitleHome(double screenWidth,String mainTitle){
  return   Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(mainTitle,style: AppTextStyles.LabelInTextField,),
      BuildTappedTitle('View All',screenWidth),
    ],
  );
}