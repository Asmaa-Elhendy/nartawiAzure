import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';

showSnackBarWarning(BuildContext context, double screenWidth, double screenHeight, String title) {
  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primary,
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
                "Close",
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
