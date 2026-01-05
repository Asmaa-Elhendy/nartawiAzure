import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:newwwwwwww/features/orders/presentation/widgets/cancel_order_buttons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../../../../injection_container.dart';
import '../../../../core/services/maps_screen.dart';
import '../../../../core/theme/colors.dart';
import '../../../auth/presentation/widgets/build_custome_full_text_field.dart';
import '../../../coupons/presentation/widgets/custom_text.dart';
import '../../domain/models/address_req.dart';
import '../provider/address_controller.dart';

class AddAddressAlertDialog extends StatefulWidget {
  final bool useGps;

  // ✅ NEW: if true -> open OSM map picker and choose location manually
  final bool pickFromMap;

  AddAddressAlertDialog({
    this.useGps = false,
    this.pickFromMap = false,
  });

  @override
  State<AddAddressAlertDialog> createState() => _AddAddressAlertDialogState();
}

class _AddAddressAlertDialogState extends State<AddAddressAlertDialog> {
  @override
  void initState() {
    super.initState();
    log(' AddAddressAlertDialog initState - useGps: ${widget.useGps}, pickFromMap: ${widget.pickFromMap}');
    log(' _isGpsMode: $_isGpsMode, _isMapMode: $_isMapMode, _isManualMode: $_isManualMode');
  }
  final TextEditingController _addressNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final TextEditingController _zoneNoController = TextEditingController();
  final TextEditingController _streetNoController = TextEditingController();
  final TextEditingController _buildingNoController = TextEditingController();
  final TextEditingController _flatNoController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  bool get _isGpsMode => widget.useGps == true;
  bool get _isMapMode => widget.pickFromMap == true;
  bool get _isManualMode => !_isGpsMode && !_isMapMode;

  // =========================
  // ✅ GPS Helpers (NO SnackBars)
  // =========================
  Future<Position?> getCurrentPositionSafely() async {
    log('🔥 Getting GPS position...');
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    log('🔥 Service enabled: $serviceEnabled');
    
    if (!serviceEnabled) {
      log('🔥 Opening location settings...');
      await Geolocator.openLocationSettings();
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    log('🔥 Permission: $permission');

    if (permission == LocationPermission.denied) {
      log('🔥 Permission denied, requesting...');
      permission = await Geolocator.requestPermission();
      log('🔥 Permission after request: $permission');
      if (permission == LocationPermission.denied) return null;
    }

    if (permission == LocationPermission.deniedForever) {
      log('🔥 Permission denied forever, opening app settings...');
      await Geolocator.openAppSettings();
      return null;
    }

    log('🔥 Getting current position...');
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
      final en = await _reverseGeocode(latitude, longitude, locale: 'en');
      if (en.isNotEmpty) return en;

      final ar = await _reverseGeocode(latitude, longitude, locale: 'ar');
      if (ar.isNotEmpty) return ar;

      return 'Lat: $latitude, Lng: $longitude';
    } catch (_) {
      return 'Lat: $latitude, Lng: $longitude';
    }
  }

  // ✅ Helper to truncate address to 100 characters max
  String _truncateAddress(String address) {
    if (address.length <= 100) return address;
    return '${address.substring(0, 97)}...';
  }

  // =========================
  // ✅ OSM Map Picker (No API Key)
  // =========================
  Future<LatLng?> _pickLocationFromOsmMap(BuildContext context) async {
    // fallback
    LatLng initial = const LatLng(31.2653, 32.3019); // Port Said

    try {
      // حاول تجيب اللوكيشن بسرعة (لو اتأخر سيبها fallback)
      final pos = await getCurrentPositionSafely()
          .timeout(const Duration(seconds: 6));

      if (pos != null) {
        initial = LatLng(pos.latitude, pos.longitude);
      }
    } catch (_) {
      // ignore -> fallback
    }

    return await Navigator.push<LatLng?>(
      context,
      MaterialPageRoute(
        builder: (_) => OsmPickLocationScreen(initial: initial),
      ),
    );
  }

