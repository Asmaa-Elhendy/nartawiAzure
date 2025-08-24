import 'package:flutter/material.dart';
import 'package:newwwwwwww/core/theme/text_styles.dart';
import 'colors.dart';


class AppTheme {
  static ThemeData lightTheme = ThemeData(
    dialogBackgroundColor: AppColors.backgroundAlert,
    fontFamily: 'Poppins',
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: Colors.white,
    textTheme: TextTheme(
      displayLarge: AppTextStyles.heading1,
      bodyLarge: AppTextStyles.bodyText,
      // Add other text styles as needed
    ).apply(
      bodyColor: AppColors.textDark,
      displayColor: AppColors.textDark,
      fontFamily: 'Poppins',
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xfffcfcfc),
      elevation: 1,
      iconTheme: IconThemeData(color: AppColors.primary),
      titleTextStyle: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    dialogBackgroundColor: AppColors.backgroundAlert,
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    textTheme: TextTheme(
      displayLarge: AppTextStyles.heading1.copyWith(color: Colors.white),
      bodyLarge: AppTextStyles.bodyText.copyWith(color: Colors.white70),
      // Add other text styles as needed
    ).apply(
      bodyColor: Colors.white70,
      displayColor: Colors.white,
      fontFamily: 'Poppins',
    ),
  );
}
