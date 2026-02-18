import 'package:flutter/material.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/suppliers/supplier_reaings_card.dart';

Widget BuildSecondTabProductDetail(double screenWidth, double screenHeight,BuildContext context) {
  List<int> items = [1, 2, 3, 4, 5];

  return Padding(
    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BuildSupplierRatingCard(context,
          screenWidth,
          screenHeight,

          mainTitle: 'User 1',
          isFromProductDetail: true,
          overallRating: 2,
          totalReviews: 3,
          orderAvg: 5,
          sellerAvg: 2,
          deliveryAvg: 1,
        ),
        SizedBox(height: screenHeight * 0.01),
        BuildSupplierRatingCard(context,
          screenWidth,
          screenHeight,
          mainTitle: 'User 1',
          isFromProductDetail: true,
          overallRating: 2,
          totalReviews: 3,
          orderAvg: 5,
          sellerAvg: 2,
          deliveryAvg: 1,
        ),
        SizedBox(height: screenHeight * 0.05),
      ],
    ),
  );
}
