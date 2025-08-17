import 'package:flutter/material.dart';
import 'package:newwwwwwww/features/orders/presentation/widgets/cancel_order_buttons.dart';

import '../../../../core/theme/colors.dart';
import '../../../auth/presentation/widgets/build_custome_full_text_field.dart';
import '../../../coupons/presentation/widgets/custom_text.dart';

class AddAddressAlertDialog extends StatefulWidget {
  const AddAddressAlertDialog({super.key});

  @override
  State<AddAddressAlertDialog> createState() => _AddAddressAlertDialogState();
}

class _AddAddressAlertDialogState extends State<AddAddressAlertDialog> {
  final TextEditingController _zoneNoController = TextEditingController();
  final TextEditingController _streetNoController = TextEditingController();
  final TextEditingController _buildingNoController = TextEditingController();
  final TextEditingController _flatNoController = TextEditingController();

  @override

  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return     Dialog( // Use Dialog instead of AlertDialog
      backgroundColor: AppColors.backgroundAlert,
      insetPadding: EdgeInsets.all(16), // controls distance from screen edges
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.94, // 90% screen width
        height: MediaQuery.of(context).size.height * 0.67, // adjust height
        child: Padding(
          padding:  EdgeInsets.symmetric(vertical: screenHeight*.02,horizontal: screenWidth*.05),
          child: SingleChildScrollView(child: Column(
              crossAxisAlignment:CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customCouponPrimaryTitle(
                      'Add New Address',
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
                buildCustomeFullTextField('Zone Number', 'Enter Zone Number', _zoneNoController, false,screenHeight,fromEditProfile: true),
                SizedBox(height: screenHeight*.01,),

                buildCustomeFullTextField('Street Number', 'Enter Street Number', _streetNoController, false,screenHeight,fromEditProfile: true),
                SizedBox(height: screenHeight*.01,),

                buildCustomeFullTextField('Building Number', 'Enter Building Number', _buildingNoController, false,screenHeight,fromEditProfile: true),
                SizedBox(height: screenHeight*.01,),

                buildCustomeFullTextField('Flat Number', 'Enter Flat Number', _flatNoController, false,screenHeight,fromEditProfile: true),
                SizedBox(height: screenHeight*.02,),
                CancelOrderWidget(context, screenWidth, screenHeight,'Add New Address','Cancel',(){
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

  @override
  void dispose() {
    _zoneNoController.dispose();
    _streetNoController.dispose();
    _buildingNoController.dispose();
    _flatNoController.dispose();
    super.dispose();

  }
}
