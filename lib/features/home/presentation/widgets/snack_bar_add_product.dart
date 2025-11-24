import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';

showSnackBarAddProduct(BuildContext context, double screenWidth, double screenHeight, String title) {
  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primary,
        // 👇 هنا نخليه مايتقفلش غير لما المستخدم يدوس Close
        duration: Duration(days: 1),
        margin: EdgeInsets.only(
          left: screenWidth * .02,
          right: screenWidth * .02,
          bottom: screenHeight * .004,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * .035,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
              child: Text(
                "Confirm",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * .035,   // 👈 تحكّمي في الحجم
                  //   fontWeight: FontWeight.bold,
                ),
              ),
            ),SizedBox(width: screenWidth*.02,)
,            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * .035,   // 👈 تحكّمي في الحجم
                  //   fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
}
