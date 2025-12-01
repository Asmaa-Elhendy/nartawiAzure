import 'package:flutter/material.dart';
import 'package:newwwwwwww/features/orders/presentation/widgets/cancel_order_buttons.dart';
import '../../../../core/theme/colors.dart';
import '../../../features/coupons/presentation/widgets/custom_text.dart';

class ConfirmationAlert extends StatefulWidget {
  String centerTitle;
String leftTtile;
void Function() leftOnTap;
bool itemAAdedToCart=false; // to display price if add to cart
ConfirmationAlert({required this.centerTitle,required this.leftTtile,required this.leftOnTap, this.itemAAdedToCart=false});

  @override
  State<ConfirmationAlert> createState() => _ConfirmationAlertState();
}

class _ConfirmationAlertState extends State<ConfirmationAlert> {


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Dialog(
      // Use Dialog instead of AlertDialog
      backgroundColor: AppColors.backgroundAlert,
      insetPadding: EdgeInsets.all(16), // controls distance from screen edges
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.94, // 90% screen width
        //    height: MediaQuery.of(context).size.height * 0.68, // adjust height
        child: Padding(
          padding: EdgeInsets.only(
            top: screenHeight * .04,
            bottom: screenHeight * .04,
            left: screenWidth * .05,
            right: screenWidth * .05,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customCouponPrimaryTitle(
                     widget.centerTitle,
                      screenWidth,
                      screenHeight,
                    ),
                    Text("QAR 100",style: TextStyle(color: AppColors.primary,fontWeight: FontWeight.w500,fontSize: screenWidth*.042),)
                  ],
                ),


                SizedBox(height: screenHeight * .02),
                CancelOrderWidget(
                  context,
                  screenWidth,
                  screenHeight,
                  widget.leftTtile,
                  'Cancel',
                      widget.leftOnTap,
                      () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
