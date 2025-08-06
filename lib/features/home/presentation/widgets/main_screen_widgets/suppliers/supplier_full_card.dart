import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/suppliers/build_info_button.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/suppliers/build_verified_widget.dart';

import '../../../../../../core/theme/colors.dart';
import 'build_row_raing.dart';


Widget BuildFullCardSupplier(BuildContext context,double screenHeight,double screenWidth,bool isFeatured){
  return  Padding(
    padding:  EdgeInsets.symmetric(horizontal: screenWidth*.04),
    child: Container(
     // height: screenHeight*.3,
      padding:  EdgeInsets.symmetric(vertical: screenHeight*.01,horizontal: screenWidth*.02),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.whiteColor,
        boxShadow: [
          BoxShadow(
            color:AppColors.shadowColor, // ظل خفيف
            offset: Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],

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
              SizedBox(width: screenWidth*.03,),
              SizedBox(width:screenWidth*.66,
                child: Column(

                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Company A',style: TextStyle(fontWeight: FontWeight.w700,fontSize: screenWidth*.04),),
                        Container(
                          width: screenWidth*.1, // الحجم العرض
                          height: screenHeight*.045, // الحجم الارتفاع
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
                          child: Center(
                        child:Iconify(
                              Mdi.heart_outline,
                              color: AppColors.primary,
                              size:screenHeight*.03,
                            ),
                          ),
                        )

                      ],
                    ),
                    Padding(
                      padding:  EdgeInsets.only(top: screenHeight*.02,bottom: screenHeight*.01),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BuildRowRating(screenWidth, screenHeight),
                          BuildVerifiedWidget(screenHeight, screenWidth)
                        ],
                      ),
                    ),
                    Text(
                      'Premium Water Supplier With Quality Products And Reliable Delivery Service.',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: screenWidth*0.037,
                        fontWeight: FontWeight.w400,
                        color: AppColors.greyDarktextIntExtFieldAndIconsHome,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          BuildInfoButton(screenWidth, screenHeight, 'Info', (){})

        ],
      ),
    ),
  );
}

