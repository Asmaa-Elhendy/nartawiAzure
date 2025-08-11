import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/theme/colors.dart';

Widget BuildOrderButtons(
  double screenWidth,
  double screenHeight,
  String status,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: Padding(
          padding: EdgeInsetsGeometry.only(right: screenWidth * .01),
          child: Container(
            padding: EdgeInsetsGeometry.symmetric(
              vertical: screenHeight * .01,
              horizontal:status=='Pending'?screenWidth*.006: screenWidth * .015,
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
                  'assets/images/orders/hugeicons_view.svg',
                  color: AppColors.whiteColor,
                  width: screenWidth * .05,
                  // height: screenHeight*.1,
                ),
                SizedBox(width: screenWidth * .01),
                Flexible(
                  child: Text(
                    'View Details',
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
          ),
        ),
      ),

      Expanded(
        child: Padding(
          padding: EdgeInsetsGeometry.only(right: screenWidth * .01),
          child: Container(
            padding: EdgeInsetsGeometry.symmetric(
              vertical: screenHeight * .01,
              horizontal:status=='Pending'?screenWidth*.006:screenWidth * .015,
            ),
            height: screenHeight * .055,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.blueBorder, // 👈 Border color
                width: 1.5, // 👈 Optional: Border thickness
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/orders/hugeicons_reload.svg',
                  color: AppColors.secondary,
                  width: screenWidth * .05,
                  // height: screenHeight*.1,
                ),
                SizedBox(width: screenWidth * .01),
                Flexible(
                  child: Text(
                    'Re-Order',
                    style: TextStyle(
                      color: AppColors.secondary,
                      fontSize: screenWidth * .029,
                      fontWeight: FontWeight.w600,
                    ), overflow: TextOverflow.visible, // To avoid overflow text
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      status == 'Pending'
          ? Expanded(
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
                      color: AppColors.blueBorder, // 👈 Border color
                      width: 1.5, // 👈 Optional: Border thickness
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: AppColors.secondary,
                              fontSize: screenWidth * .029,
                              fontWeight: FontWeight.w600,

                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : SizedBox(),
    ],
  );
}
