import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import '../../../../core/services/dio_service.dart';
import '../../../../../l10n/app_localizations.dart';
import 'package:newwwwwwww/features/Delivery_Man/orders/presentation/widgets/custome_button.dart';
import 'package:newwwwwwww/features/Delivery_Man/orders/presentation/widgets/customer_card_information.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/suppliers/build_info_button.dart';
import 'package:newwwwwwww/features/orders/domain/models/order_model.dart';
import 'package:newwwwwwww/features/orders/presentation/widgets/delivery_information_report.dart';
import 'package:newwwwwwww/features/orders/presentation/widgets/order_summary_card.dart';
import 'package:newwwwwwww/features/orders/presentation/widgets/payment_information_report.dart';
import 'package:newwwwwwww/features/orders/presentation/widgets/reason_for_cancelation.dart';
import 'package:newwwwwwww/features/orders/presentation/widgets/seller_information_widget.dart';
import '../../../../core/theme/colors.dart';
import '../../../Delivery_Man/orders/presentation/screens/track_order.dart';
import '../../../auth/presentation/bloc/login_bloc.dart';
import '../../../home/presentation/widgets/background_home_Appbar.dart';
import '../../../home/presentation/widgets/build_ForegroundAppBarHome.dart';
import '../widgets/order_card.dart';
import '../widgets/order_status_widget.dart';
import '../widgets/payement_status_widget.dart';
import '../widgets/review_alert_dialog.dart';
import '../widgets/pod_display_modal.dart';
import '../widgets/dispute_submission_modal.dart';
import '../widgets/dispute_status_modal.dart';
import '../provider/dispute_controller.dart';
import '../../data/datasources/dispute_datasource.dart';
import '../../../../core/services/auth_service.dart';

String formatOrderDate(DateTime? date) {
  if (date == null) return '';

  final datePart = DateFormat('MMMM d, y').format(date);
  final timePart = DateFormat('hh:mm a').format(date);

  return '$datePart at $timePart';
}

class OrderDetailScreen extends StatefulWidget {
  String orderStatus;
  String paymentStatus;
  ClientOrder clientOrder;
  bool fromDeliveryMan;

  OrderDetailScreen({
    required this.orderStatus,//k
    required this.paymentStatus,
    required this.clientOrder,
    this.fromDeliveryMan = false,
  });

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late DisputeController _disputeController;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    _disputeController = DisputeController(
      datasource: DisputeDatasource(dio: DioService.dio,baseUrl: base_url),
    );

