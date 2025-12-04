import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/theme/colors.dart';

Widget TransactionCard(double screenHeight, double screenWidth) {
  return Padding(
    padding:  EdgeInsets.symmetric(vertical: screenHeight*.01,horizontal: 0),
    child: Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: screenHeight * .06,
              decoration: BoxDecoration(
                color: AppColors.backgrounHome, // لون الخلفية
                shape: BoxShape.circle, // يجعله دائري
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Image.asset(
                "assets/images/home/main_page/company.png",
                height: screenHeight * .03,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: screenWidth * .03),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    'Gamal Ali',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: screenWidth * .036,
                    ),
                  ),

                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            "assets/images/orders/calendar.svg",
                            width: screenWidth * .038,
                            color: AppColors.textLight,
                          ),
                          SizedBox(width: screenWidth * .02),
                          Text(
                            'Yesterday At 16:34',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: screenWidth * .036,
                              color: AppColors.textLight,
                            ),
                          ),

                        ],
                      ),
                      Text(
                        'QAR 1000,00',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: screenWidth * .036,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        Divider(
          color:AppColors.BorderAnddividerAndIconColor, // Customize divider color
          thickness: 1.0,    // Customize divider thickness
        )
      ],
    ),
  );
}
