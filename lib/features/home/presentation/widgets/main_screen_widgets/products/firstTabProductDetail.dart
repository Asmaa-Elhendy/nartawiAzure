import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/mdi.dart';

import '../../../../../../core/theme/colors.dart';
Widget BuildFirstTabProductDetail(double screenWidth,double screenHeight){
  return  Column(
    children: [
      SizedBox(height: screenHeight*.03,),
      Row(
        children: [
          Expanded(child: BuildTextInProductDetail(screenWidth, screenHeight,'Size : 5 Gallons')),
          SizedBox(width: screenWidth*.02),
          Expanded(child: BuildTextInProductDetail(screenWidth, screenHeight,'pH Level:7.8'))
        ],
      ),SizedBox(height: screenHeight*.01,),
      Row(
        children: [
          Expanded(child: BuildTextInProductDetail(screenWidth, screenHeight,'Sodium : 15mg/L')),
          SizedBox(width: screenWidth*.02),
          Expanded(child: BuildTextInProductDetail(screenWidth, screenHeight,'pH 7.5'))
        ],
      ),SizedBox(height: screenHeight*.01,),
      Row(
        children: [
          Expanded(child: BuildTextInProductDetail(screenWidth, screenHeight,'Vendor Information : company1 ',isBottom: true))

        ],
      )
    ],
  );
}

Widget BuildTextInProductDetail(double screenWidth,double screenHeight,String title,{bool isBottom=false}){
  return  Container(
      margin: EdgeInsets.only(right: screenWidth*.01),
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * .02,
        vertical: screenHeight * .015,//j
      ),
      decoration: BoxDecoration(
        color: Color(0xfffeaeaea),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(mainAxisAlignment:isBottom?MainAxisAlignment.spaceBetween :MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: screenWidth * .034, // larger font for all
                fontWeight: FontWeight.w500,
                color: AppColors.greyDarktextIntExtFieldAndIconsHome
            ),
            //    overflow: TextOverflow.ellipsis, // optional
            maxLines: 1,
            softWrap: true, // يسمح باللف
            overflow: TextOverflow.visible, // يمنع القص
          ),
          isBottom?
          Iconify(
            MaterialSymbols.arrow_forward_ios,
            size: 16,
            color: AppColors.greyDarktextIntExtFieldAndIconsHome,
          )
              :SizedBox()
        ],
      ));
}