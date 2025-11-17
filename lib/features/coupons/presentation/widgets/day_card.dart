import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:newwwwwwww/features/coupons/presentation/widgets/time_period_selection_dialog.dart';

import '../../../../core/theme/colors.dart';


class DayCard extends StatelessWidget {
  final String day;
  final bool isSelected;
  final String timePeriod;
  final VoidCallback onToggle;
  final Function(String) onTimePeriodChanged; // Add this callback

  const DayCard({
    Key? key,
    required this.day,
    required this.isSelected,
    required this.timePeriod,
    required this.onToggle,
    required this.onTimePeriodChanged
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.symmetric(vertical:screenHeight * 0.01),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        border: Border.all(
          color:AppColors.BorderAnddividerAndIconColor,
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
      //  mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with day name and toggle
          SizedBox(width: screenWidth*.2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,

              children: [
                Text(
                  day,
                  style: TextStyle(
                    fontSize: screenWidth * 0.03,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: screenWidth*.1,
                  child: Transform.scale(
                    scale: 0.55,
                    child: Switch(
                      value: isSelected,
                      onChanged: (_) => onToggle(),
                      activeColor: AppColors.whiteColor,
                      activeTrackColor:AppColors.primary,
                      inactiveThumbColor: AppColors.whiteColor,
                      inactiveTrackColor: AppColors.BorderAnddividerAndIconColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Time period info
          GestureDetector(
            onTap: isSelected
                ? () {
              // Show dialog when tapped
              showTimePeriodDialog(
                context: context,
                currentTimePeriod: timePeriod,
                onTimePeriodSelected: onTimePeriodChanged,
              );
            }
                : null, // Only allow tap when selected
            child: SizedBox(width: screenWidth*.2,
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon(
                  //   Icons.access_time,
                  //   size: screenWidth * 0.04,
                  //   color: isSelected ? AppColors.primary:AppColors.greyDarktextIntExtFieldAndIconsHome,
                  // ),
                  SvgPicture.asset(
                    isSelected ?
                    "assets/images/coupons/mdi_clock-outline.svg"
                       :"assets/images/coupons/mdi_clock-outline2.svg",
                    width: screenWidth * .04,
                  ),
              //    SizedBox(width: screenWidth * 0.01),
                  SizedBox(width: screenWidth*.15,
                    child: Text(
                      timePeriod,
                      style: TextStyle(
                        fontSize: screenWidth * 0.027,
                        color:  AppColors.greyDarktextIntExtFieldAndIconsHome,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DaySelection {
  final bool isSelected;
  final String timePeriod;

  DaySelection({
    required this.isSelected,
    required this.timePeriod,
  });
}