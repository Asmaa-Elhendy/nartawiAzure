import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/theme/colors.dart';
import 'calender_dialog.dart';


Widget NextRefillButton(
    double width,
    double height,
    BuildContext context
    ) {
  return Padding(
    padding: EdgeInsets.symmetric(
      //   horizontal: widget.width * .04,
      vertical: height * .01,
    ),
    child: InkWell(
      onTap: (){

    },
      child: Container(
        //   width:  width,
        height:  height * .06,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.secondary, // 👈 Border color
            width: 1.5, // 👈 Optional: Border thickness
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
                // height: screenHeight*.1,
              ),
              SizedBox(width:  width * .02 ),
              Text(
                'Next Refill',
                style: TextStyle(
                  color: AppColors.secondary,
                  fontSize: width * .036,
                  fontWeight: FontWeight.w600,
                ),
              ),SizedBox(width: width*.02,),
              Column(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Monday March 3, 2025',
                    style: TextStyle(
                      color: AppColors.secondary,
                      fontSize: width * .03,

                    ),
                  ),
                  Text(//j
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