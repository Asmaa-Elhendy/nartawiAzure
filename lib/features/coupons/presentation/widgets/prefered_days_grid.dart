import 'package:flutter/material.dart';

import 'day_card.dart';

class DaySelectionGrid extends StatefulWidget {
  const DaySelectionGrid({Key? key}) : super(key: key);

  @override
  State<DaySelectionGrid> createState() => _DaySelectionGridState();
}

class _DaySelectionGridState extends State<DaySelectionGrid> {
  // Store selected days with their time periods
  Map<String, DaySelection> selectedDays = {
    'Sat': DaySelection(isSelected: true, timePeriod: 'Early Morning'),
    'Mon': DaySelection(isSelected: true, timePeriod: 'Afternoon'),
    'Wed': DaySelection(isSelected: true, timePeriod: 'Night'),
  };

  final List<String> daysOfWeek = ['Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
     padding: EdgeInsets.all(0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: screenWidth * 0.015,
        mainAxisSpacing: screenWidth * 0.015,
        childAspectRatio: 1,
      ),
      itemCount: daysOfWeek.length,
      itemBuilder: (context, index) {
        final day = daysOfWeek[index];
        final selection = selectedDays[day];
        final isSelected = selection?.isSelected ?? false;

        return
          // In your grid widget, update the DayCard usage:
          DayCard(
            day: day,
            isSelected: isSelected,
            timePeriod: selection?.timePeriod ?? 'Not Selected',
            onToggle: () {
              setState(() {
                if (isSelected) {
                  selectedDays.remove(day);
                } else {
                  selectedDays[day] = DaySelection(
                    isSelected: true,
                    timePeriod: 'Afternoon',
                  );
                }
              });
            },
            onTimePeriodChanged: (newTimePeriod) {
              setState(() {
                selectedDays[day] = DaySelection(
                  isSelected: true,
                  timePeriod: newTimePeriod,
                );
              });
            },
          );
      },
    );
  }
}

