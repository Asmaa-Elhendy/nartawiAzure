import 'package:flutter/material.dart';
import 'package:newwwwwwww/features/orders/presentation/widgets/cancel_order_buttons.dart';
import 'package:newwwwwwww/features/orders/presentation/widgets/custom_text_field_alert.dart';

import '../../../../core/theme/colors.dart';

class CancelAlertDialog extends StatefulWidget {
  const CancelAlertDialog({super.key});

  @override
  State<CancelAlertDialog> createState() => _CancelAlertDialogState();
}

class _CancelAlertDialogState extends State<CancelAlertDialog> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return     Dialog( // Use Dialog instead of AlertDialog
      backgroundColor: AppColors.backgroundAlert,
      insetPadding: EdgeInsets.all(16), // controls distance from screen edges
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.94, // 90% screen width
        height: MediaQuery.of(context).size.height * 0.5, // adjust height
        child: Padding(
          padding:  EdgeInsets.symmetric(vertical: screenHeight*.02,horizontal: screenWidth*.05),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment:CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Cancel Order',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: screenWidth * .04,
                          color: AppColors.redColor
                      ),
                    ),
                    IconButton(onPressed: (){Navigator.pop(context);},
                        icon: Icon(Icons.close,size: screenWidth*.05,color: AppColors.greyDarktextIntExtFieldAndIconsHome,))
                  ],
                ),
                SizedBox(height:screenHeight*.01 ),


                Text('Are you sure you want to cancel order #29? The amount (QAR 82.00) will be refunded to your wallet.',
                  style: TextStyle(
                    fontSize: screenWidth * .036,color: AppColors.greyDarktextIntExtFieldAndIconsHome,
                    fontWeight: FontWeight.w300,),),
                SizedBox(height: screenHeight*.03,),
                Text(
                  'Reason For Cancellation',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: screenWidth * .04,
                  ),
                ),
                CustomTextFieldAlert(
                    'please provide a reason for cancellation this order'
                ),
                CancelOrderWidget(context, screenWidth, screenHeight,'Keep Order','Cancel Order',(){
                  Navigator.pop(context);
                },(){
                  Navigator.pop(context);
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