  // =========================
  // API Call
  // =========================
  Future<bool> handleAddNewAddress({
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
    // Use shared AddressController from DI container
    final controller = sl<AddressController>();
    
    log(' handleAddNewAddress called with:');
    log(' title: "$title"');
    log(' address: "$address"');
    log(' useGps: $useGps');
    log(' latitude: $latitude');
    log(' longitude: $longitude');

    final request = AddAddressRequest(
      title: title.trim(),
      address: address.trim(),
      areaId: 1,
      latitude: useGps ? (latitude ?? 0) : 0,
      longitude: useGps ? (longitude ?? 0) : 0,
      streetNum: useGps ? null : int.tryParse(street),
      buildingNum: useGps ? null : int.tryParse(building),
      doorNumber: useGps ? null : int.tryParse(flat),
      floorNum: null,
      notes: null,
    );
    
    log(' AddAddressRequest created: $request');

    try {
      final success = await controller.addNewAddress(
        request,
        refreshAfter: true,
      );
      log(' Server response: $success');
      return success;
    } catch (e) {
      log(' Error adding address: $e');
      return false;
    }
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

                  // ✅ Title (always)
                  buildCustomeFullTextField(
                    'Title',
                    'Enter Title',
                    _addressNameController,
                    false,
                    screenHeight,
                    fromEditProfile: true,
                  ),

                  // ✅ Manual fields only (hide in GPS + Map modes)
                  (_isGpsMode || _isMapMode)
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
                        'Enter Flat Number',//k
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

                      // ✅ Skip form validation for GPS mode (fields are hidden)
                      if (_isManualMode && !(_formKey.currentState?.validate() ?? false)) return;

                      setState(() => _isSubmitting = true);

                      try {
                        // =========================
                        // ✅ 1) GPS flow
                        // =========================
                        if (_isGpsMode) {
                          log('🔥 GPS Mode Started');
                          final pos = await getCurrentPositionSafely();
                          log('🔥 GPS Position: $pos');
                          
                          if (pos == null) {
                            log('🔥 GPS Position is null - returning');
                            setState(() => _isSubmitting = false);
                            return;
                          }

                          log('🔥 Getting address from coordinates');
                          final resolvedAddress = await getAddressFromLatLng(
                            pos.latitude,
                            pos.longitude,
                          );
                          log('🔥 Resolved Address: $resolvedAddress');
                          //j
                          // ✅ Truncate address to 100 characters max
                          final truncatedAddress = _truncateAddress(resolvedAddress);
                          log('🔥 Truncated Address: "$truncatedAddress"');

                          log('🔥 Adding address to server');
                          final ok = await handleAddNewAddress(
                            title: _addressNameController.text,
                            address: truncatedAddress,
                            zone: '',
                            street: '',
                            building: '',
                            flat: '',
                            useGps: true,
                            latitude: pos.latitude,
                            longitude: pos.longitude,
                          );
                          log('🔥 Address added successfully: $ok');

                          if (ok) Navigator.pop(context, true);
                          return;
                        }

                        // =========================
                        // ✅ 2) MAP PICKER flow (OSM)
                        // =========================
                        if (_isMapMode) {
                          // 1) validate title فقط (الفورم بتاعك جاهز)
                          if (!(_formKey.currentState?.validate() ?? false)) return;

                          // 2) افتح الماب بعد ما التايتل يبقى موجود
                          final picked = await _pickLocationFromOsmMap(context);

                          // 3) لو المستخدم قفل الماب من غير اختيار -> مفيش إضافة
                          if (picked == null) return;

                          // 4) reverse geocoding
                          final resolvedAddress = await getAddressFromLatLng(
                            picked.latitude,
                            picked.longitude,
                          );
                          log('🔥 Map Picker Resolved Address: $resolvedAddress');
                          
                          // Truncate address to 100 characters max
                          final truncatedAddress = _truncateAddress(resolvedAddress);
                          log('🔥 Map Picker Truncated Address: "$truncatedAddress"');

                          // 5) add address بالـ lat/lng المختارين
                          final ok = await handleAddNewAddress(
                            title: _addressNameController.text,
                            address: truncatedAddress,
                            zone: '',
                            street: '',
                            building: '',
                            flat: '',
                            useGps: true,
                            latitude: picked.latitude,
                            longitude: picked.longitude,
                          );

                          if (ok) Navigator.pop(context, true);
                          return;
                        }


                        // =========================
                        // ✅ 3) Manual flow
                        // =========================
                        final ok = await handleAddNewAddress(
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