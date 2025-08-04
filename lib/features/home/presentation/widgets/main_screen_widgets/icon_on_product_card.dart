import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:newwwwwwww/core/theme/colors.dart';

Widget BuildIconOnProduct(double width,double height,bool isPlus){
  return Container(
    width: width*.1, // الحجم العرض
    height: height*.045, // الحجم الارتفاع
    decoration: BoxDecoration(
      color: AppColors.backgrounHome, // لون الخلفية
      shape: BoxShape.circle, // يجعله دائري
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Center(
      child: isPlus?

      Icon(
        Icons.add, // استبدلها بالأيقونة اللي تحبها
        size: height*.03,
        color: AppColors.primary,
      ):Iconify(
        Mdi.heart_outline,
        color: AppColors.primary,
        size:height*.03,
      ),
    ),
  );
}

Widget BuildRoundedIconOnProduct(double width,double height,bool isPlus){
  return Container(
    width: isPlus?width*.18:width*.15, // الحجم العرض
    height: height*.045, // الحجم الارتفاع
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: AppColors.backgrounHome, // لون الخلفية
      shape: BoxShape.rectangle, // يجعله دائري
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Center(
      child:
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isPlus?      Iconify(
        Ic.baseline_minus, // استبدلها بالأيقونة اللي تحبها
            size: height*.03,
            color: Colors.red,
          ):SizedBox(),
          Center(
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: width*.01),
              child: Text('5',style: TextStyle(fontWeight: FontWeight.w700),),
            ),
          ),
          isPlus? Icon(
            Icons.add, // استبدلها بالأيقونة اللي تحبها
            size: height*.03,
            color: Colors.green,
          ):
          SizedBox()

        ],
      )
    ),
  );
}