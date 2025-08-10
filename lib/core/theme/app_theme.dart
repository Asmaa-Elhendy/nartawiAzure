import 'package:flutter/material.dart';
import 'package:newwwwwwww/core/theme/text_styles.dart';
import 'colors.dart';


class AppTheme {
  static ThemeData lightTheme = ThemeData(
    dialogBackgroundColor: AppColors.backgroundAlert,
    fontFamily: 'Poppins',
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: Colors.white,
    textTheme: AppTextStyles.textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xfffcfcfc),
      elevation: 1,
      iconTheme: IconThemeData(color: AppColors.primary),
    ),
    // Add other theme configurations
  );

  static ThemeData darkTheme = ThemeData(
    dialogBackgroundColor: AppColors.backgroundAlert,

    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    textTheme: AppTextStyles.textTheme,
  );
}
