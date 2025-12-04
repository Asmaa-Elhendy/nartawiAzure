import 'package:flutter/material.dart';
import 'package:newwwwwwww/features/orders/presentation/widgets/cancel_order_buttons.dart';
import '../../../../core/theme/colors.dart';
import '../../../features/coupons/presentation/widgets/custom_text.dart';

class ConfirmationAlert extends StatefulWidget {
  String centerTitle;
String leftTtile;
String rightTitle;
void Function() leftOnTap;
double price;
  void Function() rightOnTap;
bool itemAAdedToCart=false; // to display price if add to cart
ConfirmationAlert({required this.price,required this.centerTitle,required this.leftTtile,required this.rightTitle,required this.leftOnTap, required this.rightOnTap,this.itemAAdedToCart=false});

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TEXTextConfirmationAlertTitle(
                       widget.centerTitle,
                        screenWidth,
                        screenHeight,
                      ),
                    ),SizedBox(width: screenWidth*.01,),
                  widget.itemAAdedToCart?  Text("QAR ${widget.price}",style: TextStyle(color: AppColors.primary,fontWeight: FontWeight.w500,fontSize: screenWidth*.042),)
                :SizedBox()  ],
                ),


                SizedBox(height: screenHeight * .02),
                CancelOrderWidget(
                  context,
                  screenWidth,
                  screenHeight,
                  widget.leftTtile,
                  widget.rightTitle,
                      widget.leftOnTap,
                  widget.rightOnTap,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
