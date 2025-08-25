import 'package:flutter/material.dart';
import 'package:newwwwwwww/features/orders/presentation/widgets/cancel_order_buttons.dart';

import '../../../../core/theme/colors.dart';
import '../../../auth/presentation/widgets/build_custome_full_text_field.dart';
import '../../../coupons/presentation/widgets/custom_text.dart';

class ChangePasswordAlert extends StatefulWidget {
  @override
  State<ChangePasswordAlert> createState() => _ChangePasswordAlertState();
}

class _ChangePasswordAlertState extends State<ChangePasswordAlert> {
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newpasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Dialog(
      // Use Dialog instead of AlertDialog
      backgroundColor: AppColors.backgroundAlert,
      insetPadding: EdgeInsets.all(16), // controls distance from screen edges
      child: SizedBox(
        width: screenWidth * 0.94,
        // 90% screen width
        height: screenHeight * 0.58,
        // adjust height
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: screenHeight * .02,
            horizontal: screenWidth * .05,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customCouponPrimaryTitle(
                      'Change Password',
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
                buildCustomeFullTextField(
                  'Current Password',
                  'Current New Password ',
                  _passwordController,
                  true,
                  screenHeight,
                ),
                buildCustomeFullTextField(
                  'New Password',
                  'New Password',
                  _confirmPasswordController,
                  true,
                  screenHeight,
                ),
                buildCustomeFullTextField(
                  'Confirm New Password',
                  'Enter Confirmed New Password',
                  _confirmPasswordController,
                  true,
                  screenHeight,
                ),

                SizedBox(height: screenHeight * .02),
                CancelOrderWidget(
                  context,
                  screenWidth,
                  screenHeight,
                  'Change Password',
                  'Cancel',
                  () {
                    Navigator.pop(context); //send dispute to api
                  },
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

  @override
  void dispose() {
    _confirmPasswordController.dispose();
    _passwordController.dispose();
    _newpasswordController.dispose();
    super.dispose();
  }
}
