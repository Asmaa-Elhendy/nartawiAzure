import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';


Widget CancelOrderWidget(BuildContext context,double screenWidth,double screenHeight,String leftTitle,String rightTitle,GestureTapCallback leftOnTap,GestureTapCallback rightOnTap){
  return  Row(
    children: [
      Expanded(
        child: InkWell(
          onTap: leftOnTap,
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
                      fontSize: screenWidth * .034,//.029
                      fontWeight: FontWeight.w500,
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
            onTap:rightOnTap,
            child: Container(
              padding: EdgeInsetsGeometry.symmetric(
                vertical: screenHeight * .01,
                horizontal:screenWidth * .015,
              ),
              height: screenHeight * .055,
              decoration: BoxDecoration(
                border: Border.all(
                  color: rightTitle=='Dispute'?AppColors.blueBorder:AppColors.greyDarktextIntExtFieldAndIconsHome, // 👈 Border color
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
                      color:rightTitle=='Dispute'?AppColors.primary: AppColors.greyDarktextIntExtFieldAndIconsHome,
                      fontSize: screenWidth * .034,
                      fontWeight: FontWeight.w500,
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