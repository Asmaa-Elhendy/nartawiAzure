import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';

import '../../../../../../core/theme/text_styles.dart';

BuildRowOfRatings(String title,List items,double screenHeight,double screenWidth){
  return   Column(
    mainAxisSize: MainAxisSize.min,
    children: [
    title==''?SizedBox():  Text(title,style: AppTextStyles.titleRating),
      Padding(
        padding:  EdgeInsets.only(bottom:screenHeight*.02,top:  title==''?screenHeight*.02:screenHeight*.01,),
        child: Row(
          children: items
              .map(
                (item) => Iconify(
              MaterialSymbols.star,
              // This uses the Material Symbols "star" icon
              size: screenHeight * .019,
              color: Colors.amber,
            ),
          )
              .toList(),
        ),
      ),
    ],
  );
}