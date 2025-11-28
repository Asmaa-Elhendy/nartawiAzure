import 'package:flutter/material.dart';
import 'package:newwwwwwww/features/orders/presentation/widgets/cancel_order_buttons.dart';
import '../../../../core/theme/colors.dart';
import '../../../auth/presentation/widgets/build_custome_full_text_field.dart';
import '../../../coupons/presentation/widgets/custom_text.dart';

class TransferAlertDialog extends StatefulWidget {
  const TransferAlertDialog({super.key});

  @override
  State<TransferAlertDialog> createState() => _TransferAlertDialogState();
}

class _TransferAlertDialogState extends State<TransferAlertDialog> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _recipientController = TextEditingController();
  final TextEditingController _buildingNoController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customCouponPrimaryTitle(
                      'Transfer Funds',
                      screenWidth,
                      screenHeight,
                    ),
                    // IconButton(
                    //   onPressed: () {
                    //     Navigator.pop(context);
                    //   },
                    //   icon:
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close,
                        size: screenWidth * .05,
                        color: AppColors.greyDarktextIntExtFieldAndIconsHome,
                        //    ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: screenHeight * .01),
                  child: Text(
                    'Send Money To Another User\'s Wallet',
                    style: TextStyle(
                      color: AppColors.greyDarktextIntExtFieldAndIconsHome,
                      fontWeight: FontWeight.w300,
                      fontSize: screenWidth * .036,
                    ),
                  ),
                ),
                buildCustomeFullTextField(
                  'Amount (QAR)',
                  '0.00',
                  _amountController,
                  false,
                  screenHeight,
                  fromEditProfile: true,
                ),
                SizedBox(height: screenHeight * .01),

                buildCustomeFullTextField(
                  'Recipient',
                  'User Name or Mobile Number',
                  _recipientController,
                  false,
                  screenHeight,
                  fromEditProfile: true,
                ),
                // SizedBox(height: screenHeight * .01),
                //
                // buildCustomeFullTextField(
                //   'Building Number',
                //   'Enter Building Number',
                //   _buildingNoController,
                //   false,
                //   screenHeight,
                //   fromEditProfile: true,
                // ),
                SizedBox(height: screenHeight * .01),

                buildCustomeFullTextField(
                  'Description',
                  'Wallet Transfer',
                  _descriptionController,
                  false,
                  screenHeight,
                  fromEditProfile: true,
                ),
                SizedBox(height: screenHeight * .02),

                Text(
                  'Available Balance: QAR 1,000', // need , seperator issue
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w300,
                    fontSize: screenWidth * .036,
                  ),
                ),
                SizedBox(height: screenHeight * .02),
                CancelOrderWidget(
                  context,
                  screenWidth,
                  screenHeight,
                  'Transfer',
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
    _amountController.dispose();
    _recipientController.dispose();
    _buildingNoController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