    if (widget.clientOrder.dispute == null && !widget.fromDeliveryMan) {
      _disputeController.fetchDisputeByOrderId(widget.clientOrder.id!);
    }

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _disputeController.dispose();
    super.dispose();
  }

  String? imageUrl = null;

  void _showPODModal() {
    if (widget.clientOrder.orderConfirmation != null) {
      showDialog(
        context: context,
        builder: (_) => PODDisplayModal(
          pod: widget.clientOrder.orderConfirmation!,
          onDispute: _showDisputeModal,
        ),
      );
    }
  }

  void _showDisputeModal() {
    showDialog(
      context: context,
      builder: (_) => ChangeNotifierProvider.value(
        value: _disputeController,
        child: DisputeSubmissionModal(
          orderId: widget.clientOrder.id!,
        ),
      ),
    ).then((result) {
      if (result == true) {
        setState(() {});
      }
    });
  }

  void _showDisputeStatus() {
    final dispute = widget.clientOrder.dispute ?? _disputeController.currentDispute;
    if (dispute != null) {
      showDialog(
        context: context,
        builder: (_) => DisputeStatusModal(dispute: dispute),
      );
    }
  }

  int _getSupplierId(ClientOrder order) {
    if (order.vendors is List && (order.vendors as List).isNotEmpty) {
      final vendor = (order.vendors as List).first;
      if (vendor is Map<String, dynamic>) {
        return vendor['supplierId'] ?? vendor['id'] ?? 0;
      }
    }
    return 0;
  }

  String _getSupplierName(ClientOrder order) {
    if (order.vendors is List && (order.vendors as List).isNotEmpty) {
      final vendor = (order.vendors as List).first;
      if (vendor is Map<String, dynamic>) {
        return vendor['supplierName'] ?? vendor['name'] ?? 'Unknown Supplier';
      }
    }
    return 'Unknown Supplier';
  }

  void _showCancelConfirmation() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.cancelOrder),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.cancelOrderConfirmation),
            SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.paymentRefundMessage,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppLocalizations.of(context)!.noKeepOrder),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _cancelOrder();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(AppLocalizations.of(context)!.yesCancel, style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _handleStartDelivery() async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.startDelivery),
        content: Text(
          '${AppLocalizations.of(context)!.startDeliveryConfirmation}${widget.clientOrder.id}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: Text(AppLocalizations.of(context)!.start, style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      // // Show loading
      // showDialog(
      //   context: context,
      //   barrierDismissible: false,
      //   builder: (_) => Center(child: CircularProgressIndicator(color: AppColors.primary)),
      // );

      final dio = DioService.dio;
      final token = await AuthService.getToken();

      // Call new BE v1.0.21 Start Delivery endpoint
      final response = await dio.post(
        '$base_url/v1/delivery/orders/${widget.clientOrder.id}/start',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      //
      // // Close loading
      // Navigator.pop(context);

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Success - update UI
        setState(() {
          widget.orderStatus = 'In Progress';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.deliveryStartedSuccessfully),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {

      }
    } catch (e) {
      // Close loading if still open
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      } else {
        // Force close loading dialog if it can't be popped normally
        Navigator.of(context, rootNavigator: false).pop();
      }

      // Show specific error message for status validation
      String errorMessage = e.toString();
      String userMessage;
      
      // Debug logging to understand exact error format
      log('🔍 Delivery start error: $errorMessage');
      log('🔍 Delivery start error: $errorMessage');
      
      // Check for various possible error message formats
      if (errorMessage.contains('Order must be in \'Confirmed\' status') || 
          errorMessage.contains('Order must be in "Confirmed" status') ||
          errorMessage.contains('Order must be in \'Confirmed\' status to start delivery') ||
          errorMessage.contains('Order must be in "Confirmed" status to start delivery')) {
        userMessage = AppLocalizations.of(context)!.orderMustBeConfirmedToStart;
        log('✅ Using confirmed status error message');
      } else if (errorMessage.contains('Order must be assigned to this driver')) {
        userMessage = AppLocalizations.of(context)!.orderNotAssignedToYou;
        log('✅ Using driver assignment error message');
      } else if (errorMessage.contains('DioException') && errorMessage.contains('status code of 400')) {
        // Handle DioException with 400 status code specifically
        userMessage = AppLocalizations.of(context)!.orderMustBeConfirmedToStart;
        log('✅ Using DioException 400 handling for confirmed status');
      } else if (errorMessage.contains('DioException [bad response]') && errorMessage.contains('status code of 400')) {
        // Handle DioException [bad response] with 400 status code specifically
        userMessage = AppLocalizations.of(context)!.orderMustBeConfirmedToStart;
        log('✅ Using DioException [bad response] 400 handling for confirmed status');
      } else {
        userMessage = '${AppLocalizations.of(context)!.failedToStartDelivery}$e';
        log('⚠️ Using generic error message $userMessage');
      }

      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(userMessage),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,

        ),
      );
    }
  }

  Future<void> _cancelOrder() async {
    try {
      final dio = DioService.dio;
      final token = await AuthService.getToken();

      final response = await dio.post(
        '$base_url/v1/client/orders/${widget.clientOrder.id}/cancel',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.orderCancelledSuccessfully),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,

          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${AppLocalizations.of(context)!.failedToCancelOrder}$e'),behavior: SnackBarBehavior.floating,
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
      // 🔥 يخلي الجسم يبدأ من أعلى الشاشة خلف الـ AppBar
      backgroundColor: Colors.transparent,
      // في حالة الصورة في الخلفية
      body: Stack(
        children: [
          Container(
            width: screenWidth,
            height: screenHeight,
            color: AppColors.backgrounHome,
          ),
          buildBackgroundAppbar(screenWidth),
          BuildForegroundappbarhome(fromDeliveryMan: widget.fromDeliveryMan,
            screenHeight: screenHeight,
            screenWidth: screenWidth,
            title: AppLocalizations.of(context)!.orderDetails,
            is_returned: true,
          ),
          Positioned.fill(
            top: MediaQuery.of(context).padding.top + screenHeight * .1,
            bottom: screenHeight * .05,
            child: Padding(
              padding: EdgeInsets.only(
                top: screenHeight * .03, //04 handle design shimaa
                bottom: screenHeight * .1,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * .06,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,

                                  children: [
                                    Text(
                                      '${AppLocalizations.of(context)!.order} #${widget.clientOrder.id ?? 0}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: screenWidth * .045,
                                      ),
                                    ),
                                    BuildOrderStatus(
                                      screenHeight,
                                      screenWidth,
                                      widget.orderStatus,
                                      fromOrderDetail: false,
                                    ),
                                  ],
                                ),
                                SizedBox(height: screenHeight * .01),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/images/orders/calendar.svg",
                                      width: screenWidth * .042,
                                      color: AppColors.textLight,
                                    ),
                                    SizedBox(width: screenWidth * .02),

                                    // ✅ التاريخ ياخد المساحة المتاحة فقط
                                    Expanded(
                                      child: Text(
                                        formatOrderDate(
                                          widget.clientOrder.issueTime,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: screenWidth * .034,
                                        ),
                                      ),
                                    ),

                                    if (widget.fromDeliveryMan) ...[
                                      // SizedBox(width: screenWidth * .02),
                                      BuildPaymentStatus(
                                        screenWidth,
                                        screenHeight,
                                        widget.paymentStatus,
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * .01), //k
                            widget.fromDeliveryMan
                                ? CustomerCardInformation(
                                    screenWidth,
                                    screenHeight,
                                    widget.clientOrder,
                                  )
                                : SizedBox(),
                            OrderSummaryCard(context,
                              screenWidth,
                              screenHeight,
                              widget.clientOrder,
                              fromDeliveryMan: widget.fromDeliveryMan,
                            ),
                            widget.fromDeliveryMan
                                ? widget.orderStatus == 'Pending' ||
                                          widget.orderStatus == 'In Progress'
                                      ? Padding(
                                        padding:  EdgeInsets.symmetric(vertical: screenHeight*.02),
                                        child: GestureDetector(
                                          onTap: () async {
                                            if (widget.orderStatus == 'Pending') {
                                              // Start Delivery - change status to In Progress
                                              await _handleStartDelivery();
                                            } else {
                                              // Mark As Delivered - navigate to POD screen
Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => TrackOrderScreen(order: widget.clientOrder),
                                                ),
                                              );
                                            }
                                          },
                                          child: CustomGradientButton(
                                            widget.orderStatus ==
                                                 'In Progress'?
                                            'assets/images/delivery_man/orders/package-delivered.svg': 'assets/images/delivery_man/orders/delivery-tracking.svg',
                                              screenWidth * .015,
                                              widget.orderStatus == 'Pending'
                                                  ? 'Start Delivery'
                                                  : 'Mark As Delivered',
                                              screenWidth,
                                              screenHeight,
                                            ),
                                        ),
                                      )
                                      : SizedBox()
                                : SizedBox(),
                            widget.fromDeliveryMan
                                ? SizedBox()
                                : Column(
                                    children: [
                                      OrderDeliveryCard(
                                        screenWidth,
                                        screenHeight,
                                        widget.clientOrder,context
                                      ),
                                      OrderPaymentCard(
                                        screenWidth,
                                        screenHeight,
                                        widget.paymentStatus,
                                        widget.clientOrder,
                                      ),
                                      OrderSellerInformationCard(
                                        screenWidth,
                                        screenHeight,
                                        widget.clientOrder,
                                      ),
                                      widget.orderStatus == 'Delivered'
                                          ? Column(
                                        children: [
                                          BuildInfoAndAddToCartButton(
                                            screenWidth,
                                            screenHeight,
                                            AppLocalizations.of(context)!.leaveReview,
                                            false,
                                                () {
                                              showDialog(
                                                context: context,
                                                builder: (ctx) => ReviewAlertDialog(
                                                  orderId: widget.clientOrder.id ?? 0,
                                                  supplierId: _getSupplierId(widget.clientOrder),
                                                  supplierName: _getSupplierName(widget.clientOrder),
                                                ),
                                              );
                                            },
                                            fromOrderDetail: true,
                                          ),

                                          if (widget.clientOrder.dispute != null ||
                                              _disputeController.currentDispute != null)
                                            Padding(
                                              padding: EdgeInsets.only(top: screenHeight * .01),
                                              child: BuildInfoAndAddToCartButton(
                                                screenWidth,
                                                screenHeight,
                                                AppLocalizations.of(context)!.viewDisputeStatus,
                                                false,
                                                _showDisputeStatus,
                                                fromOrderDetail: true,
                                              ),
                                            ),
                                        ],
                                      )
                                          : widget.orderStatus == 'Canceled'||widget.orderStatus == 'Cancelled'?
                                          ReasonForCancellationCard(
                                        screenWidth,
                                        screenHeight,
                                      )
                                          : SizedBox(),
                                      SizedBox(height: screenHeight * .04),
                                    ],
                                  ),
                          ],
                        ),
                      ),
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
