// osm_pick_location_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../theme/colors.dart';

// ✅ Marker type to know which icon to show
enum MarkerType {
  myLocation,
  userLocation,
}

// =====================================================
// ✅ OSM Picker Screen (No API Key)
// =====================================================
class OsmPickLocationScreen extends StatefulWidget {
  final LatLng initial;
  final bool fromDeliveryMan;

  const OsmPickLocationScreen({
    super.key,
    required this.initial,
    this.fromDeliveryMan = false,
  });

  @override
  State<OsmPickLocationScreen> createState() => _OsmPickLocationScreenState();
}

class _OsmPickLocationScreenState extends State<OsmPickLocationScreen> {
  final MapController _mapController = MapController();

  LatLng? selected;
  MarkerType? markerType;

  bool _movingToMyLocation = false;

  Future<void> _goToMyLocation() async {
    if (_movingToMyLocation) return;

    setState(() => _movingToMyLocation = true);
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }
      if (permission == LocationPermission.deniedForever) {
        await Geolocator.openAppSettings();
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final me = LatLng(pos.latitude, pos.longitude);

      _mapController.move(me, 16);

      setState(() {
        selected = me;
        markerType = MarkerType.myLocation; // ✅ red marker
      });
    } finally {
      if (mounted) setState(() => _movingToMyLocation = false);
    }
  }

  Future<void> _goToUserLocation() async {
    if (_movingToMyLocation) return;

    setState(() => _movingToMyLocation = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }
      if (permission == LocationPermission.deniedForever) {
        await Geolocator.openAppSettings();
        return;
      }

      // ✅ Example user location (replace with real order/user latlng)
      final user = LatLng(31.2653, 32.3019);

      _mapController.move(user, 16);

      setState(() {
        selected = user;
        markerType = MarkerType.userLocation; // ✅ svg marker
      });
    } finally {
      if (mounted) setState(() => _movingToMyLocation = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: widget.fromDeliveryMan
          ? null // ✅ no AppBar = no reserved space
          : AppBar(title: const Text('Pick Location')),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: widget.initial,
              initialZoom: 16,
              onTap: (_, latLng) {
                // ✅ user manually picks: keep the SAME marker type if exists,
                // or default to myLocation (red)
                setState(() {
                  selected = latLng;
                  markerType ??= MarkerType.myLocation;
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.newwwwwwww',
              ),

              if (selected != null && markerType != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: selected!,
                      width: markerType == MarkerType.userLocation ? 80 : 40,
                      height: markerType == MarkerType.userLocation ? 80 : 40,
                      alignment: Alignment.bottomCenter,
                      child: markerType == MarkerType.userLocation
                          ? SvgPicture.asset(
                        'assets/images/delivery_man/orders/client_location.svg',
                        width: 70,
                        height: 70,  fit: BoxFit.contain,

                      )
                          : const Icon(
                        Icons.location_pin,
                        size: 30,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
            ],
          ),

          // ✅ My location button (red marker)
          Positioned(
            right: 16,
            bottom: widget.fromDeliveryMan ? height * .11 : 90,
            child: FloatingActionButton(
              backgroundColor: AppColors.backgrounHome,
              heroTag: 'my_location_btn',
              onPressed: _goToMyLocation,
              child: _movingToMyLocation
                  ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2,color: AppColors.primary),
              )
                  : const Icon(Icons.my_location, color: AppColors.primary),
            ),
          ),

          // ✅ User location button (svg marker) - delivery man only
          if (widget.fromDeliveryMan)
            Positioned(
              right: 16,
              bottom: height * .02,
              child: FloatingActionButton(
                backgroundColor: AppColors.backgrounHome,
                heroTag: 'user_location_btn',
                onPressed: _goToUserLocation,
                child: _movingToMyLocation
                    ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2,color: AppColors.primary),
                )
                    : const Icon(Icons.account_circle, color: AppColors.primary),
              ),
            ),

          // ✅ Use this location button (not for delivery man mode)
          if (!widget.fromDeliveryMan)
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.backgrounHome,
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: selected == null ? null : () => Navigator.pop(context, selected),
                child: const Text('Use This Location'),
              ),
            ),
        ],
      ),
    );
  }
}
