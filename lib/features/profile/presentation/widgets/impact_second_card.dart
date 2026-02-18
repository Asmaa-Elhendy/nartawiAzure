import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/healthicons.dart';
import 'package:iconify_flutter/icons/la.dart';
import '../../../../core/theme/colors.dart';
import '../../../../l10n/app_localizations.dart';
import 'impact_single_reward.dart';

Widget impactSecondCard(BuildContext context,double screenWidth, double screenHeight) {
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
          title:AppLocalizations.of(context)!.yourAchievements,
          description:AppLocalizations.of(context)!.milestonesReached,
          date: '',
          icon: La.award,
        ),

        ImpactSngleReward(
          screenWidth: screenWidth,
          screenHeight: screenHeight,
          title:AppLocalizations.of(context)!.appExplorer,
          description: AppLocalizations.of(context)!.appExplorerDesc,
          date: '${AppLocalizations.of(context)!.unlocked}: Mar 31, 2025',
          icon: Healthicons.award_trophy_outline,
        ),

        ImpactSngleReward(
          screenWidth: screenWidth,
          screenHeight: screenHeight,
          title: AppLocalizations.of(context)!.waterSupporter,
          description:AppLocalizations.of(context)!.waterSupporterDesc,
          date: '${AppLocalizations.of(context)!.unlocked}: Mar 31, 2025',
          icon: Healthicons.award_trophy_outline,
        ),

        ImpactSngleReward(
          screenWidth: screenWidth,
          screenHeight: screenHeight,
          title:AppLocalizations.of(context)!.firstSteps,
          description: AppLocalizations.of(context)!.firstStepsDesc,
          date: '${AppLocalizations.of(context)!.unlocked}: Mar 31, 2025',
          icon: Healthicons.award_trophy_outline,
        ),
      ],
    ),
  );
}
