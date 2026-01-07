import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../injection_container.dart';
import '../../../profile/presentation/provider/address_controller.dart';
import '../../../profile/domain/models/client_address.dart';
import '../../../auth/presentation/widgets/auth_buttons.dart';
import '../../../profile/presentation/widgets/address_card.dart';
import 'change_address_alert.dart';

class OrderDeliveryCartWidget extends StatefulWidget {
  const OrderDeliveryCartWidget({super.key});

  @override
  State<OrderDeliveryCartWidget> createState() => _OrderDeliveryCartWidgetState();
}

class _OrderDeliveryCartWidgetState extends State<OrderDeliveryCartWidget> {
  late AddressController addressController;

  ClientAddress? _selectedAddress;

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

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedBuilder(
                animation: addressController,
                builder: (context, _) {
                  if (addressController.isLoading) {
                    return Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    );
                  }

                  if (addressController.error != null) {
                    return Text(
                      addressController.error!,
                      style: const TextStyle(color: Colors.red),
                    );
                  }

                  final list = addressController.addresses;

                  if (list.isEmpty) {
                    return Text(
                      'No addresses found',
                      style: TextStyle(
                        color: AppColors.greyDarktextIntExtFieldAndIconsHome,
                        fontSize: screenWidth * .034,
                      ),
                    );
                  }

                  // ✅ لو مختار من dialog
                  if (_selectedAddress != null) {
                    return BuildCardAddress(
                      context,
                      screenHeight,
                      screenWidth,
                      controller: addressController,
                      fromCart: true,
                      address: _selectedAddress!,
                    );
                  }

                  // ✅ default
                  final defaultList = list.where((a) => a.isDefault == true).toList();
                  if (defaultList.isEmpty) {
                    return Center(
                      child: Text(
                        'No Default Address',
                        style: TextStyle(
                          color: AppColors.greyDarktextIntExtFieldAndIconsHome,
                          fontSize: screenWidth * .034,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }

                  return BuildCardAddress(
                    context,
                    screenHeight,
                    screenWidth,
                    controller: addressController,
                    fromCart: true,
                    address: defaultList.first,
                  );
                },
              ),

              OutlineAuthButton(
                screenWidth,
                screenHeight,
                'Change Address',
                    () async {
                  final selected = await showDialog<ClientAddress>(
                    context: context,
                    builder: (ctx) => ChangeAddressAlert(),
                  );

                  if (selected != null) {
                    setState(() {
                      _selectedAddress = selected;
                    });
                  }
                },
                fromDelivery: false,
                icon: 'assets/images/profile/delivery_man/current_location.svg',
              ),
            ],
          ),

          SizedBox(height: screenHeight * .01),
        ],
      ),
    );
  }
}
