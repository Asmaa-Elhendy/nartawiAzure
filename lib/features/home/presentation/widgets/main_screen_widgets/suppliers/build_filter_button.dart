import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../../core/theme/colors.dart';

Widget BuildFilterButton(double width, double height, void Function()? fun) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: height * .01),
    child: InkWell(
      onTap: fun,
      child: Container(
        width: width * .12,
        padding: EdgeInsets.symmetric(
          vertical: height * .01,
          horizontal: width * .01,
        ),
        height: height * .065,
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: SvgPicture.asset(
            'assets/images/home/main_page/supplier_detail/filter.svg',
            color: AppColors.whiteColor,
            height: height * .03,
          ),
        ),
      ),
    ),
  );
}

Widget BuildCompareButton(double width, double height, void Function()? fun) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: height * .01),
    child: InkWell(
      onTap: fun,
      child: Container(
        width: width * .12,
        padding: EdgeInsets.symmetric(
          vertical: height * .01,
          horizontal: width * .01,
        ),
        height: height * .065,
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: SvgPicture.asset(
            'assets/images/home/main_page/compare.svg',
            color: AppColors.whiteColor,
            height: height * .03,
          ),
        ),
      ),
    ),
  );
}
