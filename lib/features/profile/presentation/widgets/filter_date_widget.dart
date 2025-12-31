import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/theme/colors.dart';

Widget buildFilterDateWidget(
    double height,
    double width, {
      DateTime? selectedDate,
      VoidCallback? onClear, // ✅ NEW
    }) {
  String displayedDate = 'DD.MM.YYYY';

  if (selectedDate != null) {
    displayedDate =
    '${selectedDate.day.toString().padLeft(2, '0')}.'
        '${selectedDate.month.toString().padLeft(2, '0')}.'
        '${selectedDate.year}';
  }

  return Container(
    padding: EdgeInsets.symmetric(horizontal: width * .03),
    width: width * .4,
    height: height * .05,
    decoration: BoxDecoration(
      color: AppColors.whiteColor,
      border: Border.all(
        color: AppColors.BorderAnddividerAndIconColor,
        width: 1.5,
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
              displayedDate,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: width * .036,
                color: AppColors.greyDarktextIntExtFieldAndIconsHome,
              ),
            ),
          ],
        ),

        // ✅ بدل chevron دايمًا: لو في تاريخ -> close يمسح
        if (selectedDate != null)
          GestureDetector(
            onTap: onClear,
            child: Icon(
              CupertinoIcons.clear_circled_solid,
              size: width * .042,
              color: AppColors.greyDarktextIntExtFieldAndIconsHome,
            ),
          )
        else
          Icon(
            CupertinoIcons.chevron_down,
            size: width * .038,
            color: AppColors.greyDarktextIntExtFieldAndIconsHome,
          ),
      ],
    ),
  );
}
