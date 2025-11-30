import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/theme/colors.dart';

Widget buildFilterDateWidget(double height, double width, ) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: width * .03),
    width: width*.4,
    height: height * .05,
    decoration: BoxDecoration(
      color: AppColors.whiteColor,
      border: Border.all(
        color: AppColors.BorderAnddividerAndIconColor, // 👈 Border color
        width: 1.5, // 👈 Optional: Border thickness
      ),
      borderRadius: BorderRadius.circular(24),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(
              "assets/images/orders/calendar.svg",
              width: width * .03,
              color: AppColors.greyDarktextIntExtFieldAndIconsHome,
            ),
            SizedBox(width: width * .02),
            Text(
             '12.12.2025',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: width * .036,
                color: AppColors.greyDarktextIntExtFieldAndIconsHome,
              ),
            ),
          ],
        ),
        Icon(
          CupertinoIcons.chevron_down,
          size: width * .038,
          color: AppColors.greyDarktextIntExtFieldAndIconsHome,
        ),
      ],
    ),
  );
}
