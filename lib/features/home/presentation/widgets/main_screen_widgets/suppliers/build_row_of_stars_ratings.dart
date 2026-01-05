import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import '../../../../../../core/theme/text_styles.dart';

Widget BuildRowOfRatings(
    String title,
    List<int> items,
    double screenHeight,
    double screenWidth,
    ) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      title == '' ? const SizedBox() : Text(title, style: AppTextStyles.titleRating),
      Padding(
        padding: EdgeInsets.only(
          bottom: screenHeight * .02,
          top: title == '' ? screenHeight * .02 : screenHeight * .01,
        ),
        child: Row(
          children: items.map((v) {
            final bool filled = v == 1;

            return Padding(
              padding: EdgeInsets.only(right: screenWidth * .005),
              child: Iconify(
                filled ? MaterialSymbols.star : MaterialSymbols.star_outline,
                size: screenHeight * .019,
                color: Colors.amber,
              ),
            );
          }).toList(),
        ),
      ),
    ],
  );
}
