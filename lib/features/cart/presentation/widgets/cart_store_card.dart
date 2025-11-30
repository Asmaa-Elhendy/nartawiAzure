import 'package:flutter/material.dart';
import 'package:newwwwwwww/features/cart/presentation/widgets/widget_view_detail_store.dart';
import '../../../../../../core/theme/colors.dart';
import '../../../home/presentation/pages/suppliers/supplier_detail.dart';
import '../../../home/presentation/widgets/main_screen_widgets/suppliers/build_row_raing.dart';
import '../../../home/presentation/widgets/main_screen_widgets/suppliers/supplier_full_card.dart';
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
              height: screenHeight * .08,//0.09
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
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: screenWidth*.01),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Company 1',style: TextStyle(fontWeight: FontWeight.w600,fontSize: screenWidth*.036),),
                      Padding(
                        padding:  EdgeInsets.only(right: screenWidth*.02),
                        child: BuildRowRating(screenWidth, screenHeight,title: 'New'),
                      ),
                    ],
                  ),
                    SizedBox(height: screenHeight*.01,),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        viewStoreWithoutFlexible((){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>SupplierDetails()));

                        }, 'View Store', screenWidth, screenHeight),

                        OutlineButtonWithoutFlexible((){
                          showGeneralDialog(
                              context: context,
                              barrierDismissible: true,
                              barrierLabel: '',
                              barrierColor: Colors.black54, // خلفية شفافة
                              pageBuilder: (ctx, anim1, anim2) {
                              return  ViewDetailSupplierAlert(ctx,screenWidth,screenHeight);
                              },
                          );
                              }

                        , 'View Details', screenWidth, screenHeight)

                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),

      ],
    ),
  );
}

