import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../auth/presentation/widgets/auth_buttons.dart';
import '../../../home/presentation/widgets/main_screen_widgets/suppliers/build_info_button.dart';
import '../../../profile/presentation/widgets/add_new_address_alert.dart';
import '../../../profile/presentation/widgets/address_card.dart';
import 'change_address_alert.dart';

class OrderDeliveryCartWidget extends StatefulWidget {
  const OrderDeliveryCartWidget({super.key});

  @override
  State<OrderDeliveryCartWidget> createState() =>
      _OrderDeliveryCartWidgetState();
}

class _OrderDeliveryCartWidgetState extends State<OrderDeliveryCartWidget> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.symmetric(vertical: screenHeight * .02),
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * .02,
        horizontal: screenWidth * .02,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.whiteColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Center(
            child: Text(
              'Delivery Address',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: screenWidth * .04,
                color: AppColors.primary,
              ),
            ),
          ),
          SizedBox(height: screenHeight * .02),

          // Item 1
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BuildCardAddress(
                context,
                screenHeight,
                screenWidth,
                fromCart: true,
              ),
              OutlineAuthButton(
                screenWidth,
                screenHeight,
                'Change Address',
                    () {
                  showDialog(
                    context: context,
                    builder: (ctx) =>
                        ChangeAddressAlert(),
                  );
                },
                fromDelivery: false,
                icon:
                'assets/images/profile/delivery/current_location.svg',
              ),
              // BuildCardAddress(
              //   context,
              //   screenHeight,
              //   screenWidth,
              //   work: true,
              //   fromCart: true,
              // ),
              // BuildInfoAndAddToCartButton(
              //   screenWidth,
              //   screenHeight,
              //   'Add New Address',
              //   false,
              //   () {
              //     showDialog(
              //       context: context,
              //       builder: (ctx) => AddAddressAlertDialog(),
              //     );
              //   },
              //   fromDelivery: true,
              // ),
              // OutlineAuthButton(
              //   screenWidth,
              //   screenHeight,
              //   'Use Current Location',
              //   () {
              //     showDialog(
              //       context: context,
              //       builder: (ctx) => AddAddressAlertDialog(useGps: true),
              //     );
              //   },
              //   fromDelivery: true,
              //   icon: 'assets/images/profile/delivery/current_location.svg',
              // ),
              // OutlineAuthButton(
              //   screenWidth,
              //   screenHeight,
              //   'Open Google Map',
              //   () {
              //     showDialog(
              //       context: context,
              //       builder: (ctx) => AddAddressAlertDialog(useGps: true),
              //     );
              //   },
              //   fromDelivery: true,
              //   icon: 'assets/images/profile/delivery/google maps.svg',
              // ),
            ],
          ),

          SizedBox(height: screenHeight * .01),

          // Item 2
        ],
      ),
    );
  }
}
