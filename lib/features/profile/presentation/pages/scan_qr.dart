import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/theme/colors.dart';

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  bool _hasPermission = false;
  bool _deniedForever = false;

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    var status = await Permission.camera.status;

    if (!status.isGranted) {
      status = await Permission.camera.request();
    }

    setState(() {
      _hasPermission = status.isGranted;
      _deniedForever = status.isPermanentlyDenied;
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Scan QR',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w400,
            fontSize: screenWidth * .044,
          ),
        ),
      ),
      body: _deniedForever
          ? Center(
        child: ElevatedButton(
          onPressed: () async {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text("Permission Required"),
                content: const Text(
                  "Camera permission is permanently denied.\n\n"
                      "Please go to App Settings → Permissions → Enable Camera.",
                ),
                actions: [
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(ctx);
                      await openAppSettings();
                    },
                    child: const Text("Open Settings"),
                  ),
                ],
              ),
            );
          },
          child: const Text("Open Settings"),
        ),
      )
          : MobileScanner(
        controller: MobileScannerController(),
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            debugPrint('Barcode found! ${barcode.rawValue}');
            Navigator.pop(context, barcode.rawValue);
            break;
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
