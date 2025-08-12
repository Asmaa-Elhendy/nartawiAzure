import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/icon_park_solid.dart';

import '../../../../core/theme/colors.dart';

Widget BuildOutlinedIconButton(
    double width,
    double height,
    String title,
    void Function()? fun,

    ) {
  return Padding(
    padding:  EdgeInsets.symmetric(vertical: height*.01),
    child: InkWell(
      onTap: fun,
      child: Container(
        //  width:  widget.width * .38,
        height:     height * .05,
        decoration: BoxDecoration(
          border: Border.all( // هنا أضفنا البوردر
            color: AppColors.blueBorder, // لون البوردر
            width: .5,               // سمك البوردر
          ),
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Iconify(
              IconParkSolid.history_query,  // This uses the Material Symbols "star" icon
              size:width*.052,
              color: AppColors.primary,
            ),
            SizedBox(width: width*.02,),
            Text(
              title,
              style: TextStyle(
                color: AppColors.primary,
                fontSize: width*.034,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}