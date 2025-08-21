import 'package:flutter/material.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/suppliers/build_row_raing.dart';

import '../../../../../../core/theme/colors.dart';
import '../../../pages/suppliers/supplier_detail.dart';


Widget BuildCardSupplier(BuildContext context,double screenHeight,double screenWidth,bool isFeatured){
  return  GestureDetector(
    onTap: (){
      // Navigator.pushNamed(context, '/supplierDetail');
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => SupplierDetails()));

    },
    child: Padding(
      padding:  EdgeInsets.only(bottom: screenHeight*.035),
      child: Container(
        height: screenHeight*.133,//ss
        padding:  EdgeInsets.symmetric(vertical: screenHeight*.01,horizontal: screenWidth*.01),
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
            SizedBox( width:screenWidth*.7,
              child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Company A',style: TextStyle(fontWeight: FontWeight.w600,fontSize: screenWidth*.036),),
                      BuildFeaturedOrSponsered(screenHeight, screenWidth, isFeatured?'Featured':'Sponsored')
                    ],
                  ),

                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BuildRowRating(screenWidth, screenHeight),
                      Container(
                        padding: EdgeInsetsGeometry.symmetric(vertical: screenHeight*.01,horizontal: screenWidth*.01),
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
                              fontSize: screenWidth*.034,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )

                    ],
                  )
                ],
              ),
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
        fontSize: screenWidth*.034,
      ),
    ),
  );
}