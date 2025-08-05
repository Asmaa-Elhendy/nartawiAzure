import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';

import '../../../../../../core/theme/colors.dart';


Widget BuildCardSupplier(BuildContext context,double screenHeight,double screenWidth,bool isFeatured){
  return  GestureDetector(
    onTap: (){
      Navigator.pushNamed(context, '/supplierDetail');

    },
    child: Padding(
      padding:  EdgeInsets.only(bottom: screenHeight*.035),
      child: Container(
        height: screenHeight*.133,
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
        child: Row(crossAxisAlignment: CrossAxisAlignment.center,
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
            Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width:screenWidth*.65,
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Company A',style: TextStyle(fontWeight: FontWeight.w700,fontSize: screenWidth*.04),),
                      BuildFeaturedOrSponsered(screenHeight, screenWidth, isFeatured?'Featured':'Sponsored')
                    ],
                  ),
                ),

                SizedBox(
                  width:screenWidth*.65,
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Iconify(
                            MaterialSymbols.star,  // This uses the Material Symbols "star" icon
                            size: screenHeight*.03,
                            color: Colors.amber,
                          ),
                          //  SizedBox(width: screenWidth*.01,),
                          Text('5.0',style: TextStyle(fontSize: screenWidth*.035,fontWeight: FontWeight.w500))
                        ],

                      ),
                      Container(
                        padding: EdgeInsetsGeometry.symmetric(vertical: screenHeight*.01,horizontal: screenWidth*.02),
                        //   width:  screenWidth * .28,
                        height: screenHeight * .047,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.blueBorder, // 👈 Border color
                            width: 1.5,               // 👈 Optional: Border thickness
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'View Details',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: screenWidth*.035,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )

                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    ),
  );
}

Widget BuildFeaturedOrSponsered(double screenHeight,double screenWidth,String title){
  return   Container(
    padding: EdgeInsets.symmetric(vertical: screenHeight*.01,horizontal: screenWidth*.02),
    decoration: BoxDecoration(
      color:title=='Featured'?  AppColors.greenLight: AppColors.orangeLight,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        color:title=='Featured'? AppColors.greenColor: AppColors.orangeColor,
        fontSize: screenWidth*.035,
      ),
    ),
  );
}