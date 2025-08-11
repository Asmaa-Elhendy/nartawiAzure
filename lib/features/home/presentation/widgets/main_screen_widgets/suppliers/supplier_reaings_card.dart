import 'package:flutter/material.dart';

import '../../../../../../core/theme/colors.dart';
import '../../../../../../core/theme/text_styles.dart';
import 'build_row_of_stars_ratings.dart';

Widget BuildSupplierRatingCard(double screenWidth,double screenHeight,List items,String mainTitle,{bool isFromProductDetail=false}){
  return  Container(
    //   height: screenHeight*.3,
    width: screenWidth,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: isFromProductDetail?
          AppColors.tabViewBackground
          :AppColors.whiteColor,
    ),
    child: Padding(
      padding: EdgeInsets.only(
        left: screenWidth * 0.04,
        right: screenWidth * 0.04,
        top: screenHeight * 0.01,
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
          SizedBox(height: screenHeight*.01,),
          Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Over All',style: AppTextStyles.titleRating),
                    Text('( Review )',style: AppTextStyles.titleRating,),

                    BuildRowOfRatings('',items, screenHeight,screenWidth)
                  ],
                ),

                Center(
                  child: Padding(
                    padding:  EdgeInsets.only(left: screenWidth*.1,right: screenWidth*.02),
                    child: Container(
                      height: screenHeight * 0.15,
                      child: VerticalDivider(
                        color: AppColors.backgrounHome,
                        thickness: 1,
                        width: screenWidth * .04,
                      ),
                    ),//j
                  ),
                ),

                Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      BuildRowOfRatings('Order Experience',items, screenHeight,screenWidth),

                      BuildRowOfRatings('Seller Experience',items, screenHeight,screenWidth),

                      BuildRowOfRatings('Delivery Experience',items, screenHeight,screenWidth)

                    ]),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}