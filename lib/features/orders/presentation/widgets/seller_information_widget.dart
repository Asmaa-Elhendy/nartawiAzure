import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import 'order_image_network_widget.dart';

Widget OrderSellerInformationCard(double screenWidth, double screenHeight) {
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
            'Seller Information',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: screenWidth * .04,
              color: AppColors.primary,
            ),
          ),
        ),
        SizedBox(height:screenHeight*.02 ),

        // Item 1

                Padding(
                  padding:  EdgeInsets.symmetric(vertical: screenHeight*.01),
                  child: Row(mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BuildNetworkOrderImage(screenWidth, screenHeight, imageUrl, 'assets/images/orders/order.jpg'),
                      SizedBox(width: screenWidth*.03,),

                      Center(child: Text('Company 1',style: TextStyle(fontWeight: FontWeight.w600,fontSize: screenWidth*.037),)),

                    ],
                  ),
                ),



      ],
    ),
  );
}

