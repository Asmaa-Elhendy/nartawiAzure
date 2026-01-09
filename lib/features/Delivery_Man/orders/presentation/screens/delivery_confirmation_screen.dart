import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:dio/dio.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../home/presentation/widgets/background_home_Appbar.dart';
import '../../../../home/presentation/widgets/build_ForegroundAppBarHome.dart';
import '../widgets/custome_button.dart';
import '../widgets/mark_delivered_alert.dart';
import '../../../../orders/data/datasources/order_confirmation_datasource.dart';
import '../../../../../core/services/auth_service.dart';


class DeliveryConfirmationScreen extends StatefulWidget {
  final bool fromDeliveryMan;

  // Replace with your real data later
  final int orderId;
  final DateTime orderDate;
  final String address;

  const DeliveryConfirmationScreen({
    super.key,
    this.fromDeliveryMan = true,
    required this.orderId,
    required this.orderDate,
    required this.address,
  });

  @override
  State<DeliveryConfirmationScreen> createState() =>
      _DeliveryConfirmationScreenState();
}

class _DeliveryConfirmationScreenState extends State<DeliveryConfirmationScreen> {
  final TextEditingController _commentCtrl = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  late OrderConfirmationDatasource _podDatasource;
  
  Position? _currentPosition;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _podDatasource = OrderConfirmationDatasource(dio: Dio());
  }

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  String formatDateOnly(DateTime d) => DateFormat('MMM d, y').format(d);

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get location: $e')),
      );
    }
  }

  Future<void> _capturePhotoAndSubmit() async {
    await _getCurrentLocation();

    if (_currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enable location services')),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => GpsRequiredAlert(
        onOpenCamera: () async {
          Navigator.pop(context);
          await _openCameraAndSubmit();
        },
        onCancel: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Future<void> _openCameraAndSubmit() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (photo != null && _currentPosition != null) {
        await _submitPOD(photo);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to capture photo: $e')),
      );
    }
  }

  Future<void> _submitPOD(XFile photo) async {
    setState(() => _isSubmitting = true);

    try {
      final bytes = await photo.readAsBytes();
      final base64Photo = base64Encode(bytes);

      await _podDatasource.submitPOD(
        orderId: widget.orderId,
        photoBase64: base64Photo,
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude,
        notes: _commentCtrl.text.trim().isEmpty ? null : _commentCtrl.text.trim(),
      );

      setState(() => _isSubmitting = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Delivery confirmed successfully'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      setState(() => _isSubmitting = false);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit POD: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            width: screenWidth,
            height: screenHeight,
            color: AppColors.backgrounHome,
          ),
          buildBackgroundAppbar(screenWidth),
          BuildForegroundappbarhome(
            fromDeliveryMan: widget.fromDeliveryMan,
            screenHeight: screenHeight,
            screenWidth: screenWidth,
            title: 'Delivery Confirmation',
            is_returned: true,
          ),
          Positioned.fill(
            top: MediaQuery.of(context).padding.top + screenHeight * .1,
            bottom: screenHeight * .05,
            child: Padding(
              padding: EdgeInsets.only(
                top: screenHeight * .02,
                bottom: screenHeight * .02,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * .06),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title like screenshot
                      Padding(
                        padding: EdgeInsets.only(bottom: screenHeight * .015),
                        child: Text(
                          'Delivery Confirmation',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: screenWidth * .045,
                          ),
                        ),
                      ),

                      // White card container
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * .05,
                          vertical: screenHeight * .02,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Order#3
                            Text(
                              'Order#${widget.orderId}',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: screenWidth * .042,
                              ),
                            ),

                            SizedBox(height: screenHeight * .012),

                            // Date row
                            Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/images/orders/calendar.svg",
                                  width: screenWidth * .042,
                                  color: AppColors.textLight,
                                ),
                                SizedBox(width: screenWidth * .02),
                                Expanded(
                                  child: Text(
                                    formatDateOnly(widget.orderDate),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: screenWidth * .034,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: screenHeight * .01),

                            // Address row
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: screenWidth * .05,
                                  color: AppColors.textLight,
                                ),
                                SizedBox(width: screenWidth * .02),
                                Expanded(
                                  child: Text(
                                    widget.address,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: screenWidth * .034,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: screenHeight * .03),

                            // Big check + small avatar bubble
                            Center(
                              child: SizedBox(
                                width: screenWidth * .36,
                                height: screenWidth * .36,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: screenWidth * .28,
                                      height: screenWidth * .28,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.check_rounded,
                                        size: screenWidth * .16,
                                        color: AppColors.whiteColor,
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),

                            Center(
                              child: Text(
                                'Confirm Delivery',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: screenWidth * .038,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),

                            SizedBox(height: screenHeight * .02),

                            Text(
                              'Write Comment Here',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: screenWidth * .034,
                                color: AppColors.textLight,
                              ),
                            ),

                            SizedBox(height: screenHeight * .012),

                            // Comment field (with small avatar to right)
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * .03,
                                    vertical: screenHeight * .004,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.favouriteProductCard,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppColors.BorderAnddividerAndIconColor,
                                    ),
                                  ),
                                  child:TextField(
                                    controller: _commentCtrl,
                                    maxLines: 4, // ✅ يكبر مساحة الـ textarea
                                    minLines: 3, // (اختياري) أقل ارتفاع
                                    style: TextStyle(
                                      fontSize: screenWidth * .032, // ✅ خط أصغر شوية
                                      fontWeight: FontWeight.w400,
                                    ),
                                    decoration: TextFieldDecoration(
                                      hintText: 'Write A Comment Here If Applicable',
                                    ),
                                  ),

                                ),

                              ],
                            ),

                            SizedBox(height: screenHeight * .03),

                            Row(
                              children: [
                                Expanded(
                                  child: CustomContainerButton(
                                    icon: "assets/images/delivery_man/orders/package-delivered.svg",
                                    title: "Mark As Delivered",
                                    screenWidth: screenWidth,
                                    screenHeight: screenHeight,
                                    isRed: false,
                                    onTap: _isSubmitting ? null : _capturePhotoAndSubmit,
                                  ),
                                ),
                                SizedBox(width: screenWidth * .03),
                                Expanded(
                                  child: CustomContainerButton(
                                    icon: "",
                                    title: "Mark As Canceled",
                                    screenWidth: screenWidth,
                                    screenHeight: screenHeight,
                                    isRed: true,
                                    onTap: () {
                                      // TODO
                                    },
                                  ),
                                ),
                              ],
                            ),



                          ],
                        ),
                      ),

                      SizedBox(height: screenHeight * .12), // space (bottom nav)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Keeps your TextField look clean (no design change)
InputDecoration TextFieldDecoration({required String hintText}) {
  return InputDecoration(
    border: InputBorder.none,
    hintText: hintText,
    hintStyle: const TextStyle(color: Colors.grey),
  );
}

