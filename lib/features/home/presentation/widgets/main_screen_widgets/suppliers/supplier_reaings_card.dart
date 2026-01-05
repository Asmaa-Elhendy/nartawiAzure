import 'package:flutter/material.dart';

import '../../../../../../core/theme/colors.dart';
import '../../../../../../core/theme/text_styles.dart';
import 'build_row_of_stars_ratings.dart';

Widget BuildSupplierRatingCard(
    double screenWidth,
    double screenHeight, {
      required String mainTitle,
      required double overallRating,
      required int totalReviews,
      required double orderAvg,
      required double sellerAvg,
      required double deliveryAvg,
      bool isFromProductDetail = false,
    }) {
  // ✅ helper: rating (0..5) -> [1,1,1,0,0]
  List<int> _starsFromRating(double rating) {
    final r = rating.clamp(0.0, 5.0);
    final full = r.floor();
    // لو تحبي rounding بدل floor: final full = r.round();
    return List<int>.generate(5, (i) => i < full ? 1 : 0);
  }

  final overallStars = _starsFromRating(overallRating);
  final orderStars = _starsFromRating(orderAvg);
  final sellerStars = _starsFromRating(sellerAvg);
  final deliveryStars = _starsFromRating(deliveryAvg);

  return Container(
    width: screenWidth,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: isFromProductDetail ? AppColors.tabViewBackground : AppColors.whiteColor,
    ),
    child: Padding(
      padding: EdgeInsets.only(
        left: screenWidth * 0.04,
        right: screenWidth * 0.04,
        top: screenHeight * 0.01,
        bottom: screenHeight * 0.01,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            mainTitle,
            style: TextStyle(
              fontSize: screenWidth * .04,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: screenHeight * .01),

          Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // -------- LEFT: OVERALL --------
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Over All', style: AppTextStyles.titleRating),
                    Text('($totalReviews Review)', style: AppTextStyles.titleRating),

                    // ✅ same function لكن بدل items الثابتة
                    BuildRowOfRatings('', overallStars, screenHeight, screenWidth),
                  ],
                ),

                // divider
                Padding(
                  padding: EdgeInsets.only(
                    left: screenWidth * .1,
                    right: screenWidth * .02,
                  ),
                  child: SizedBox(
                    height: screenHeight * 0.15,
                    child: VerticalDivider(
                      color: AppColors.backgrounHome,
                      thickness: 1,
                      width: screenWidth * .04,
                    ),
                  ),
                ),

                // -------- RIGHT: DETAILS --------
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    BuildRowOfRatings('Order Experience', orderStars, screenHeight, screenWidth),
                    BuildRowOfRatings('Seller Experience', sellerStars, screenHeight, screenWidth),
                    BuildRowOfRatings('Delivery Experience', deliveryStars, screenHeight, screenWidth),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
