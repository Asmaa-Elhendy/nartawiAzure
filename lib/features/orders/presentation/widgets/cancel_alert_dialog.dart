import 'package:flutter/material.dart';
import 'package:newwwwwwww/features/orders/presentation/widgets/cancel_order_buttons.dart';

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
          padding:  EdgeInsets.symmetric(vertical: screenHeight*.01,horizontal: screenWidth*.05),
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
                Container(
                  margin: EdgeInsets.symmetric(
                    vertical: screenHeight * .02,
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: screenHeight * .035,
                    horizontal: screenWidth * .03,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.greyDarktextIntExtFieldAndIconsHome, // 👈 Border color
                      width: .5, // 👈 Optional: Border thickness
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsetsGeometry.symmetric(horizontal: screenWidth*.01),
                      labelText: 'please provide a reason for cancellation this order', // Optional: A label for the text field
                      border: InputBorder.none, // Removes the default underline border
                      labelStyle: TextStyle(
                        fontSize: screenWidth * .036,color: AppColors.greyDarktextIntExtFieldAndIconsHome,
                        fontWeight: FontWeight.w300,),
                    ),
                    keyboardType: TextInputType.multiline, // Enables multi-line input on the soft keyboard
                    minLines: 1, // Optional: Sets the initial minimum number of lines
                    maxLines: 5, // Optional: Limits the maximum number of visible lines before scrolling
                    // or maxLines: null, // Allows the text field to expand indefinitely based on content
                  ),
                ),
                CancelOrderWidget(context, screenWidth, screenHeight)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
