import 'package:flutter/material.dart';
import '../../../../../../core/theme/colors.dart';
import '../../../home/presentation/widgets/main_screen_widgets/suppliers/build_row_raing.dart';
import 'outline_buttons.dart';


Widget CartStoreCard(BuildContext context,double screenWidth,double screenHeight){
  return  Container(
    // height: screenHeight*.3,
    padding:  EdgeInsets.symmetric(vertical: screenHeight*.01,horizontal: screenWidth*.01),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: AppColors.whiteColor,


    ),
    child: Column(
      children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              //   width: widget.screenWidth * .04,
              // الحجم العرض
              height: screenHeight * .09,
              // الحجم الارتفاع
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
            SizedBox(width: screenWidth*.01,),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                Text('Company 1',style: TextStyle(fontWeight: FontWeight.w600,fontSize: screenWidth*.036),),
                  SizedBox(height: screenHeight*.01,),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding:  EdgeInsets.only(top: screenHeight*.02,bottom: screenHeight*.01),
                        child: BuildRowRating(screenWidth, screenHeight,title: 'New'),
                      ),
                      viewStoreWithoutFlexible((){}, 'View Store', screenWidth, screenHeight),

                      OutlineButtonWithoutFlexible((){}, 'View Details', screenWidth, screenHeight)

                    ],
                  ),
                ],
              ),
            )
          ],
        ),

      ],
    ),
  );
}

