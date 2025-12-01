import 'package:flutter/material.dart';
import 'package:newwwwwwww/features/orders/presentation/widgets/cancel_order_buttons.dart';

import '../../../../core/theme/colors.dart';
import '../../../auth/presentation/widgets/auth_buttons.dart';
import '../../../auth/presentation/widgets/build_custome_full_text_field.dart';
import '../../../coupons/presentation/widgets/custom_text.dart';
import '../../../home/presentation/widgets/main_screen_widgets/suppliers/build_info_button.dart';
import '../../../profile/presentation/widgets/add_new_address_alert.dart';
import '../../../profile/presentation/widgets/address_card.dart';

class ChangeAddressAlert extends StatefulWidget {
bool fromCouponCard;
ChangeAddressAlert({this.fromCouponCard=false});

  @override
  State<ChangeAddressAlert> createState() => _ChangeAddressAlertState();
}

class _ChangeAddressAlertState extends State<ChangeAddressAlert> {
  final TextEditingController _addressNameController = TextEditingController();
  final TextEditingController _zoneNoController = TextEditingController();
  final TextEditingController _streetNoController = TextEditingController();
  final TextEditingController _buildingNoController = TextEditingController();
  final TextEditingController _flatNoController = TextEditingController();

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
        //  height: widget.useGps ? screenHeight * .35 : screenHeight * 0.78,
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
                      'Change Address',
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
            Text("Change The Delivery Address If You Want",style: TextStyle(color: AppColors.greyDarktextIntExtFieldAndIconsHome,fontSize: screenWidth*.034)),
           widget.fromCouponCard?
           Column(
             children: [
               BuildCardAddress(
                 context,
                 screenHeight,
                 screenWidth,
                 work: false,//work true
                 fromCart: true,
                   fromCouponCard:widget.fromCouponCard
               ),
               BuildCardAddress(
                   context,
                   screenHeight,
                   screenWidth,
                   work: true,//work true
                   fromCart: true,
                   fromCouponCard:widget.fromCouponCard
               ),
             ],
           )
               : BuildCardAddress(
              context,
              screenHeight,
              screenWidth,
              work: false,//work true
              fromCart: true,
            ),
            BuildInfoAndAddToCartButton(
              screenWidth,
              screenHeight,
              'Add New Address',
              false,
              () {
                showDialog(
                  context: context,
                  builder: (ctx) => AddAddressAlertDialog(),
                );
              },
              fromDelivery: true,
            ),
            OutlineAuthButton(
              screenWidth,
              screenHeight,
              'Use Current Location',
              () {
                showDialog(
                  context: context,
                  builder: (ctx) => AddAddressAlertDialog(useGps: true),
                );
              },
              fromDelivery: true,
              icon: 'assets/images/profile/delivery/current_location.svg',
            ),
            OutlineAuthButton(
              screenWidth,
              screenHeight,
              'Open Google Map',
              () {
                showDialog(
                  context: context,
                  builder: (ctx) => AddAddressAlertDialog(useGps: true),
                );
              },
              fromDelivery: true,
              icon: 'assets/images/profile/delivery/google maps.svg',
            ),
                CancelOrderWidget(
                  context,
                  screenWidth,
                  screenHeight,
                  'Confirm',
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
    _zoneNoController.dispose();
    _streetNoController.dispose();
    _buildingNoController.dispose();
    _flatNoController.dispose();
    _addressNameController.dispose();
    super.dispose();
  }
}
