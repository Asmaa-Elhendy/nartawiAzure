import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:newwwwwwww/features/orders/presentation/widgets/orders_buttons.dart';
import 'package:newwwwwwww/features/orders/presentation/widgets/payement_status_widget.dart';
import '../../../../core/theme/colors.dart';
import 'order_status_widget.dart';


Widget BuildOrderCard(BuildContext context,double screenHeight,double screenWidth,String orderStatus,String paymentStatus){
 String imageUrl='';
  return  GestureDetector(
    onTap: (){
      // Navigator.pushNamed(context, '/supplierDetail');

    },
    child: Padding(
      padding:  EdgeInsets.only(bottom: screenHeight*.025),
      child: Container(
        //height: screenHeight*.133,//ss
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
        child: Padding(
          padding:  EdgeInsets.symmetric(vertical: screenHeight*.01,horizontal: screenWidth*.008),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Order #3',style: TextStyle(fontWeight: FontWeight.w700,fontSize: screenWidth*.04),),
                  BuildOrderStatus(screenHeight, screenWidth, orderStatus)
                ],
              ),

              Padding(
                padding:  EdgeInsets.symmetric(vertical: screenHeight*.01),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                   Row(
                     children: [
                       SvgPicture.asset("assets/images/orders/calendar.svg",
                           width: screenWidth * .05,color: AppColors.textLight,),
                       SizedBox(width: screenWidth*.01,),
                       Text('May 3, 2025',style: TextStyle(fontWeight: FontWeight.w400,fontSize: screenWidth*.04),)
                     ],
                   ),
                    BuildPaymentStatus(screenWidth,screenHeight,paymentStatus)

                  ],
                ),
              ),
               Padding(
                 padding:  EdgeInsets.symmetric(vertical: screenHeight*.01),
                 child: Row(mainAxisAlignment: MainAxisAlignment.start,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Container(
                                   //    width: screenWidth*.1,
                        height: screenHeight * .09,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.transparent
                        ),
                        child: ClipOval(
                          child:
                          imageUrl==null||imageUrl==''?
                          Image.asset(
                              'assets/images/orders/order.jpg',
                           fit: BoxFit.cover,
                          )
                              :
                          Image.network(
                            imageUrl! ,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                  'assets/images/orders/order.jpg'
                                //  fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                      ),
                     SizedBox(width: screenWidth*.02,),
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       mainAxisAlignment: MainAxisAlignment.start,
                       children: [
                         Text('Company 1',style: TextStyle(fontWeight: FontWeight.w600,fontSize: screenWidth*.037),),
                         Padding(
                           padding:  EdgeInsets.symmetric(vertical: screenHeight*.01),
                           child: Text('Total Order Value',style: TextStyle(fontWeight: FontWeight.w400,fontSize: screenWidth*.032,
                               color: AppColors.greyDarktextIntExtFieldAndIconsHome
                           ),),
                         ),
                         Text('QAR 200.00',style: TextStyle(fontWeight: FontWeight.w600,fontSize: screenWidth*.037),),

                       ],
                     )
                   ],
                 ),
               ),
              BuildOrderButtons(screenWidth, screenHeight, orderStatus)
            ],
          ),
        ),
      ),
    ),
  );
}


