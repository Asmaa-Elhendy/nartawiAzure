import 'package:flutter/material.dart';
import 'package:newwwwwwww/features/coupons/presentation/widgets/custom_text.dart';
import 'package:newwwwwwww/features/coupons/presentation/widgets/show_delivery_photos.dart';
import 'package:newwwwwwww/features/orders/presentation/widgets/cancel_order_buttons.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/components/coupon_status_widget.dart';
import 'dispute_alert.dart';
import 'oulined_icon_button.dart';

class ViewConsumptionHistoryAlert extends StatefulWidget {
bool disbute;
ViewConsumptionHistoryAlert({required this.disbute}) ;
@override
  State<ViewConsumptionHistoryAlert> createState() =>
      _ViewConsumptionHistoryAlertState();
}

class _ViewConsumptionHistoryAlertState
    extends State<ViewConsumptionHistoryAlert> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Dialog(
      backgroundColor: AppColors.backgroundAlert,
      insetPadding: EdgeInsets.all(16), // controls distance from screen edges
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.94, // 90% screen width
        height:widget.disbute?screenHeight*.6 :screenHeight* 0.5, // adjust height
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: screenHeight * .02,
            horizontal: screenWidth * .05,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  customCouponPrimaryTitle(
                    'Coupon Details',
                    screenWidth,
                    screenHeight,
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.close,
                      size: screenWidth * .05,
                      color: AppColors.greyDarktextIntExtFieldAndIconsHome,
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * .01),
              Container(
                width: screenWidth,
                // height: screenHeight*.1,
                margin: EdgeInsets.only(bottom: screenHeight * .015),
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * .02,
                  horizontal: screenWidth * .03,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xffECEBEA), // 👈 Border color
                    width: 1, // 👈 Optional: Border thickness
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '1 Coupon Marked Used',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: screenWidth * .036,
                      ),
                    ),
                    SizedBox(height: screenHeight * .01),
                    customCouponAlertSubTitle(   'Marked On March 5, 2025', screenWidth, screenHeight),

                    SizedBox(height: screenHeight * .02),
                    customCouponAlertTitle(  'Marked By', screenWidth, screenHeight),

                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * .01,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          customCouponAlertSubTitle('Company 1', screenWidth, screenHeight),
                          CouponStatus(screenHeight, screenWidth, 'Vendor'),
                        ],
                      ),
                    ),
                widget.disbute?
                    Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(color: AppColors.backgrounHome,),

                        customCouponAlertTitle('Dispute Reason', screenWidth, screenHeight),
                        SizedBox(height: screenHeight * .01),
                       customCouponAlertSubTitle( 'Never Received Water', screenWidth, screenHeight),
                        customCouponAlertTitle('Resolution', screenWidth, screenHeight),
                        SizedBox(height: screenHeight * .01),
                        customCouponAlertSubTitle( 'Returned', screenWidth, screenHeight)


                      ],
                    )
                    :BuildOutlinedIconButton(
                      screenWidth,
                      screenHeight,
                      'Show Delivery Photos',
                      () {
                        showDialog(
                          context: context,
                          builder: (ctx) => ShowDeliveryPhotos(),
                        );
                      },
                    ),
                  ],
                ),
              ),

         widget.disbute?
         CancelOrderWidget(
             context,
             screenWidth,
             screenHeight,
             'Dispute Resolved',//send to api
             'Dispute',
                 (){
               Navigator.pop(context);

             },(){
           Navigator.pop(context);
           showDialog(
             context: context,
             builder: (ctx) =>
                 DisputeAlertDialog(),
           );
         }
         )
             : CancelOrderWidget(
                context,
                screenWidth,
                screenHeight,
                'Done',
                'Dispute',
                  (){
                    Navigator.pop(context);

                  },(){
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (ctx) =>
                      DisputeAlertDialog(),
                );
              }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
