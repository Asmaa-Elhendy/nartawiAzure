import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:newwwwwwww/features/orders/presentation/widgets/cancel_order_buttons.dart';

import '../../../../core/theme/colors.dart';
import '../../../../injection_container.dart';
import '../../../auth/presentation/widgets/auth_buttons.dart';
import '../../../coupons/presentation/widgets/custom_text.dart';
import '../../../home/presentation/widgets/main_screen_widgets/suppliers/build_info_button.dart';
import '../../../profile/domain/models/client_address.dart';
import '../../../profile/presentation/provider/address_controller.dart';
import '../../../profile/presentation/widgets/add_new_address_alert.dart';
import '../../../profile/presentation/widgets/address_card.dart';
import '../widgets/delivery_address_cart.dart';

class ChangeAddressAlert extends StatefulWidget {
  bool fromCouponCard;
  ChangeAddressAlert({this.fromCouponCard = false});

  @override
  State<ChangeAddressAlert> createState() => _ChangeAddressAlertState();
}

class _ChangeAddressAlertState extends State<ChangeAddressAlert> {
  late AddressController addressController;

  ClientAddress? _selectedAddress; // ✅ selected

  @override
  void initState() {
    super.initState();
    // ✅ Use shared AddressController from DI container
    addressController = sl<AddressController>();
    
    // ✅ Delay fetch to avoid build phase issues
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        addressController.fetchAddresses();
      }
    });
  }

  void _onConfirm() {
    if (_selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an address'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    Navigator.pop(context, _selectedAddress); // ✅ return selected
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      backgroundColor: AppColors.backgroundAlert,
      insetPadding: EdgeInsets.all(16),
      child: SizedBox(
        width: screenWidth * 0.94,
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
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.close,
                        size: screenWidth * .05,
                        color: AppColors.greyDarktextIntExtFieldAndIconsHome,
                      ),
                    ),
                  ],
                ),
                Text(
                  "Change The Delivery Address If You Want",
                  style: TextStyle(
                    color: AppColors.greyDarktextIntExtFieldAndIconsHome,
                    fontSize: screenWidth * .034,
                  ),
                ),

                widget.fromCouponCard
                    ? Column(
                  children: [
                    BuildCardAddress(
                      controller: addressController,
                      context,
                      screenHeight,
                      screenWidth,
                      selected: false,
                      fromCart: true,
                      fromCouponCard: widget.fromCouponCard,
                    ),
                    BuildCardAddress(
                      controller: addressController,
                      context,
                      screenHeight,
                      screenWidth,
                      selected: true,
                      fromCart: true,
                      fromCouponCard: widget.fromCouponCard,
                    ),
                  ],
                )
                    : AnimatedBuilder(
                  animation: addressController,
                  builder: (context, _) {
                    if (addressController.isLoading) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: screenHeight * .02),
                        child: Center(
                          child: CircularProgressIndicator(color: AppColors.primary),
                        ),
                      );
                    }

                    if (addressController.error != null) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: screenHeight * .01),
                        child: Text(
                          addressController.error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }

                    final list = addressController.addresses;

                    if (list.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: screenHeight * .02),
                        child: Text(
                          'No addresses found',
                          style: TextStyle(
                            color: AppColors.greyDarktextIntExtFieldAndIconsHome,
                            fontSize: screenWidth * .034,
                          ),
                        ),
                      );
                    }

                    return Column(
                      children: list.map((addr) {
                        final isSelected = _selectedAddress?.id == addr.id;

                        return BuildCardAddress(
                          context,
                          screenHeight,
                          screenWidth,
                          controller: addressController,
                          fromCart: true,
                          fromCouponCard: widget.fromCouponCard,
                          address: addr,

                          // ✅ نفس design (work=true border)
                          selected: isSelected,

                          // ✅ FIX: select tap جوّا الكارت نفسه
                          selectable: true,
                          onSelect: () {
                            setState(() {
                              _selectedAddress = addr;
                            });
                          },
                        );
                      }).toList(),
                    );
                  },
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
                    ).then((_) {
                      // بعد إضافة عنوان جديد (لو الديالوج بيرجع true) ممكن تعملي refresh
                      addressController.refresh();
                    });
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
                      builder: (ctx) =>     AddAddressAlertDialog(useGps: true),
                    ).then((_) => addressController.refresh());
                  },
                  fromDelivery: true,
                  icon: 'assets/images/profile/delivery_man/current_location.svg',
                ),
                OutlineAuthButton(
                  screenWidth,
                  screenHeight,
                  'Open Google Map',
                      () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AddAddressAlertDialog(pickFromMap: true),
                    ).then((_) => addressController.refresh());
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
                  _onConfirm,
                      () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
