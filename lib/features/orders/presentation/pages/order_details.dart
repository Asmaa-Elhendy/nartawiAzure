import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
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
    required this.orderStatus,
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
      datasource: DisputeDatasource(dio: Dio()),
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

  void _showCancelConfirmation() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Cancel Order?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to cancel this order?'),
            SizedBox(height: 12),
            Text(
              'Your payment will be refunded to your wallet.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('No, Keep Order'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _cancelOrder();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Yes, Cancel', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _cancelOrder() async {
    try {
      final dio = Dio();
      final token = await AuthService.getToken();
      
      final response = await dio.post(
        'https://nartawi.smartvillageqatar.com/api/v1/client/orders/${widget.clientOrder.id}/cancel',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Order cancelled successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to cancel order: $e'),
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
            title: 'Order Detail',
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
                                      'Order #${widget.clientOrder.id ?? 0}',
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
                            OrderSummaryCard(
                              screenWidth,
                              screenHeight,
                              widget.clientOrder,
                              fromDeliveryMan: widget.fromDeliveryMan,
                            ),
                            widget.fromDeliveryMan
                                ? widget.orderStatus == 'Pending' ||
                                          widget.orderStatus == 'On The Way'
                                      ? Padding(
                                        padding:  EdgeInsets.symmetric(vertical: screenHeight*.02),
                                        child: GestureDetector(
                                          onTap: (){
                                            Navigator.push(context, MaterialPageRoute(builder: (context)=>TrackOrderScreen()));
                                          },
                                          child: CustomGradientButton(
                                            widget.orderStatus ==
                                                 'On The Way'?
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
                                        widget.clientOrder,
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
                                                if (widget.clientOrder.orderConfirmation != null)
                                                  Padding(
                                                    padding: EdgeInsets.only(bottom: screenHeight * .01),
                                                    child: BuildInfoAndAddToCartButton(
                                                      screenWidth,
                                                      screenHeight,
                                                      'View Proof of Delivery',
                                                      false,
                                                      _showPODModal,
                                                      fromOrderDetail: true,
                                                    ),
                                                  ),
                                                BuildInfoAndAddToCartButton(
                                                  screenWidth,
                                                  screenHeight,
                                                  'Leave Review',
                                                  false,
                                                  () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (ctx) => ReviewAlertDialog(),
                                                    );
                                                  },
                                                  fromOrderDetail: true,
                                                ),
                                                if (widget.clientOrder.dispute != null || _disputeController.currentDispute != null)
                                                  Padding(
                                                    padding: EdgeInsets.only(top: screenHeight * .01),
                                                    child: BuildInfoAndAddToCartButton(
                                                      screenWidth,
                                                      screenHeight,
                                                      'View Dispute Status',
                                                      false,
                                                      _showDisputeStatus,
                                                      fromOrderDetail: true,
                                                    ),
                                                  ),
                                              ],
                                            )
                                          : widget.orderStatus == 'Canceled'
                                          ? ReasonForCancellationCard(
                                              screenWidth,
                                              screenHeight,
                                            )
                                          : (widget.orderStatus == 'Pending' || widget.orderStatus == 'Accepted')
                                          ? BuildInfoAndAddToCartButton(
                                              screenWidth,
                                              screenHeight,
                                              'Cancel Order',
                                              false,
                                              _showCancelConfirmation,
                                              fromOrderDetail: true,
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
