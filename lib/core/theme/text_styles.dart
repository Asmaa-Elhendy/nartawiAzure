import 'package:flutter/material.dart';
import 'colors.dart';

class AppTextStyles {
  static const TextStyle textInTextField = TextStyle(
    fontSize: 14,

    color: AppColors.greyDarktextIntExtFieldAndIconsHome,
  );
  static const TextStyle LabelInTextField = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textLight,
    fontFamily: 'Poppins',
  );
  static const TextStyle TitlePage =  TextStyle(fontSize: 16,color: AppColors.textLight,fontWeight: FontWeight.w400);
  static const TextStyle heading1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  static const TextStyle bodyText = TextStyle(
    fontSize: 16,
    color: AppColors.textDark,
  );

  static TextTheme textTheme = TextTheme(
    displayLarge: heading1,
    bodyLarge: bodyText,
    // Add more mappings
  );
}
