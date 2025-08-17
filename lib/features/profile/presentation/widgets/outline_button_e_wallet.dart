import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/icon_park_solid.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:iconify_flutter/icons/mingcute.dart';

import '../../../../core/theme/colors.dart';

Widget BuildOutlinedEwalletButton(
  double width,
  double height,
  String title,
  String icon,
  void Function()? fun,
) {
  return Padding(
    padding: EdgeInsets.symmetric(
      vertical: height * .01,
      horizontal: width * .01,
    ),

    child: InkWell(
      onTap: fun,
      child: Container(
        //  width:  widget.width * .38,
        height: height * .05,
        decoration: BoxDecoration(
          border: Border.all(
            // هنا أضفنا البوردر
            color: AppColors.blueBorder, // لون البوردر
            width: .5, // سمك البوردر
          ),
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(icon, width: width * .05),
            SizedBox(width: width * .02),
            Text(
              title,
              style: TextStyle(
                color: AppColors.secondary,
                fontSize: width * .034,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildRowButtons({
  required double screenWidth,
  required double screenHeight,
  required String leftTitle,
  required String rightTitle,
  required String leftIcon,
  required String rightIcon,
  required void Function()? fun1,
  required void Function()? fun2,
}) {
  return Row(
    children: [
      Expanded(
        child: BuildOutlinedEwalletButton(
          screenWidth,
          screenHeight,
          leftTitle,
          leftIcon,
          fun1,
        ),
      ),
      Expanded(
        child: BuildOutlinedEwalletButton(
          screenWidth,
          screenHeight,
          rightTitle,
          rightIcon,
          fun2,
        ),
      ),
    ],
  );
}
