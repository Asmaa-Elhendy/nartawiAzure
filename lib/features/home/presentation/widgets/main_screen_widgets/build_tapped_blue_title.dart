import 'package:flutter/material.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../core/theme/text_styles.dart';

Widget BuildTappedTitle(String title,double width){
  return Text(title,style: TextStyle(color: AppColors.primary,fontSize:width*.036,fontWeight: FontWeight.w600 ),);
}


Widget BuildStretchTitleHome(double screenWidth,String mainTitle,onTap){
  return   Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(mainTitle,style: AppTextStyles.LabelInTextField,),
      GestureDetector(
          onTap: onTap,
          child: BuildTappedTitle('View All',screenWidth)),
    ],
  );
}