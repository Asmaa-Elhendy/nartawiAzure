import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:newwwwwwww/features/auth/presentation/bloc/login_bloc.dart';
import 'package:newwwwwwww/features/orders/presentation/provider/order_controller.dart';
import 'package:newwwwwwww/core/services/dio_service.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../core/services/auth_service.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../home/presentation/widgets/background_home_Appbar.dart';
import '../../../../home/presentation/widgets/build_ForegroundAppBarHome.dart';
import '../../../../orders/data/datasources/order_confirmation_datasource.dart';
import '../../../../orders/domain/models/order_model.dart';
import '../widgets/custome_button.dart';
import '../widgets/mark_delivered_alert.dart';

class DeliveryConfirmationScreen extends StatefulWidget {
  final bool fromDeliveryMan;
  final ClientOrder order;

  const DeliveryConfirmationScreen({
    super.key,
    this.fromDeliveryMan = true,
    required this.order,
  });

  int get orderId => order.id ?? 0;
  DateTime get orderDate => order.issueTime ?? DateTime.now();

  String get address {
    final addr = order.deliveryAddress;
    if (addr == null) return 'No address provided';

    final building = addr is Map ? addr['building'] : addr.building;
    final address = addr is Map ? addr['address'] : addr.address;
    final floor = addr is Map ? addr['floor'] : addr.floor;
    final apartment = addr is Map ? addr['apartment'] : addr.apartment;
    final notes = addr is Map ? addr['notes'] : addr.notes;

    final parts = [
      building,
      address,
      floor,
      apartment,
      notes,
    ].where((part) => part != null && part.toString().isNotEmpty).toList();

    return parts.join(', ');
  }

  @override
  State<DeliveryConfirmationScreen> createState() =>
      _DeliveryConfirmationScreenState();
}

class _DeliveryConfirmationScreenState extends State<DeliveryConfirmationScreen> {
  final TextEditingController _commentCtrl = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  late final OrderConfirmationDatasource _podDatasource;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Position? _currentPosition;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _podDatasource =
        OrderConfirmationDatasource(dio: DioService.dio, baseUrl: base_url);
  }

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  String formatDateOnly(DateTime d) => DateFormat('MMM d, y HH:mm').format(d);

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
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${AppLocalizations.of(context)!.failedToGetLocation}: $e')),
      );
    }
  }

  Future<void> _capturePhotoAndSubmit() async {
    await _getCurrentLocation();

    if (_currentPosition == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.pleaseEnableLocationServices)),
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
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${AppLocalizations.of(context)!.failedCapturePhoto}: $e')),
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

      if (!mounted) return;

      setState(() => _isSubmitting = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.deliveryConfirmedSuccessfully),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;

      setState(() => _isSubmitting = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${AppLocalizations.of(context)!.failedToSubmitPOD}: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showCancelOrderDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          AppLocalizations.of(context)!.cancelOrder,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: MediaQuery.of(context).size.width * .036,
          ),
        ),
        content: Text(
          AppLocalizations.of(context)!.cancelOrderConfirmation,
          style: TextStyle(color: Colors.grey[600]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(AppLocalizations.of(context)!.no, style: TextStyle(color: AppColors.primary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext, true);
              _cancelOrder(_commentCtrl.text.trim());
            },
            style: TextButton.styleFrom(backgroundColor: Colors.red),
            child: Text(AppLocalizations.of(context)!.yes, style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _cancelOrder([String? cancellationReason]) async {
    final ctrl = context.read<OrdersController>();

    final success = await ctrl.cancelOrderAsDelivery(
      id: widget.orderId,
      reason: (cancellationReason == null || cancellationReason.trim().isEmpty)
          ? 'Cancelled by delivery driver'
          : cancellationReason.trim(),
      refreshAfter: true,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.orderCancelledSuccessfully),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ctrl.error ?? AppLocalizations.of(context)!.failedToCancelOrder),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,

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
            title: AppLocalizations.of(context)!.deliveryConfirmation,
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
                  child: Form(
                    key: _formKey, // ✅ now formKey is actually used
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: screenHeight * .015),
                          child: Text(
                            AppLocalizations.of(context)!.deliveryConfirmation,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: screenWidth * .045,
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * .04,
                            vertical: screenHeight * .02,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Order#${widget.orderId}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: screenWidth * .042,
                                ),
                              ),
                              SizedBox(height: screenHeight * .012),
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
                              Center(
                                child: SizedBox(
                                  width: screenWidth * .36,
                                  height: screenWidth * .36,
                                  child: Stack(
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
                                  AppLocalizations.of(context)!.confirmDelivery,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: screenWidth * .038,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              SizedBox(height: screenHeight * .02),
                              Text(
                                AppLocalizations.of(context)!.writeCommentHere,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: screenWidth * .034,
                                  color: AppColors.textLight,
                                ),
                              ),
                              SizedBox(height: screenHeight * .012),
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
                                child: TextFormField(
                                  controller: _commentCtrl,
                                  maxLines: 4,
                                  minLines: 3,
                                  style: TextStyle(
                                    fontSize: screenWidth * .032,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: AppLocalizations.of(context)!.writeCommentApplicable,
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(color: Colors.grey),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return AppLocalizations.of(context)!.writeCommentApplicable;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(height: screenHeight * .03),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomContainerButton(
                                      icon:
                                      "assets/images/delivery_man/orders/package-delivered.svg",
                                      title: AppLocalizations.of(context)!.confirmDelivery,
                                      screenWidth: screenWidth,
                                      screenHeight: screenHeight,
                                      isRed: false,
                                      onTap: _isSubmitting
                                          ? () {}
                                          : () {
                                        final ok = _formKey.currentState?.validate() ?? false;
                                        if (!ok) return;

                                        _capturePhotoAndSubmit();
                                      },
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * .02),
                                  Expanded(
                                    child: CustomContainerButton(
                                      icon: "",
                                      title: AppLocalizations.of(context)!.cancelOrder,
                                      screenWidth: screenWidth,
                                      screenHeight: screenHeight,
                                      isRed: true,
                                      onTap: _isSubmitting
                                          ? () {}
                                          : () {
                                        final ok = _formKey.currentState?.validate() ?? false;
                                        if (!ok) return;

                                        _showCancelOrderDialog();
                                      },                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: screenHeight * .12),
                      ],
                    ),
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