import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:newwwwwwww/features/orders/presentation/widgets/cancel_order_buttons.dart';
import 'package:geolocator/geolocator.dart';

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

  final _formKey = GlobalKey<FormState>();

  bool _isSubmitting = false;

  // =========================
  // ✅ GPS Helpers (Geolocator)
  // =========================
  Future<Position?> getCurrentPositionSafely(BuildContext context) async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enable location services (GPS)')),
      );
      await Geolocator.openLocationSettings();
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission is required')),
        );
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Location permission permanently denied. Please enable it from settings.',
          ),
        ),
      );
      await Geolocator.openAppSettings();
      return null;
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // =========================
  // ✅ Reverse Geocoding (EN then AR fallback)
  // =========================
  Future<String> _reverseGeocode(double lat, double lng, {required String locale}) async {
    final placemarks = await placemarkFromCoordinates(
      lat,
      lng,
      localeIdentifier: locale,
    );

    if (placemarks.isEmpty) return '';

    final p = placemarks.first;

    final parts = <String>[
      if ((p.name ?? '').trim().isNotEmpty) p.name!.trim(),
      if ((p.street ?? '').trim().isNotEmpty) p.street!.trim(),
      if ((p.subLocality ?? '').trim().isNotEmpty) p.subLocality!.trim(),
      if ((p.locality ?? '').trim().isNotEmpty) p.locality!.trim(),
      if ((p.administrativeArea ?? '').trim().isNotEmpty) p.administrativeArea!.trim(),
      if ((p.country ?? '').trim().isNotEmpty) p.country!.trim(),
    ];

    return parts.join(', ').trim();
  }

  Future<String> getAddressFromLatLng(double latitude, double longitude) async {
    try {
      // ✅ Try EN first
      final en = await _reverseGeocode(latitude, longitude, locale: 'en');
      if (en.isNotEmpty) return en;

      // ✅ Then AR (often better in GCC)
      final ar = await _reverseGeocode(latitude, longitude, locale: 'ar');
      if (ar.isNotEmpty) return ar;

      // ✅ Final fallback
      return 'Lat: $latitude, Lng: $longitude';
    } catch (e) {
      debugPrint('Reverse geocoding failed: $e');
      return 'Lat: $latitude, Lng: $longitude';
    }
  }

  void _showMsg(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  bool _isNumeric(String s) => int.tryParse(s.trim()) != null;

  bool _validateManualFields() {
    final title = _addressNameController.text.trim();
    final address = _addressController.text.trim();
    final zone = _zoneNoController.text.trim();
    final street = _streetNoController.text.trim();
    final building = _buildingNoController.text.trim();
    final flat = _flatNoController.text.trim();

    if (title.isEmpty) {
      _showMsg('Title is required');
      return false;
    }
    if (address.isEmpty) {
      _showMsg('Address is required');
      return false;
    }
    if (zone.isEmpty || street.isEmpty || building.isEmpty || flat.isEmpty) {
      _showMsg('Please fill all address details');
      return false;
    }
    if (!_isNumeric(zone) || !_isNumeric(street) || !_isNumeric(building) || !_isNumeric(flat)) {
      _showMsg('Zone/Street/Building/Flat must be numbers');
      return false;
    }
    return true;
  }

  // =========================
  // ✅ Handle Add Address (Manual + GPS)
  // =========================
  Future<bool> handleAddNewAddress({
    required BuildContext context,
    required String title,
    required String address,
    required String zone,
    required String street,
    required String building,
    required String flat,
    bool useGps = false,
    double? latitude,
    double? longitude,
  }) async {
    final controller = AddressController(dio: Dio());

    if (title.trim().isEmpty) {
      _showMsg('Title is required');
      return false;
    }

    if (useGps) {
      if (latitude == null || longitude == null) {
        _showMsg('Failed to get current location');
        return false;
      }
    } else {
      if (address.trim().isEmpty) {
        _showMsg('Address is required');
        return false;
      }
      if (zone.trim().isEmpty || street.trim().isEmpty || building.trim().isEmpty || flat.trim().isEmpty) {
        _showMsg('Please fill all address details');
        return false;
      }
    }

    final finalAddress = address.trim().isEmpty
        ? (useGps ? 'Lat: $latitude, Lng: $longitude' : '')
        : address.trim();

    final success = await controller.addNewAddress(
      AddAddressRequest(
        title: title.trim(),
        address: finalAddress,
        areaId: 1, // TODO: link areaId with your Areas API
        latitude: useGps ? latitude! : 0,
        longitude: useGps ? longitude! : 0,
        streetNum: useGps ? null : int.tryParse(street),
        buildingNum: useGps ? null : int.tryParse(building),
        doorNumber: useGps ? null : int.tryParse(flat),
        floorNum: null,
        notes: null,
      ),
      refreshAfter: true,
    );

    if (!success) {
      _showMsg(controller.createError ?? 'Failed to create address');
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      backgroundColor: AppColors.backgroundAlert,
      insetPadding: const EdgeInsets.all(16),
      child: SizedBox(
        width: screenWidth * 0.94,
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
                      customCouponPrimaryTitle('Add New Address', screenWidth, screenHeight),
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

                  buildCustomeFullTextField(
                    'Title',
                    'Enter Title',
                    _addressNameController,
                    false,
                    screenHeight,
                    fromEditProfile: true,
                  ),

                  widget.useGps
                      ? const SizedBox()
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
                        'Enter Zone Number',
                        isNumberKeyboard: true,
                        _zoneNoController,
                        false,
                        screenHeight,
                        fromEditProfile: true,
                      ),
                      SizedBox(height: screenHeight * .01),
                      buildCustomeFullTextField(
                        'Street Number',
                        'Enter Street Number',
                        isNumberKeyboard: true,
                        _streetNoController,
                        false,
                        screenHeight,
                        fromEditProfile: true,
                      ),
                      SizedBox(height: screenHeight * .01),
                      buildCustomeFullTextField(
                        'Building Number',
                        'Enter Building Number',
                        isNumberKeyboard: true,
                        _buildingNoController,
                        false,
                        screenHeight,
                        fromEditProfile: true,
                      ),
                      SizedBox(height: screenHeight * .01),
                      buildCustomeFullTextField(
                        'Flat Number',
                        'Enter Flat Number',
                        isNumberKeyboard: true,
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
                    _isSubmitting ? 'Please wait...' : 'Add New Address',
                    'Cancel',
                        () async {
                      if (_isSubmitting) return;

                      setState(() => _isSubmitting = true);

                      try {
                        // ✅ GPS flow
                        if (widget.useGps) {
                          if (_addressNameController.text.trim().isEmpty) {
                            _showMsg('Title is required');
                            return;
                          }

                          final pos = await getCurrentPositionSafely(context);
                          if (pos == null) return;

                          final resolvedAddress = await getAddressFromLatLng(
                            pos.latitude,
                            pos.longitude,
                          );

                          final ok = await handleAddNewAddress(
                            context: context,
                            title: _addressNameController.text,
                            address: resolvedAddress, // ✅ real address OR lat/lng fallback
                            zone: '',
                            street: '',
                            building: '',
                            flat: '',
                            useGps: true,
                            latitude: pos.latitude,
                            longitude: pos.longitude,
                          );

                          if (ok) Navigator.pop(context, true);
                          return;
                        }

                        // ✅ Manual flow (IMPORTANT: was missing before)
                        if (!_validateManualFields()) return;

                        final ok = await handleAddNewAddress(
                          context: context,
                          title: _addressNameController.text,
                          address: _addressController.text,
                          zone: _zoneNoController.text,
                          street: _streetNoController.text,
                          building: _buildingNoController.text,
                          flat: _flatNoController.text,
                          useGps: false,
                        );

                        if (ok) Navigator.pop(context, true);
                      } finally {
                        if (mounted) setState(() => _isSubmitting = false);
                      }
                    },
                        () => Navigator.pop(context),
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
    _addressController.dispose();
    super.dispose();
  }
}
