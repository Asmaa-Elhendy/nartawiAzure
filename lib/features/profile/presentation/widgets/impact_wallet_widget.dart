import 'package:flutter/material.dart';
import 'package:newwwwwwww/core/theme/text_styles.dart';
import 'package:newwwwwwww/features/coupons/presentation/widgets/custom_text.dart';

import '../../../../core/theme/colors.dart';

Widget ImpactWalletWidget(double screenWidth, double screenHeight,Function()? myImpactFun,Function()? myeWalletFun) {
  return Container(

    padding: EdgeInsets.symmetric(
      vertical: screenHeight * .02,
      horizontal: screenWidth * .03,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: AppColors.whiteColor,

    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: myImpactFun,
                child: SizedBox(//height: screenHeight*.1,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('My Impact ', style: TextStyle(fontSize: screenWidth*.036,fontWeight: FontWeight.w600,color: AppColors.primary)),
                        customCouponAlertSubTitle('1', screenWidth, screenHeight)   ,
                        SizedBox(height: screenHeight*.01),
                        customCouponAlertSubTitle('Bottles Donated', screenWidth, screenHeight)
                      ],
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(

            //  height: screenHeight * 0.1,
              width: 20,
              child: VerticalDivider(
                color: AppColors.backgrounHome,
                thickness: 1,
              ),
            ),

            Expanded(
              child: SizedBox(//height: screenHeight*.1,
                child: InkWell(
                  onTap: myeWalletFun,
                  child: Center(
                    child: Column(mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('My e-Wallet ', style: TextStyle(fontSize: screenWidth*.036,fontWeight: FontWeight.w600,color: AppColors.primary)),
                        customCouponAlertSubTitle('QAR 840.00', screenWidth, screenHeight)   ,
                        SizedBox(height: screenHeight*.01),
                        customCouponAlertSubTitle('Available Balance', screenWidth, screenHeight)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

      ],
    ),
  );
}
