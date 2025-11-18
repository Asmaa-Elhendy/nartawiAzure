import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/theme/colors.dart';

class NextRefillCalendarDialog extends StatefulWidget {
  final List<int> selectedDays; // 0=Sunday, 1=Monday, etc.
  final int remainingRefills;
  final DateTime nextRefillDate;

  const NextRefillCalendarDialog({
    Key? key,
    required this.selectedDays,
    required this.remainingRefills,
    required this.nextRefillDate,
  }) : super(key: key);

  @override
  State<NextRefillCalendarDialog> createState() =>
      _NextRefillCalendarDialogState();
}

class _NextRefillCalendarDialogState extends State<NextRefillCalendarDialog> {
  late DateTime _focusedDay;
  List<DateTime> _availableDates = [];
  DateTime? _firstRefillDate;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.nextRefillDate;
    _calculateAvailableDates();
  }

  void _calculateAvailableDates() {
    _availableDates.clear();
    DateTime currentDate = widget.nextRefillDate;
    int count = 0;

    // Calculate next available dates based on selected days
    while (count < widget.remainingRefills) {
      // Check if current day is in selected days
      // weekday: 1=Monday, 7=Sunday, so we convert to 0=Sunday format
      int dayIndex = currentDate.weekday % 7; // Convert to 0=Sunday format

      if (widget.selectedDays.contains(dayIndex)) {
        _availableDates.add(DateTime(
          currentDate.year,
          currentDate.month,
          currentDate.day,
        ));
        count++;

        // Set first refill date
        if (_firstRefillDate == null) {
          _firstRefillDate = DateTime(
            currentDate.year,
            currentDate.month,
            currentDate.day,
          );
        }
      }

      currentDate = currentDate.add(Duration(days: 1));
    }
  }

  bool _isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Color? _getDayColor(DateTime day) {
    DateTime normalizedDay = DateTime(day.year, day.month, day.day);

    // Check if it's the first refill date (primary color)
    if (_isSameDay(normalizedDay, _firstRefillDate)) {
      return Color(0xff095BA8).withValues(alpha:0.50); // اللون الأساسي للأول يوم
    }

    // Check if it's in available dates (light primary)
    for (var date in _availableDates) {
      if (_isSameDay(normalizedDay, date)) {
        return AppColors.secondaryColorWithOpacity16; // لون فاتح للأيام الباقية
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Next Refill Appointment',
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close, size: screenWidth * 0.06),
                ),
              ],
            ),

            // Date info
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _formatDate(_firstRefillDate ?? widget.nextRefillDate),
                          style: TextStyle(
                            fontSize: screenWidth * 0.036,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          _formatMonth(_firstRefillDate ?? widget.nextRefillDate),
                          style: TextStyle(
                            fontSize: screenWidth * 0.036,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.edit_outlined, size: screenWidth * 0.05),
                ],
              ),


           // SizedBox(height: screenHeight * 0.02),

            SizedBox(
              height: screenHeight * 0.45,
              child: TableCalendar(
                firstDay: DateTime.now(),
                lastDay: DateTime.now().add(Duration(days: 365)),
                focusedDay: _focusedDay,
                calendarFormat: CalendarFormat.month,
                daysOfWeekHeight: screenHeight * 0.04,
                rowHeight: screenHeight * 0.05,
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                calendarStyle: CalendarStyle(
                  cellMargin: EdgeInsets.all(2),
                  // Today's date style
                  todayDecoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.blue, width: 1.5),
                  ),
                  todayTextStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: screenWidth * 0.034,
                  ),

                  // Default day style
                  defaultTextStyle: TextStyle(
                    fontSize: screenWidth * 0.034,
                  ),

                  // Weekend style
                  weekendTextStyle: TextStyle(
                    fontSize: screenWidth * 0.034,
                    color: Colors.black,
                  ),
                ),
                calendarBuilders: CalendarBuilders(
                  todayBuilder: (context, day, focusedDay) {
                    Color? bgColor = _getDayColor(day);
                    bool isToday = _isSameDay(day, DateTime.now());

                    return Container(
                      margin: EdgeInsets.all(3),
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                        border: isToday && bgColor == null
                            ? Border.all(color: Colors.blue, width: 1.5)
                            : null,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: bgColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${day.day}',
                            style: TextStyle(
                              fontSize: screenWidth * 0.034,
                              color: bgColor != null ? AppColors.primary: Colors.black, //if today text color else text black
                              // fontWeight: _isSameDay(day, _firstRefillDate)
                              //     ? FontWeight.bold
                              //     : FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  defaultBuilder: (context, day, focusedDay) {
                    Color? bgColor = _getDayColor(day);

                    return Container(
                      margin: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: bgColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${day.day}',
                          style: TextStyle(
                            fontSize: screenWidth * 0.034,
                            color: bgColor != null ?AppColors.secondary : Colors.black,//if favourites day else black text
                            fontWeight: _isSameDay(day, _firstRefillDate)
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  },
                  outsideBuilder: (context, day, focusedDay) {
                    return Container(
                      margin: EdgeInsets.all(3),
                      child: Center(
                        child: Text(
                          '${day.day}',
                          style: TextStyle(
                            fontSize: screenWidth * 0.034,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                onPageChanged: (focusedDay) {
                  setState(() {
                    _focusedDay = focusedDay;
                  });
                },
              ),
            ),

            SizedBox(height: screenHeight * 0.02),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * .01,
                        horizontal: screenWidth * .01,
                      ),
                      height: screenHeight * .055,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'Edit Next Refill',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * .03,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.02),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * .01,
                        horizontal: screenWidth * .01,
                      ),
                      height: screenHeight * .055,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.greyDarktextIntExtFieldAndIconsHome,
                          width: .5,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'Request New Date',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: screenWidth * .03,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
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

    return '${days[date.weekday % 7]}, ${months[date.month - 1]} ${date.day.toString().padLeft(2, '0')}';
  }

  String _formatMonth(DateTime date) {
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

    return '${months[date.month - 1]} ${date.year}';
  }
}
