import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class PickLocationMapScreen extends StatefulWidget {
  const PickLocationMapScreen({super.key});

  @override
  State<PickLocationMapScreen> createState() => _PickLocationMapScreenState();
}

class _PickLocationMapScreenState extends State<PickLocationMapScreen> {
  GoogleMapController? _mapController;
  LatLng? _selected;

  Future<LatLng> _getInitialLatLng() async {
    // fallback لو GPS مش شغال
    const fallback = LatLng(30.0444, 31.2357); // Cairo
    try {
      final enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) return fallback;

      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied || perm == LocationPermission.deniedForever) {
        return fallback;
      }

      final pos = await Geolocator.getCurrentPosition();
      return LatLng(pos.latitude, pos.longitude);
    } catch (_) {
      return fallback;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LatLng>(
      future: _getInitialLatLng(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final initial = snap.data!;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Pick Location'),
          ),
          body: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: initial,
                  zoom: 16,
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                onMapCreated: (c) => _mapController = c,
                onTap: (latLng) {
                  setState(() => _selected = latLng);
                },
                markers: {
                  if (_selected != null)
                    Marker(
                      markerId: const MarkerId('selected'),
                      position: _selected!,
                    ),
                },
              ),

              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: ElevatedButton(
                  onPressed: _selected == null
                      ? null
                      : () {
                    Navigator.pop(context, _selected);
                  },
                  child: const Text('Use This Location'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
