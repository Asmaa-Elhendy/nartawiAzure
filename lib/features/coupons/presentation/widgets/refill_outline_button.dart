import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/theme/colors.dart';
import 'calender_dialog.dart';

class NextRefillButton extends StatefulWidget {
  /// الأيام المفضلة القادمة من الكارت
  /// 0 = Sunday, 1 = Monday, ..., 6 = Saturday
  final List<int> selectedDays;

  const NextRefillButton({
    Key? key,
    required this.selectedDays,
  }) : super(key: key);

  @override
  State<NextRefillButton> createState() => _NextRefillButtonState();
}

class _NextRefillButtonState extends State<NextRefillButton> {
  /// أول قيمة افتراضية للـ next refill
  DateTime _currentFirstRefillDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final DateTime displayDate = _currentFirstRefillDate;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: height * .01,
      ),
      child: InkWell(
        onTap: () async {
          final newDate = await showDialog<DateTime?>(
            context: context,
            builder: (context) => NextRefillCalendarDialog(
              selectedDays: widget.selectedDays, // 👈 من الكارت
              remainingRefills: 10,
              nextRefillDate: _currentFirstRefillDate,
            ),
          );

          if (newDate != null) {
            setState(() {
              _currentFirstRefillDate = newDate;
            });
          }
        },
        child: Container(
          height: height * .06,
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.secondary,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/images/orders/calendar.svg",
                  color: AppColors.secondary,
                ),
                SizedBox(width: width * .02),
                Text(
                  'Next Refill',
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontSize: width * .036,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: width * .02),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      formatFullDate(displayDate),
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontSize: width * .03,
                      ),
                    ),
                    Text(
                      'Before Noon',
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontSize: width * .03,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String formatFullDate(DateTime date) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];

    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    String dayName = days[date.weekday - 1];
    String monthName = months[date.month - 1];

    return '$dayName $monthName ${date.day}, ${date.year}';
  }
}
