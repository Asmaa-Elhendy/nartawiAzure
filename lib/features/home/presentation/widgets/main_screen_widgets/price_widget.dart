import 'package:flutter/material.dart';

import '../../../../../core/theme/colors.dart';


Widget BuildPriceContainer(double screenWidth,double screenHeight,state){
  return      Container(
    padding: EdgeInsets.all(screenHeight*.005),
    width: screenWidth * .15,
    height: screenHeight * .045,
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
    child: Center(
      child: Text(
        '${(state.price).toStringAsFixed(2)}',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: screenWidth * 0.034,
        ),overflow: TextOverflow.ellipsis,
      ),
    ),
  );
}