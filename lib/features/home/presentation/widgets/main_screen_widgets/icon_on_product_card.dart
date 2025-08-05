import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

Widget BuildRoundedIconOnProduct({
  required BuildContext context,
  required double width, 
  required double height,
  required bool isPlus,
  int price = 0, 
  required VoidCallback onIncrease,
  required VoidCallback onDecrease,
  required TextEditingController quantityCntroller,
  ValueChanged<String>? onTextfieldChanged,
  VoidCallback? onDone,
}){
  return Container(

    width: isPlus?width*.22:width*.15, // الحجم العرض
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
    //  isPlus?
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            GestureDetector(
              onTap: onDecrease,
              child: Iconify(
                      Ic.baseline_minus, // استبدلها بالأيقونة اللي تحبها
              size: height*.032,
              color: Colors.red,
                        ),
            ),
          // Center(
          //   child: Padding(
          //     padding:  EdgeInsets.symmetric(horizontal: width*.014),
          //     child: Text('$quantity',style: TextStyle(fontWeight: FontWeight.w700),),
          //   ),
          // ),
          Container(
            width: width * 0.07,
            height: height * 0.04,
            alignment: Alignment.center,
            child: TextField(
              controller: quantityCntroller,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: TextStyle(fontWeight: FontWeight.w700),
              onChanged: onTextfieldChanged,
              onEditingComplete: onDone,
              onSubmitted: (value){
              FocusScope.of(context).unfocus();
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        GestureDetector(
          onTap: onIncrease,
          child: Icon(
              Icons.add, // استبدلها بالأيقونة اللي تحبها
              size: height*.032,
              color: Colors.green,
            ),
        )

        ],
      )
            //:
      // Row(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //
      //     Center(
      //       child: Padding(
      //         padding:  EdgeInsets.symmetric(horizontal: width*.01),
      //         child: Text('$price',style: TextStyle(fontWeight: FontWeight.w700),),
      //       ),
      //     ),
      //
      //
      //   ],
      // )
    ),
  );
}