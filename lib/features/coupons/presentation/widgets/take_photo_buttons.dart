import 'package:flutter/material.dart';
import 'package:newwwwwwww/features/coupons/presentation/widgets/oulined_icon_button.dart';

import '../../../../core/theme/colors.dart';


Widget TakePhotosButtonsWidget(BuildContext context,double screenWidth,double screenHeight,String leftTitle,String rightTitle,GestureTapCallback leftOnTap,GestureTapCallback rightOnTap){
  return  Row(
    children: [
      Expanded(
        child:BuildOutlinedIconButton(screenWidth, screenHeight, leftTitle, leftOnTap),
      ),
      Expanded(
        child:BuildOutlinedIconButton(screenWidth, screenHeight, rightTitle, rightOnTap),
      ),
    ],
  );
}