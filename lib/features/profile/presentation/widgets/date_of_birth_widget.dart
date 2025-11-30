import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
//
Widget buildDateOfBirthWidget(
    BuildContext context,
    double height,
    double width, {
      required DateTime? selectedDate,
      required ValueChanged<DateTime> onDateSelected,
    }) {
  // نص التاريخ المعروض
  String displayedDate = 'DD/MM/YYYY';
  if (selectedDate != null) {
    displayedDate =
    '${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}';
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Date Of Birth',
            style: AppTextStyles.LabelInTextField,
          ),
        ],
      ),
      SizedBox(height: height * .01),

      /// 👇 الـ Container اللي بيبان كـ TextField وبيفتح الـ Calendar لما نضغط عليه
      GestureDetector(
        onTap: () async {
          final now = DateTime.now();

          final results = await showCalendarDatePicker2Dialog(
            context: context,
            value: [
              selectedDate ?? DateTime(now.year , now.month, now.day),
            ],
            dialogSize: Size(width * 0.9, height * 0.55), // 👈 وسّعنا الـ dialog
            borderRadius: BorderRadius.circular(16),
            config: CalendarDatePicker2WithActionButtonsConfig(
              calendarType: CalendarDatePicker2Type.single,

              // 🎨 ألوان الـ Calendar
              selectedDayHighlightColor: AppColors
                  .primary, // بدل الموف استخدم اللون الأساسي بتاعك (تقدر تغيّره)
              selectedDayTextStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: width * .035,
              ),
              dayTextStyle: TextStyle(
                color: Colors.black87,
                fontSize: width * .034,
              ),
              weekdayLabelTextStyle: TextStyle(
                color: AppColors.greyDarktextIntExtFieldAndIconsHome,
                fontWeight: FontWeight.w600,
                fontSize: width * .03,
              ),
              yearTextStyle: TextStyle(
                color: Colors.black87,
                fontSize: width * .032,
              ),
              controlsTextStyle: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: width * .035,
              ),

              // لو حابب تتحكم في padding
          //    daySplashRadius: 18,
            ),
          );

          if (results != null && results.isNotEmpty && results.first != null) {
            onDateSelected(results.first!);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          height: height * .06,
          decoration: BoxDecoration(
            color: AppColors.fillColorTextFilled,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.BorderAnddividerAndIconColor),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // التاريخ المعروض
              Row(
                children: [
                  SizedBox(width: width * .02),
                  Text(
                    displayedDate,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: width * .036,
                      color: selectedDate == null
                          ? AppColors.greyDarktextIntExtFieldAndIconsHome
                          .withOpacity(.7)
                          : AppColors.greyDarktextIntExtFieldAndIconsHome,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(right: width * .02),
                child: SvgPicture.asset(
                  "assets/images/orders/calendar.svg",
                  width: width * .04,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}



