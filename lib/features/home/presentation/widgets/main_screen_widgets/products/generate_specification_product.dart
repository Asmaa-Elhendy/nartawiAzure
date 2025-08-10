import 'package:flutter/material.dart';

import '../../../../../../core/theme/colors.dart';

Widget generateSpecifications(double screenWidth,double screenHeight,List specifications){
  return     Row(
    children: [
      Expanded(
        child: Wrap(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: specifications.map((e) => Container(
            margin: EdgeInsets.only(right: screenWidth*.01),
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * .018,
              vertical: screenHeight * .008,
            ),
            decoration: BoxDecoration(
              color: Color(0xfffeaeaea),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              e,
              style: TextStyle(
                  fontSize: screenWidth * .029, // larger font for all
                  fontWeight: FontWeight.w500,
                  color: AppColors.greyDarktextIntExtFieldAndIconsHome
              ),
              //    overflow: TextOverflow.ellipsis, // optional
              maxLines: 1,
              softWrap: true, // يسمح باللف
              overflow: TextOverflow.visible, // يمنع القص
            ), )).toList(),
        ),
      ),
    ],
  );
}
