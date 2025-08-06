import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF095BA8);
  static const secondary = Color(0xFF00A0DC);
  static final primaryWithOpacity = primary.withAlpha(204); // 80
  static final fillColorTextFilled=Color(0xffFCFCFC);//Colors.black.withValues(alpha: 0.08);
 static const textIntExtFieldAndIconsHome=Color(0xff737373);
 static const textFieldBorderColor=Color(0xffBDBDBD);
  static const whiteColor=Colors.white;
  static const textDark = Color(0xFF03045E);
  static const textLight = Color(0xFF303030);
  static const textSecondary = Color(0xFF6E7582);
  static const dividerAndIconColor=Color(0xffBDBDBD);
  static final blueBorder=primary.withValues(alpha: 0.48);
  static final backgrounHome=Color(0xFFeef3f5);
// Add more as needed
  static const Color darkBlue = Color(0xFF095BA8);
  static const Color lightBlue = Color(0xFF00A0DC);
  static final  Color secondaryColorWithOpacity8=Color(0xFFdbedf4);
  static final Secondary48=secondary.withValues(alpha: 0.48);
  static const shadowColor= Color(0xffced3d4);
  static const greenColor=Color(0xff27ae60);
  static final greenLight=Color(0xffdaf0e3);
  static const orangeColor=Color(0xffF9B908);
  static final orangeLight=orangeColor.withValues(alpha: 0.16);


  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      darkBlue,
      lightBlue,
    ],
    stops: [0.0, 1.0], // optional; default values
  );
}
