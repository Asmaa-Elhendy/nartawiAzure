import 'package:flutter/material.dart';


BuildBackgroundLogo(double width,double height){
  return Center(
    child: Image.asset(
      "assets/images/splash/nartawi_logo.png",
      width: width * .25,
      height: height * .2,
    ),
  );
}
