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

  // اختيار اليوم في وضع Edit Next Refill (من الأيام المفضلة فقط)
  DateTime? _tempPreferredDate;

  // وضع طلب ميعاد جديد
  bool _isRequestMode = false;

  // اليوم المختار في وضع Request New Date (أي يوم مسموح)
  DateTime? _requestDate;

  @override
  void initState() {
    super.initState();

    final today = DateTime.now();
    final first = DateTime(today.year, today.month, today.day);
    final last = first.add(const Duration(days: 365));

    // خلي الـ focusedDay جوّه الرينچ
    DateTime initial = widget.nextRefillDate;
    if (initial.isBefore(first)) initial = first;
    if (initial.isAfter(last))  initial = last;

    _focusedDay = initial;

    _calculateAvailableDates();
    _tempPreferredDate = _firstRefillDate;
  }


  void _calculateAvailableDates() {
    _availableDates.clear();
    _firstRefillDate = null;

    // 1️⃣ لو مفيش أيام مفضّلة أصلاً
    if (widget.selectedDays.isEmpty) {
      final d = DateTime(
        widget.nextRefillDate.year,
        widget.nextRefillDate.month,
        widget.nextRefillDate.day,
      );
      _firstRefillDate = d;
      _availableDates.add(d);
      return;
    }

    DateTime currentDate = widget.nextRefillDate;
    int count = 0;

    // 2️⃣ safety counter عشان ما ندخلش في لوب لا نهائي
    int safetyCounter = 0;
    const int maxDaysToSearch = 365; // سنة قدّام مثلاً

    while (count < widget.remainingRefills && safetyCounter < maxDaysToSearch) {
      final int dayIndex = currentDate.weekday % 7; // 0 = Sunday

      if (widget.selectedDays.contains(dayIndex)) {
        final normalized = DateTime(
          currentDate.year,
          currentDate.month,
          currentDate.day,
        );

        _availableDates.add(normalized);
        count++;

        _firstRefillDate ??= normalized;
      }

      currentDate = currentDate.add(const Duration(days: 1));
      safetyCounter++;
    }
  }

  bool _isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Color? _getDayColor(DateTime day) {
    DateTime normalizedDay = DateTime(day.year, day.month, day.day);

    if (_isRequestMode) {
      // في وضع Request New Date نظهر بس اليوم المطلوب كـ nextRefillColor
      if (_requestDate != null && _isSameDay(normalizedDay, _requestDate)) {
        return AppColors.nextRefillColor;
      }
      return null;
    } else {
      // في وضع Edit Next Refill:
      // أول يوم refill هو المؤقت لو موجود، وإلا الأصلي
      final DateTime? effectiveFirst =
          _tempPreferredDate ?? _firstRefillDate;

      // Check if it's the first refill date (primary color)
      if (_isSameDay(normalizedDay, effectiveFirst)) {
        return AppColors.nextRefillColor; // اللون الأساسي للأول يوم
      }

      // Check if it's in available dates (light primary)
      for (var date in _availableDates) {
        if (_isSameDay(normalizedDay, date)) {
          return AppColors.secondaryColorWithOpacity16; // لون فاتح للأيام الباقية
        }
      }
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final first = DateTime.now();
    final last = first.add(const Duration(days: 365));
    // التاريخ المعروض في الهيدر حسب المود
    final DateTime displayedDate = _isRequestMode
        ? (_requestDate ?? _firstRefillDate ?? widget.nextRefillDate)
        : (_tempPreferredDate ?? _firstRefillDate ?? widget.nextRefillDate);

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
                        _formatDate(displayedDate),
                        style: TextStyle(
                          fontSize: screenWidth * 0.036,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        _formatMonth(displayedDate),
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

                onDaySelected: (selectedDay, focusedDay) {
                  final normalized = DateTime(
                    selectedDay.year,
                    selectedDay.month,
                    selectedDay.day,
                  );

                  if (_isRequestMode) {
                    // وضع Request New Date → نسمح بأي يوم
                    setState(() {
                      _requestDate = normalized;
                      _focusedDay = focusedDay;
                    });
                  } else {
                    // وضع Edit Next Refill → نسمح بس بالأيام المفضلة
                    final int dayIndex = normalized.weekday % 7; // 0=Sunday
                    if (widget.selectedDays.contains(dayIndex)) {
                      setState(() {
                        _tempPreferredDate = normalized;
                        _focusedDay = focusedDay;
                      });
                    } else {
                      // يوم مش مفضل → ما نختاروش
                    }
                  }
                },

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
                              color: bgColor != null
                                  ? AppColors.primary
                                  : Colors.black, //if today text color else text black
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  defaultBuilder: (context, day, focusedDay) {
                    Color? bgColor = _getDayColor(day);

                    final DateTime? effectiveFirst = _isRequestMode
                        ? _requestDate
                        : (_tempPreferredDate ?? _firstRefillDate);

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
                            color: _isSameDay(day, effectiveFirst)
                                ? AppColors.nextRefillTextColor
                                : bgColor != null
                                ? AppColors.secondary
                                : Colors.black, //if preferred day else black text
                            fontWeight: FontWeight.normal,
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
            _isRequestMode
                ? Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      // Submit في وضع Request New Date
                      // ما نغيرش first الأساسي → نرجع بدون قيمة
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
                          'Submit',
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
                      // Cancel → نرجع لوضع العادي بدون تغيير
                      setState(() {
                        _isRequestMode = false;
                        _requestDate = null;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * .01,
                        horizontal: screenWidth * .01,
                      ),
                      height: screenHeight * .055,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors
                              .greyDarktextIntExtFieldAndIconsHome,
                          width: .5,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'Cancel',
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
                : Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      // Edit Next Refill → نغيّر first الأساسي برا الديالوج
                      final DateTime result =
                          _tempPreferredDate ??
                              _firstRefillDate ??
                              widget.nextRefillDate;
                      Navigator.pop(context, result);
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
                      // Request New Date → ندخل مود الطلب
                      setState(() {
                        _isRequestMode = true;
                        _requestDate = _firstRefillDate;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * .01,
                        horizontal: screenWidth * .01,
                      ),
                      height: screenHeight * .055,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors
                              .greyDarktextIntExtFieldAndIconsHome,
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
            ),
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
