import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/icon_park_outline.dart';
import 'package:iconify_flutter/icons/icon_park_solid.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';

import '../../../../../../core/theme/colors.dart';


Widget BuildInfoAndAddToCartButton(
    double width,
    double height,
    String title,
    bool info,
    void Function()? fun,
{bool fromOrderDetail=false,bool fromCouponsScreen=false,bool fromDelivery=false}
    ) {
  return Padding(
    padding:  EdgeInsets.symmetric(vertical: height*.01),
    child: InkWell(
      onTap: fun,
      child: Container(
        //  width:  widget.width * .38,
        height:        fromOrderDetail==true?height*.07: height * .06,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center,
          children: [
          fromDelivery?SizedBox():
          fromCouponsScreen?
            Iconify(
              IconParkSolid.history_query,  // This uses the Material Symbols "star" icon
              size:width*.052,
              color: AppColors.whiteColor,
            )
        :fromOrderDetail==true?
          Iconify(
          MaterialSymbols.star_outline_rounded,  // This uses the Material Symbols "star" icon
          size:width*.052,
          color: AppColors.whiteColor,
        )
            :info?  Iconify(
              MaterialSymbols.info_outline,
          size:width*.052,
              color: AppColors.whiteColor,
            ):SizedBox()
            ,
            info?  SizedBox(
              width: width*.02,
            ):SizedBox(),
            SizedBox(width: width*.02,),
            Text(
              title,
              style: TextStyle(
                color: AppColors.whiteColor,
                fontSize:fromDelivery?width*.036: width*.035,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


