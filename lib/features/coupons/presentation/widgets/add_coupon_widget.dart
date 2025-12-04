import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newwwwwwww/features/home/presentation/pages/all_product_screen.dart';
import 'package:newwwwwwww/features/home/presentation/pages/popular_category_screen.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/utils/components/confirmation_alert.dart';

Widget AddCoupon(BuildContext context,double screenWidth,double screenHeight){
  return InkWell(
    onTap: () {
      showDialog(
        context: context,
        builder: (dialogContext) => ConfirmationAlert(price: 0,
          centerTitle: 'You Already Have 2 Coupons. Continue To Buy Another One?',
          leftTtile: 'Continue Shopping',rightTitle: 'Cancel',
          leftOnTap: () {
            // 👈 ده هيقفل الـ Dialog بس
            Navigator.of(dialogContext).pop();
            // go to products filter by coupons
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PopularCategoryScreen(CategoryName: 'Coupons')),
            );
          },rightOnTap: (){
          Navigator.pop(dialogContext);
        },
        ),
      );
    },
    child: Container(
      width: screenWidth*.1,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primary,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.add,
          color: AppColors.primary,
          size: screenWidth*.065,
        ),
      ),
    ),
  );
}
