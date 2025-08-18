import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';

Widget RowOutlineButtons(
  BuildContext context,
  double screenWidth,
  double screenHeight,
  String leftTitle,
  String rightTitle,
  void Function()? leftFun,
  void Function()? rightFun,
) {
  return Padding(
    padding:  EdgeInsets.symmetric(vertical: screenHeight*.01),
    child: Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: leftFun,
            child: Padding(
              padding: EdgeInsetsGeometry.only(right: screenWidth * .01),
              child: Container(
                padding: EdgeInsetsGeometry.symmetric(
                  vertical: screenHeight * .01,
                  horizontal: screenWidth * .015,
                ),
                height: screenHeight * .055,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.blueBorder,
                    // 👈 Border color
                    width: .5, // 👈 Optional: Border thickness
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        leftTitle,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: screenWidth * .036,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: rightFun,
            child: Padding(
              padding: EdgeInsetsGeometry.only(left: screenWidth * .01),
              child: Container(
                padding: EdgeInsetsGeometry.symmetric(
                  vertical: screenHeight * .01,
                  horizontal: screenWidth * .015,
                ),
                height: screenHeight * .055,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.greyDarktextIntExtFieldAndIconsHome,
                    // 👈 Border color
                    width: .5, // 👈 Optional: Border thickness
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                       rightTitle,
                        style: TextStyle(
                          color: AppColors.greyDarktextIntExtFieldAndIconsHome,
                          fontSize: screenWidth * .036,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
