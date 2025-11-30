import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import 'custom_text.dart';

class TimePeriodSelectionDialog extends StatefulWidget {
  final String currentTimePeriod;
  final Function(String) onTimePeriodSelected;

  const TimePeriodSelectionDialog({
    Key? key,
    required this.currentTimePeriod,
    required this.onTimePeriodSelected,
  }) : super(key: key);

  @override
  State<TimePeriodSelectionDialog> createState() => _TimePeriodSelectionDialogState();
}

class _TimePeriodSelectionDialogState extends State<TimePeriodSelectionDialog> {
  late String selectedPeriod;

  static const List<String> timePeriods = [
    'Early Morning',
    'Before Noon',
    'Afternoon',
    'Evening',
    'Night',
  ];

  @override
  void initState() {
    super.initState();
    selectedPeriod = widget.currentTimePeriod;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: Colors.white,
      child: Container(
        width: screenWidth * 0.85,
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                customCouponPrimaryTitle(
                  'Preferred Times For Refilling',
                  screenWidth,
                  screenHeight,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.close,
                    size: screenWidth * .05,
                    color: AppColors.greyDarktextIntExtFieldAndIconsHome,
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.025),

            // Radio buttons list
            ...timePeriods.map((period) => _buildRadioOption(
              period,
              screenWidth,
              screenHeight,
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioOption(
      String period,
      double screenWidth,
      double screenHeight,
      ) {
    final isSelected = period == selectedPeriod;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPeriod = period;
        });
        widget.onTimePeriodSelected(period);
        Navigator.of(context).pop();
      },
      child: Container(
        margin: EdgeInsets.only(bottom: screenHeight * 0.02),
        child: Row(
          children: [
            // Radio button
            Container(
              width: screenWidth * 0.045,
              height: screenWidth * 0.045,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary :AppColors.greyDarktextIntExtFieldAndIconsHome,
                  width: isSelected ? 2 : 1.5,
                ),
              ),
              child: isSelected
                  ? Center(
                child: Container(
                  width: screenWidth * 0.023,
                  height: screenWidth * 0.023,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary ,
                  ),
                ),
              )
                  : null,
            ),
            SizedBox(width: screenWidth * 0.03),
            // Label
            customCouponAlertTitle(
              period,
            screenWidth,screenHeight
            ),
          ],
        ),
      ),
    );
  }
}

// Helper function to show the dialog
void showTimePeriodDialog({
  required BuildContext context,
  required String currentTimePeriod,
  required Function(String) onTimePeriodSelected,
}) {
  showDialog(
    context: context,
    builder: (context) => TimePeriodSelectionDialog(
      currentTimePeriod: currentTimePeriod,
      onTimePeriodSelected: onTimePeriodSelected,
    ),
  );
}