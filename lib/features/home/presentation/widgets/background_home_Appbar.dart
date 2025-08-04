import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget buildBackgroundAppbar(double screenWidth){
  return   Positioned(
    top: 0,
    left: 0,
    right: 0,
    child: SvgPicture.asset(
      "assets/images/home/rec.svg",
      width: screenWidth,
      fit: BoxFit.cover,
      alignment: Alignment.topCenter,
    ),
  );
}