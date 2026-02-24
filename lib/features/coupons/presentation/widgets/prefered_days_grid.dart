import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import 'day_card.dart';

class DaySelectionGrid extends StatefulWidget {
  /// الأيام المختارة جاية من فوق (CouponeCard)
 /*
 Time Slot IDs:

1: Early Morning (6:00-9:00)
2: Before Noon (10:00-13:00)
3: Afternoon (13:00-17:00)
4: Evening (17:00-21:00)
5: Night (20:00-23:59)
Day of Week:

0: Sunday
1: Monday
2: Tuesday
3: Wednesday
4: Thursday
5: Friday
6: Saturday
  */
  final Set<int> selectedDays;

  /// يتنادي لما اليوم يتضغط
  final void Function(int dayIndex) onDayTapped;

  const DaySelectionGrid({
    Key? key,
    required this.selectedDays,
    required this.onDayTapped,
  }) : super(key: key);

  @override
  State<DaySelectionGrid> createState() => _DaySelectionGridState();
}

class _DaySelectionGridState extends State<DaySelectionGrid> {
  /// بنخزن لكل day ال timePeriod بس
  /// DaySelection اللي جاية من day_card.dart
  final Map<String, DaySelection> _daySelections = {};

  /// ترتيب الأيام لازم يطابق الإندكس
  /// 0=Sun,1=Mon,...,6=Sat (عشان الكاليندر)
  final List<String> daysOfWeek = [
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: screenWidth * 0.015,
        mainAxisSpacing: screenWidth * 0.015,
        childAspectRatio: 1,
      ),
      itemCount: daysOfWeek.length,
      itemBuilder: (context, index) {
        final dayLabel = daysOfWeek[index];

        // هل اليوم ده متعلم ولا لأ؟ جاية من ال parent
        final bool isSelected = widget.selectedDays.contains(index);

        // ال timePeriod اللي مخزّن عندنا لليوم ده (لو موجود)
        final selection = _daySelections[dayLabel];

        // لو متعلم ومفيش اختيار سابق → حط له default timePeriod
        if (isSelected && selection == null) {
          _daySelections[dayLabel] = DaySelection(
            isSelected: true,
            timePeriod: 'Afternoon',
            timeSlotId: 3, // Afternoon ID
          );
        }

        final String timePeriod =
            _daySelections[dayLabel]?.timePeriod ?? (isSelected ? 'Afternoon' : AppLocalizations.of(context)!.notSelected);

        return DayCard(
          day: dayLabel,
          isSelected: isSelected,
          timePeriod: timePeriod,
          onToggle: () {
            // اللي فوق هو المسؤول عن السماح/المنع (CouponeCard)
            widget.onDayTapped(index);
            setState(() {});
          },
          onTimePeriodChanged: (newTimePeriod, newTimeSlotId) {
            setState(() {
              _daySelections[dayLabel] = DaySelection(
                isSelected: isSelected,
                timePeriod: newTimePeriod,
                timeSlotId: newTimeSlotId,
              );
            });
          },
        );
      },
    );
  }
  
  /// Get schedule data for API call
  List<Map<String, int>> getScheduleData() {
    final List<Map<String, int>> scheduleData = [];
    
    for (int i = 0; i < daysOfWeek.length; i++) {
      final dayLabel = daysOfWeek[i];
      final selection = _daySelections[dayLabel];
      
      if (selection != null && selection.isSelected) {
        scheduleData.add({
          'dayOfWeek': i,           // 0=Sunday, 1=Monday, etc.
          'timeSlotId': selection.timeSlotId,
        });
      }
    }
    
    return scheduleData;
  }
}
