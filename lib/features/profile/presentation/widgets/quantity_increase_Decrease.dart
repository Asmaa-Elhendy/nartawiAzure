import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';

import '../../../../core/theme/colors.dart';

Widget IncreaseDecreaseQuantity({
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
  bool fromDetailedScreen=false,
  required String title
}){
  return Container(
    padding: fromDetailedScreen?EdgeInsets.symmetric(horizontal: width*.02):EdgeInsets.zero,
    width:fromDetailedScreen?width*.6:width*.2, // الحجم العرض
    height: height*.045, // الحجم الارتفاع
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: AppColors.backgrounHome, // لون الخلفية
      shape: BoxShape.rectangle, // يجعله دائري
      // boxShadow: [
      //   BoxShadow(
      //     color: Colors.black.withOpacity(0.1),
      //     blurRadius: 4,
      //     offset: Offset(0, 2),
      //   ),
      // ],
    ),
    child: Center(
        child:
        //  isPlus?
        Row(
          mainAxisAlignment:fromDetailedScreen? MainAxisAlignment.spaceBetween: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: onDecrease,
              child: Iconify(
                Ic.baseline_minus, // استبدلها بالأيقونة اللي تحبها
                size: height*.03,
                color: AppColors.redColor,
              ),
            ),
            Row(
              children: [
                Container(
                  width: width * 0.1,
                  height: height * 0.04,
                  alignment: Alignment.center,
                  child: TextField(
                    controller: quantityCntroller,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style:
                    TextStyle(fontWeight: FontWeight.w700,   fontSize: width * 0.034,overflow: TextOverflow.ellipsis,color: AppColors.textLight
                    ),
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
                SizedBox(width: width*.01,),
                Text(title,style: TextStyle(fontWeight: FontWeight.w700,fontSize: width*.034),),
              ],
            ),

            GestureDetector(
              onTap: onIncrease,
              child: Icon(
                Icons.add, // استبدلها بالأيقونة اللي تحبها
                size: height*.03,
                color: AppColors.greenColor,
              ),
            )

          ],
        )

    ),
  );
}