import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';

import '../../../../core/theme/colors.dart';


Widget BuildSingleSeetingProfile(double screenWidth, double screenHeight,String icon,String title,Function()? fun){
  return InkWell(
    onTap: fun,
    child: Container(
        margin:  EdgeInsets.symmetric(
      vertical: screenHeight * .01,
    ),
        padding: EdgeInsets.symmetric(
          vertical: screenHeight * .02,
          horizontal: screenWidth * .02,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.whiteColor,

        ),
      child:Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        Row(
          children: [
            SvgPicture.asset(
              icon,
              height: screenHeight * .028,
            ),
            SizedBox(width: screenWidth*.04,),
            Text(title,style: TextStyle(fontWeight: FontWeight.w500,fontSize:screenWidth*.036),),
          ],
        ),
          Iconify(
            MaterialSymbols.arrow_forward_ios,
            size: screenWidth*.04,
          )
      ],) ,
    ),
  );
}