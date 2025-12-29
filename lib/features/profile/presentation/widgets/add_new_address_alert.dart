import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:newwwwwwww/features/orders/presentation/widgets/cancel_order_buttons.dart';

import '../../../../core/theme/colors.dart';
import '../../../auth/presentation/widgets/build_custome_full_text_field.dart';
import '../../../coupons/presentation/widgets/custom_text.dart';
import '../../domain/models/address_req.dart';
import '../provider/client_controller.dart';

class AddAddressAlertDialog extends StatefulWidget {
  final bool useGps;

  AddAddressAlertDialog({this.useGps = false});

  @override
  State<AddAddressAlertDialog> createState() => _AddAddressAlertDialogState();
}

class _AddAddressAlertDialogState extends State<AddAddressAlertDialog> {
  final TextEditingController _addressNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final TextEditingController _zoneNoController = TextEditingController();
  final TextEditingController _streetNoController = TextEditingController();
  final TextEditingController _buildingNoController = TextEditingController();
  final TextEditingController _flatNoController = TextEditingController();


  Future<bool> handleAddNewAddress({
    required BuildContext context,
    required String title,
    required String address,
    required String zone,
    required String street,
    required String building,
    required String flat,
  }) async {
    final controller = AddressController(dio: Dio());




    final success = await controller.addNewAddress(
      AddAddressRequest(
        title: title,
        address: address,
        areaId: 1,        // 🔹 عدليها لما تربطي Areas (zone number) get from api
        latitude: 0,      // 🔹 GPS لاحقًا
        longitude: 0,
        streetNum: int.tryParse(street),
        buildingNum: int.tryParse(building),
        doorNumber: int.tryParse(flat),
        floorNum: null,
        notes: null,
      ),
      refreshAfter: true,
    );

    if (!success) {

      return false;
    }

    return true;
  }
  final _formKey = GlobalKey<FormState>();


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
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  buildCustomeFullTextField(
                    'Title',
                    'Enter Title',
                    _addressNameController,
                    false,
                    screenHeight,
                    fromEditProfile: true,
                  ),
                  widget.useGps
                      ? SizedBox()
                      : Column(
                          children: [
                            SizedBox(height: screenHeight * .01),
                            buildCustomeFullTextField(
                              'Address ',
                              'Enter Address ',
                              _addressController,
                              false,
                              screenHeight,
                              fromEditProfile: true,
                            ),
                            SizedBox(height: screenHeight * .01),
                            buildCustomeFullTextField(
                              'Zone Number',
                              'Enter Zone Number',isNumberKeyboard: true,
                              _zoneNoController,
                              false,
                              screenHeight,
                              fromEditProfile: true,
                            ),
                            SizedBox(height: screenHeight * .01),

                            buildCustomeFullTextField(isNumberKeyboard: true,
                              'Street Number',
                              'Enter Street Number',
                              _streetNoController,
                              false,
                              screenHeight,
                              fromEditProfile: true,
                            ),
                            SizedBox(height: screenHeight * .01),

                            buildCustomeFullTextField(isNumberKeyboard: true,
                              'Building Number',
                              'Enter Building Number',
                              _buildingNoController,
                              false,
                              screenHeight,
                              fromEditProfile: true,
                            ),
                            SizedBox(height: screenHeight * .01),

                            buildCustomeFullTextField(isNumberKeyboard: true,
                              'Flat Number',
                              'Enter Flat Number',
                              _flatNoController,
                              false,
                              screenHeight,
                              fromEditProfile: true,
                            ),
                          ],
                        ),
                  SizedBox(height: screenHeight * .02),
                  CancelOrderWidget(
                    context,
                    screenWidth,
                    screenHeight,
                    'Add New Address',
                    'Cancel',
                        () async { // add new address
                          if (!(_formKey.currentState?.validate() ?? false)) return;

                          final ok = await handleAddNewAddress(
                        context: context,
                        title: _addressNameController.text,address: _addressController.text,
                        zone: _zoneNoController.text,
                        street: _streetNoController.text,
                        building: _buildingNoController.text,
                        flat: _flatNoController.text,
                      );

                      if (ok) {
                        Navigator.pop(context, true); // يرجّع نجاح
                      }
                    }
              ,
                    () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
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
