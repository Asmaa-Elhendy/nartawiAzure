import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/suppliers/build_info_button.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/suppliers/build_verified_widget.dart';

import '../../../../../../core/theme/colors.dart';
import '../suppliers/build_row_raing.dart';
import 'generate_specification_product.dart';


Widget BuildComparedProductCard(BuildContext context,double screenHeight,double screenWidth,bool isFeatured){
  List specifications=['pH 7.5','5 Gallon x 4','15mg/L Sodium'];
  return  Padding(
    padding:  EdgeInsets.symmetric(horizontal: screenWidth*.01,vertical: screenHeight*.015),
    child: Container(

      // height: screenHeight*.3,
      padding:  EdgeInsets.symmetric(vertical: screenHeight*.01,horizontal: screenWidth*.02),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.backgroundCardAlert,
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

                height: screenHeight * .085,
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
              SizedBox(width: screenWidth*.02,),
              SizedBox(width: screenWidth*.65,
                child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Company 1',style: TextStyle(fontWeight: FontWeight.w600,fontSize: screenWidth*.037),),
                       Center(
                            child:Iconify(
                              Mdi.heart_outline,
                              color: AppColors.primary,
                              size:screenHeight*.028,
                            ),
                          ),

                      ],
                    ),
                    Text('330 mlx24pcs(50packs)',style: TextStyle(color: AppColors.greyDarktextIntExtFieldAndIconsHome,fontSize:screenWidth*.03 ),),
                    Padding(
                      padding:  EdgeInsets.only(top: screenHeight*.02,bottom: screenHeight*.01),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BuildRowRating(screenWidth, screenHeight),
                          BuildVerifiedWidget(screenHeight, screenWidth)
                        ],
                      ),
                    ),
                    generateSpecifications(screenWidth, screenHeight, specifications),
                    Padding(
                      padding:  EdgeInsets.symmetric(vertical: screenHeight*.01),
                      child: Text('QAR 20.00',style: TextStyle(fontWeight: FontWeight.w500,fontSize: screenWidth*.037),),
                    )





                  ],
                ),
              )
            ],
          ),
          BuildInfoAndAddToCartButton(screenWidth, screenHeight, 'Add To Cart', false,(){})

        ],
      ),
    ),
  );
}
