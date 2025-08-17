import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/healthicons.dart';
import 'package:iconify_flutter/icons/la.dart';
import '../../../../core/theme/colors.dart';
import 'impact_single_reward.dart';

Widget impactSecondCard(double screenWidth, double screenHeight) {
  return Container(
    width: screenWidth,
    margin: EdgeInsets.symmetric(vertical: screenHeight * .02),
    padding: EdgeInsets.symmetric(
      vertical: screenHeight * .02,
      horizontal: screenWidth * .04,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: AppColors.whiteColor,
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ImpactSngleReward(
          screenWidth: screenWidth,
          screenHeight: screenHeight,
          title: 'Your Achievements',
          description: 'Milestones you\'ve reached',
          date: '',
          icon: La.award,
        ),

        ImpactSngleReward(
          screenWidth: screenWidth,
          screenHeight: screenHeight,
          title: 'App Explorer',
          description: 'Explored the MOYAH water delivery app features',
          date: 'Unlocked: Mar 31, 2025',
          icon: Healthicons.award_trophy_outline,
        ),

        ImpactSngleReward(
          screenWidth: screenWidth,
          screenHeight: screenHeight,
          title: 'Water Supporter',
          description: 'Joined the community supporting clean water access',
          date: 'Unlocked: Mar 31, 2025',
          icon: Healthicons.award_trophy_outline,
        ),

        ImpactSngleReward(
          screenWidth: screenWidth,
          screenHeight: screenHeight,
          title: 'First Steps',
          description: 'Started your journey to help donate clean water',
          date: 'Unlocked: Mar 31, 2025',
          icon: Healthicons.award_trophy_outline,
        ),
      ],
    ),
  );
}
