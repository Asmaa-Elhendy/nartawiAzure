import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/theme/colors.dart';

Widget CustomGradientButton(String icon ,double paddingHorizontal,String title,double screenWidth,double screenHeight,
    {bool ChangedColor=true}){
  return Container(
    padding: EdgeInsetsGeometry.symmetric(
      vertical: screenHeight * .01,
      horizontal:paddingHorizontal,
    ),
    height: screenHeight * .055,
    decoration:ChangedColor? BoxDecoration(
      gradient: AppColors.primaryGradient,

      borderRadius: BorderRadius.circular(8),
    ):BoxDecoration(
     color: AppColors.greyDarktextIntExtFieldAndIconsHome,

      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
icon,          color: AppColors.whiteColor,
          width: screenWidth * .042,
          // height: screenHeight*.1,
        ),
        SizedBox(width: screenWidth * .01),
        Flexible(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis, // ✅
            softWrap: false,                 // ✅
            style: TextStyle(
              color: AppColors.whiteColor,
              fontSize: screenWidth * .029,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

      ],
    ),
  );
}



Widget CustomContainerButton({
  required String icon,
  required String title,
  required double screenWidth,
  required double screenHeight,
  required VoidCallback onTap,
  bool isRed = false, // للـ canceled
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: screenHeight * .055,
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * .01,
        horizontal: screenWidth * .02,
      ),
      decoration: BoxDecoration(
        gradient: isRed ? null : AppColors.primaryGradient,
        color: isRed ? const Color(0xFFF6D6D3) : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          isRed
              ? Icon(
            Icons.close,
            size: screenWidth * .04,
            color: const Color(0xFFD24A3D),
          )
              : SvgPicture.asset(
            icon,
            color: AppColors.whiteColor,
            width: screenWidth * .05,
          ),

          SizedBox(width: screenWidth * .01),

          // Text (take remaining space)
          Flexible(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis, // ✅
              softWrap: false,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isRed ? const Color(0xFFD24A3D) : AppColors.whiteColor,
                fontSize: screenWidth * .029,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),


        ],
      ),
    ),
  );
}
