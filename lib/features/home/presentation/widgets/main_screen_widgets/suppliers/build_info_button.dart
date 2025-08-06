import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';

import '../../../../../../core/theme/colors.dart';


Widget BuildInfoButton(
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
        height: height * .05,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Iconify(
              MaterialSymbols.info_outline,
              size: 18,
              color: AppColors.whiteColor,
            ),SizedBox(
              width: width*.02,
            ),
            Text(
              title,
              style: TextStyle(
                color: AppColors.whiteColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}