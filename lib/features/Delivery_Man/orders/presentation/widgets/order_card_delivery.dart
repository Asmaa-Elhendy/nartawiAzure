import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:newwwwwwww/features/Delivery_Man/orders/presentation/widgets/custome_button.dart';
import 'package:newwwwwwww/features/coupons/presentation/widgets/oulined_icon_button.dart';
import 'package:newwwwwwww/features/orders/domain/models/order_model.dart';
import 'package:newwwwwwww/features/orders/presentation/widgets/orders_buttons.dart';
import 'package:newwwwwwww/features/orders/presentation/widgets/payement_status_widget.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../orders/presentation/pages/order_details.dart';
import '../../../../orders/presentation/widgets/cancel_alert_dialog.dart';
import '../../../../orders/presentation/widgets/order_image_network_widget.dart';
import '../../../../orders/presentation/widgets/order_status_widget.dart';
import '../screens/track_order.dart';


String formatOrderDate(DateTime? date) {
  if (date == null) return '';
  return DateFormat('MMMM d, y').format(date);
}


Widget BuildOrderDeliveryCard(BuildContext context,double screenHeight,double screenWidth,String orderStatus,String paymentStatus,{ClientOrder? order=null,}){
  String imageUrl='';
  return  Padding(
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
                Text('Order #${order!=null?order?.id:0}',style: TextStyle(fontWeight: FontWeight.w700,fontSize: screenWidth*.036),),
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
                        width: screenWidth * .042,color: AppColors.textLight,),
                      SizedBox(width: screenWidth*.02,),
                      Text(
                        order != null
                            ? formatOrderDate(order.issueTime)
                            : 'UNkOWN DATE',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: screenWidth * .036,
                        ),
                      )
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
                  BuildNetworkOrderImage(screenWidth, screenHeight, imageUrl, 'assets/images/orders/order.jpg',fromDelivery:true),

                  SizedBox(width: screenWidth*.03,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(order?.customerName ?? 'Unknown Customer',style: TextStyle(fontWeight: FontWeight.w600,fontSize: screenWidth*.037),),

                          Padding(
                            padding:  EdgeInsets.symmetric(vertical: screenHeight*.01),
                            child: Text('One Time Purchase',style: TextStyle(fontWeight: FontWeight.w400,fontSize: screenWidth*.034,

                            ),),

                      ),

                    ],
                  ),SizedBox(width: screenWidth*.1,),
                 Row(children: [
                   SvgPicture.asset(
                     'assets/images/delivery_man/orders/whatsapp.svg',
                     width: screenWidth * .08,
                     // height: screenHeight*.1,
                   ),SizedBox(width: screenWidth*.05,),
                   SvgPicture.asset(
                     'assets/images/delivery_man/orders/maps-global-02.svg',
                     width: screenWidth * .08,
                     // height: screenHeight*.1,
                   ),
                 ],)
                ],
              ),
            ),
            Row(children: [
              SvgPicture.asset(
                'assets/images/delivery_man/location.svg'
                ,color: Colors.black,
                // height: screenHeight*.1,
              ),
        Text('Zone abc, Street 20, Building 21, Flat 22',style: TextStyle(fontWeight: FontWeight.w400,fontSize: screenWidth*.034,

        )),
          ],),SizedBox(height: screenHeight*.01,),
          //  Container(
            //   padding: EdgeInsetsGeometry.symmetric(
            //     vertical: screenHeight * .01,
            //     horizontal: screenWidth * .015,
            //   ),
            //   height: screenHeight * .055,
            //   decoration: BoxDecoration(
            //     color: AppColors.backgrounHome,
            //
            //     borderRadius: BorderRadius.circular(8),
            //   ),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //
            //       Text(
            //         'Amount to be collected',
            //         style: TextStyle(
            //           fontSize: screenWidth * .034,
            //           fontWeight: FontWeight.w600,
            //         ),        overflow: TextOverflow.visible, // To avoid overflow text
            //       ),Text('QAR 134',style: TextStyle(color: AppColors.secondary,fontWeight: FontWeight.w600,fontSize: screenWidth*.034),)
            //     ],
            //   ),
            // ),
             SizedBox(height: screenHeight*.01,),
            BuildOrderButtonsDelivery(context,screenWidth, screenHeight, orderStatus,paymentStatus,order)
          ],
        ),
      ),
    ),
  );
}


Widget BuildOrderButtonsDelivery(
    BuildContext context,
    double screenWidth,
    double screenHeight,
    String orderStatus,
    String paymentStatus,
    ClientOrder? clientOrder,
    ) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: InkWell(
          onTap: (){
            Navigator.push
              (context, MaterialPageRoute(builder: (context)=>
                OrderDetailScreen(orderStatus: orderStatus,paymentStatus: paymentStatus,clientOrder:clientOrder!,fromDeliveryMan:true)));

          },
          child: Padding(
            padding: EdgeInsetsGeometry.only(right: screenWidth * .01),
            child:CustomGradientButton( 'assets/images/orders/hugeicons_view.svg',
   screenWidth * .015 ,'View Details', screenWidth, screenHeight)

          ),
        ),
      ),


      orderStatus == 'On The Way'
          ? Expanded(
        child: InkWell(
          onTap: (){
            showDialog(
              context: context,
              builder: (ctx) =>
                  CancelAlertDialog(orderId: clientOrder!.id.toString(),),
            );

          },
          child: BuildOutlinedIconButton(screenWidth, screenHeight, 'Mark As Delivered', (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TrackOrderScreen(),
              ),
            );
          },fromDelivery: true),
        ),
      )
          : SizedBox(),
    ],
  );
}

