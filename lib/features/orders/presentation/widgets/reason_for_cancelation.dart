import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import 'order_image_network_widget.dart';

Widget ReasonForCancellationCard(double screenWidth, double screenHeight) {
  String imageUrl='';

  return Container(
    margin: EdgeInsets.symmetric(
      vertical: screenHeight * .02,
    ),
    padding: EdgeInsets.symmetric(
      vertical: screenHeight * .02,
      horizontal: screenWidth * .03,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: AppColors.whiteColor,
      // boxShadow: [
      //   BoxShadow(
      //     color: AppColors.shadowColor,
      //     offset: Offset(0, 2),
      //     blurRadius: 8,
      //     spreadRadius: 0,
      //   ),
      // ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title
        Center(
          child: Text(
            'Reason For Cancellation',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: screenWidth * .04,
            ),
          ),
        ),
        SizedBox(height:screenHeight*.02 ),


        Text('The order was very late and I bought it from another place',
          style: TextStyle(color: AppColors.redColor,
            fontSize: screenWidth * .04,
            fontWeight: FontWeight.w300,),)


      ],
    ),
  );
}

