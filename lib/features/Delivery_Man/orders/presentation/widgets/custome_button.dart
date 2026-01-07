import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/theme/colors.dart';

Widget CustomGradientButton(String icon ,double paddingHorizontal,String title,double screenWidth,double screenHeight){
  return Container(
    padding: EdgeInsetsGeometry.symmetric(
      vertical: screenHeight * .01,
      horizontal:paddingHorizontal,
    ),
    height: screenHeight * .055,
    decoration: BoxDecoration(
      gradient: AppColors.primaryGradient,

      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
icon,          color: AppColors.whiteColor,
          width: screenWidth * .05,
          // height: screenHeight*.1,
        ),
        SizedBox(width: screenWidth * .01),
        Flexible(
          child: Text(
            title,
            style: TextStyle(
              color: AppColors.whiteColor,
              fontSize: screenWidth * .029,
              fontWeight: FontWeight.w600,
            ),        overflow: TextOverflow.visible, // To avoid overflow text
            maxLines: 1,
          ),
        ),
      ],
    ),
  );
}

