import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/theme/colors.dart';
import '../../../coupons/presentation/widgets/custom_text.dart';

Widget impactFirstCard(double screenWidth,double screenHeight){
  return   Container(
     width: screenWidth,
      padding:  EdgeInsets.symmetric(vertical: screenHeight*.02,horizontal: screenWidth*.04),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.secondaryColorWithOpacity8,

      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  'assets/images/profile/impact/drop-Frame.svg',
                  color: AppColors.primary,
                  width: screenWidth  * .06 ,
                //   height: screenHeight*.08,
                ),SizedBox(width: screenWidth*.02,),
                Text('Bottles Donated',style: TextStyle(color: AppColors.primary,fontWeight: FontWeight.w600,fontSize: screenWidth*.036),),
              ],
            ),
            Padding(
              padding:  EdgeInsets.symmetric(vertical: screenHeight*.01),
              child: customCouponAlertSubTitle('Making A Difference One Bottle At A Time', screenWidth, screenHeight),
            ),
            Row(
              children: [
                customCouponAlertSubTitle('1 (200ml bottles)', screenWidth, screenHeight),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: screenHeight * .02),
              child: LinearProgressIndicator(
                value: 0.4,
                // Represents 70% progress
                backgroundColor: AppColors.primaryLight,
                minHeight: screenHeight * .012,
                borderRadius: BorderRadius.circular(10),
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Progress To Next Milestone',style: TextStyle(fontWeight: FontWeight.w400,fontSize: screenWidth*.034,color: AppColors.greyDarktextIntExtFieldAndIconsHome),),
                Text('1 / 20',style: TextStyle(fontWeight: FontWeight.w400,fontSize: screenWidth*.034,color: AppColors.greyDarktextIntExtFieldAndIconsHome),),

              ],
            ),
          ]));
}