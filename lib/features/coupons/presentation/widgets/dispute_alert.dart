import 'package:flutter/material.dart';
import 'package:newwwwwwww/features/coupons/presentation/widgets/take_photo_buttons.dart';
import 'package:newwwwwwww/features/orders/presentation/widgets/cancel_order_buttons.dart';
import 'package:newwwwwwww/features/orders/presentation/widgets/custom_text_field_alert.dart';

import '../../../../core/theme/colors.dart';
import 'custom_text.dart';

class DisputeAlertDialog extends StatefulWidget {
  const DisputeAlertDialog({super.key});

  @override
  State<DisputeAlertDialog> createState() => _DisputeAlertDialogState();
}

class _DisputeAlertDialogState extends State<DisputeAlertDialog> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return     Dialog( // Use Dialog instead of AlertDialog
      backgroundColor: AppColors.backgroundAlert,
      insetPadding: EdgeInsets.all(16), // controls distance from screen edges
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.94, // 90% screen width
        height: MediaQuery.of(context).size.height * 0.43, // adjust height
        child: Padding(
          padding:  EdgeInsets.symmetric(vertical: screenHeight*.02,horizontal: screenWidth*.05),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment:CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customCouponPrimaryTitle(
                      'Dispute',
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
                Text('Write Your Dispute Here',
                  style: TextStyle(
                    fontSize: screenWidth * .036,color: AppColors.greyDarktextIntExtFieldAndIconsHome,
                    fontWeight: FontWeight.w300,),),
                SizedBox(height:screenHeight*.01 ),

                CustomTextFieldAlert(
                    'Write your dispute here, explaining all your reasons'
                ),
                TakePhotosButtonsWidget(context, screenWidth, screenHeight, 'Upload Photo', 'Take Photo', (){}, (){}),
                SizedBox(height: screenHeight*.01,),

                CancelOrderWidget(context, screenWidth, screenHeight,'Dispute','Cancel',(){
                  Navigator.pop(context);//send dispute to api
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
