import 'package:flutter/material.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../core/theme/text_styles.dart';

Widget BuildTappedTitle(String title,double width){
  return Padding(
    padding:  EdgeInsets.only(left: width*.02),//add space for view all
    child: Text(title,style: TextStyle(color: AppColors.primary,fontSize:width*.036,fontWeight: FontWeight.w500 ),),
  );
}


Widget BuildStretchTitleHome(double screenWidth,String mainTitle,onTap){
  return   Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(mainTitle,style: TextStyle(fontSize: screenWidth*.036,fontWeight: FontWeight.w600)),
      GestureDetector(
          onTap: onTap,
          child: BuildTappedTitle('View All',screenWidth)),
    ],
  );
}