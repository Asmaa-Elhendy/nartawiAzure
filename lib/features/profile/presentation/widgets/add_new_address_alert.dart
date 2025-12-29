import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:newwwwwwww/features/orders/presentation/widgets/cancel_order_buttons.dart';
import 'package:geolocator/geolocator.dart';

// ✅ OSM (No API Key)
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/theme/colors.dart';
import '../../../auth/presentation/widgets/build_custome_full_text_field.dart';
import '../../../coupons/presentation/widgets/custom_text.dart';
import '../../domain/models/address_req.dart';
import '../provider/client_controller.dart';

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
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }

    if (permission == LocationPermission.deniedForever) {
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
      final en = await _reverseGeocode(latitude, longitude, locale: 'en');
      if (en.isNotEmpty) return en;

      final ar = await _reverseGeocode(latitude, longitude, locale: 'ar');
      if (ar.isNotEmpty) return ar;

      return 'Lat: $latitude, Lng: $longitude';
    } catch (_) {
      return 'Lat: $latitude, Lng: $longitude';
    }
  }

  // =========================
  // ✅ OSM Map Picker (No API Key)
  // =========================
  Future<LatLng?> _pickLocationFromOsmMap(BuildContext context) async {
    // Optional: start from GPS if available, else Port Said fallback
    LatLng initial = const LatLng(31.2653, 32.3019); // Port Said
    try {
      final pos = await getCurrentPositionSafely();
      if (pos != null) {
        initial = LatLng(pos.latitude, pos.longitude);
      }
    } catch (_) {}

    return await Navigator.push<LatLng?>(
      context,
      MaterialPageRoute(
        builder: (_) => _OsmPickLocationScreen(initial: initial),
      ),
    );
  }

  // =========================
  // ✅ API Call
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
    final controller = AddressController(dio: Dio());

    final success = await controller.addNewAddress(
      AddAddressRequest(
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
      ),
      refreshAfter: true,
    );

    return success;
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

                      // ✅ EXACTLY like your old file
                      if (!(_formKey.currentState?.validate() ?? false)) return;

                      setState(() => _isSubmitting = true);

                      try {
                        // =========================
                        // ✅ 1) GPS flow
                        // =========================
                        if (_isGpsMode) {
                          final pos = await getCurrentPositionSafely();
                          if (pos == null) return;

                          final resolvedAddress = await getAddressFromLatLng(
                            pos.latitude,
                            pos.longitude,
                          );

                          final ok = await handleAddNewAddress(
                            title: _addressNameController.text,
                            address: resolvedAddress,
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

                          // 5) add address بالـ lat/lng المختارين
                          final ok = await handleAddNewAddress(
                            title: _addressNameController.text,
                            address: resolvedAddress,
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

// =====================================================
// ✅ OSM Picker Screen (No API Key)
// =====================================================
class _OsmPickLocationScreen extends StatefulWidget {
  final LatLng initial;
  const _OsmPickLocationScreen({required this.initial});

  @override
  State<_OsmPickLocationScreen> createState() => _OsmPickLocationScreenState();
}

class _OsmPickLocationScreenState extends State<_OsmPickLocationScreen> {
  LatLng? selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pick Location')),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: widget.initial,
              initialZoom: 16,
              onTap: (_, latLng) => setState(() => selected = latLng),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.newwwwwwww',
              ),
              if (selected != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: selected!,
                      width: 45,
                      height: 45,
                      child: const Icon(Icons.location_pin, size: 45, color: Colors.red),
                    ),
                  ],
                ),
            ],
          ),

          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: ElevatedButton(
              onPressed: selected == null ? null : () => Navigator.pop(context, selected),
              child: const Text('Use This Location'),
            ),
          ),
        ],
      ),
    );
  }
}
