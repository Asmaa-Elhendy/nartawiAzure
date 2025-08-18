import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';

import '../../../../core/theme/colors.dart';

Widget ProductTitle(double screenHeight, double screenWidth) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          Container(
            //   width: widget.screenWidth * .04,
            // الحجم العرض
            height: screenHeight * .03,
            // الحجم الارتفاع
            decoration: BoxDecoration(
              color: AppColors.backgrounHome, // لون الخلفية
              shape: BoxShape.circle, // يجعله دائري
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Image.asset(
              "assets/images/home/main_page/company.png",
              height: screenHeight * .03, //
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: screenWidth * .02),
          Text(
            'Company',
            style: TextStyle(
              fontSize: screenWidth * .032,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Iconify(
            MaterialSymbols.star, // This uses the Material Symbols "star" icon
            size: screenHeight * .025,
            color: Colors.amber,
          ),
          SizedBox(width: screenWidth * .01),
          Text(
            '5.0',
            style: TextStyle(
              fontSize: screenWidth * .03,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ],
  );
}
