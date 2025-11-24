import 'package:flutter/material.dart';
import 'colors.dart';

class AppTextStyles {
  static const TextStyle textInTextField = TextStyle(
    fontSize: 12,
    fontFamily: 'Poppins',
    color: AppColors.greyDarktextIntExtFieldAndIconsHome,
  );
  
  static const TextStyle LabelInTextField = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textLight,
    fontFamily: 'Poppins',
  );
  
  static const TextStyle TitlePage = TextStyle(
    fontSize: 16,
    color: AppColors.textLight,
    fontWeight: FontWeight.w400,
    fontFamily: 'Poppins',
  );

  
  static const TextStyle titleRating = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    fontFamily: 'Poppins',
  );
  
  static const TextStyle textSummaryStyle = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 12,
    fontFamily: 'Poppins',
  );
  
  static const TextStyle heading1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
    fontFamily: 'Poppins',
  );

  static const TextStyle bodyText = TextStyle(
    fontSize: 16,
    color: AppColors.textDark,
    fontFamily: 'Poppins',
  );

  static TextTheme textTheme = TextTheme(
    displayLarge: heading1,
    bodyLarge: bodyText,
    // Add more mappings
  );
}
