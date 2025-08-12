import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';


Widget CancelOrderWidget(BuildContext context,double screenWidth,double screenHeight,String leftTitle,String rightTitle){
  return  Row(
    children: [
      Expanded(
        child: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: Padding(
            padding: EdgeInsetsGeometry.only(right: screenWidth * .01),
            child: Container(
              padding: EdgeInsetsGeometry.symmetric(
                vertical: screenHeight * .01,
                horizontal: screenWidth * .015,
              ),
              height: screenHeight * .055,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,

                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Text(
                    leftTitle,
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: screenWidth * .029,
                      fontWeight: FontWeight.w600,
                    ),        overflow: TextOverflow.visible, // To avoid overflow text
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      Expanded(
        child: Padding(
          padding: EdgeInsetsGeometry.only(right: screenWidth * .01,left:  screenWidth*.01),
          child: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsetsGeometry.symmetric(
                vertical: screenHeight * .01,
                horizontal:screenWidth * .015,
              ),
              height: screenHeight * .055,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.greyDarktextIntExtFieldAndIconsHome, // 👈 Border color
                  width: .5, // 👈 Optional: Border thickness
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Text(
                   rightTitle,
                    style: TextStyle(
                      color: AppColors.greyDarktextIntExtFieldAndIconsHome,
                      fontSize: screenWidth * .029,
                      fontWeight: FontWeight.w600,
                    ), overflow: TextOverflow.visible, // To avoid overflow text
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ],
  );
}