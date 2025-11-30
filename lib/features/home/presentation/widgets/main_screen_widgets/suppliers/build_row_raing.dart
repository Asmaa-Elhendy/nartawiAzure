import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';

Widget BuildRowRating(double screenWidth,double screenHeight ,
    {String title = ''}){
  return  Row(crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Iconify(
        MaterialSymbols.star,  // This uses the Material Symbols "star" icon
        size: screenHeight*.023,
        color: Colors.amber,
      ),
      //  SizedBox(width: screenWidth*.01,),
      Text(title==''?'5.0':title,style: TextStyle(fontSize: screenWidth*.034,fontWeight: FontWeight.w500))
    ],

  );
}