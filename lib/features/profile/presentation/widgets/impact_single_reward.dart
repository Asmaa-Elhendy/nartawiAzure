import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

import '../../../../core/theme/colors.dart';
import '../../../coupons/presentation/widgets/custom_text.dart';

Widget ImpactSngleReward(
    {required double screenWidth, required double screenHeight, required String title, required String description, required String icon, required String date}){
  return Row(crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Iconify(
        icon,   // this is "icons/la:award"
        size: screenWidth  * .06,
        color: AppColors.primary
        ,
      ),SizedBox(width: screenWidth*.02,),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            customCouponAlertTitle(title,screenWidth,screenHeight),
            Padding(
              padding:  EdgeInsets.symmetric(vertical: screenHeight*.01),
              child: Text(description,
                  style: TextStyle(fontWeight: FontWeight.w400,
                      fontSize: screenWidth*.034,color: AppColors.greyDarktextIntExtFieldAndIconsHome),
                  softWrap: true,      // allow wrapping
                  overflow: TextOverflow.visible
              ),
            ),
            date==''?SizedBox():
            Padding(
              padding:  EdgeInsets.only(bottom: screenHeight*.01),
              child: Text(date,
                  style: TextStyle(fontWeight: FontWeight.w400,
                      fontSize: screenWidth*.034,color: AppColors.greyDarktextIntExtFieldAndIconsHome),
                  softWrap: true,      // allow wrapping
                  overflow: TextOverflow.visible
              ),
            ),

          ],),
      ),
    ],
  );
}