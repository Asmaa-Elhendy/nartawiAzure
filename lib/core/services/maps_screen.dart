import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../theme/colors.dart';
// =====================================================
// ✅ OSM Picker Screen (No API Key)
// =====================================================
class OsmPickLocationScreen extends StatefulWidget {
  final LatLng initial;
  bool fromDeliveryMan;
   OsmPickLocationScreen({required this.initial,this.fromDeliveryMan=false});

  @override
  State<OsmPickLocationScreen> createState() => _OsmPickLocationScreenState();
}

class _OsmPickLocationScreenState extends State<OsmPickLocationScreen> {
  final MapController _mapController = MapController();
  LatLng? selected;
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

      // move camera
      _mapController.move(me, 16);

      // optional: set marker to my location
      setState(() => selected = me);
    } finally {
      if (mounted) setState(() => _movingToMyLocation = false);
    }
  }

  Future<void> _goTouserLocation() async {
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


      final me = LatLng(31.2653, 32.3019);

      // move camera
      _mapController.move(me, 16);

      // optional: set marker to my location
      setState(() => selected = me);
    } finally {
      if (mounted) setState(() => _movingToMyLocation = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: widget.fromDeliveryMan
          ? null // ✅ مفيش AppBar → مفيش مساحة
          : AppBar(title: const Text('Pick Location')),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
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
                      child: const Icon(
                        Icons.location_pin,
                        size: 45,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
            ],
          ),

          // ✅ زرار موقعي الحالي
          Positioned(
            right: 16,
            bottom: height*.11, // فوق زر Use This Location
            child: FloatingActionButton(backgroundColor: AppColors.backgrounHome,
              heroTag: 'my_location_btn',
              onPressed: _goToMyLocation,
              child: _movingToMyLocation
                  ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : const Icon(Icons.my_location,color: AppColors.primary),
            ),
          ),
          widget.fromDeliveryMan  //user location
              ? Positioned(
            right: 16,
            bottom: height*.02, // فوق زر Use This Location
            child: FloatingActionButton(backgroundColor: AppColors.backgrounHome,
              heroTag: 'my_location_btn',
              onPressed: _goTouserLocation,
              child: _movingToMyLocation
                  ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : const Icon(Icons.account_circle,color: AppColors.primary),
            ),
          ):SizedBox(),
          widget.fromDeliveryMan
              ?SizedBox():      Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child:ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.backgrounHome, // ✅ لون الزرار
                foregroundColor: AppColors.primary,        // ✅ لون النص
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
