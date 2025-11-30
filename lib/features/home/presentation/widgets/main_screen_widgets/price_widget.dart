import 'package:flutter/material.dart';

import '../../../../../core/theme/colors.dart';


Widget BuildPriceContainer(double screenWidth,double screenHeight,state){
  return      Container(
    width: screenWidth * 0.2, //hanle design shimaa  .3  price in product detail pade
    height: screenHeight * 0.045, 
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: AppColors.backgrounHome,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Padding(
      padding: EdgeInsets.only(left: screenWidth * 0.01, right: screenWidth * 0.01),
      child: Center(
        child: Text(
          '${(state.price).toStringAsFixed(1)}',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: screenWidth * 0.036,
            color: Colors.black,
          ),
          maxLines: 1,
          overflow: TextOverflow.visible,
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );
}