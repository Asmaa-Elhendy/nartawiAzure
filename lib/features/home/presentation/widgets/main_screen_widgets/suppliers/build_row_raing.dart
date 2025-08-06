import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';

Widget BuildRowRating(double screenWidth,double screenHeight ){
  return  Row(
    children: [
      Iconify(
        MaterialSymbols.star,  // This uses the Material Symbols "star" icon
        size: screenHeight*.03,
        color: Colors.amber,
      ),
      //  SizedBox(width: screenWidth*.01,),
      Text('5.0',style: TextStyle(fontSize: screenWidth*.035,fontWeight: FontWeight.w500))
    ],

  );
}