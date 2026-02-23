import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'package:newwwwwwww/features/orders/domain/models/order_model.dart';
import 'package:newwwwwwww/features/orders/presentation/widgets/cancel_alert_dialog.dart';
import 'package:newwwwwwww/features/orders/presentation/provider/order_controller.dart';
import 'package:newwwwwwww/features/orders/domain/models/create_order_req.dart';

import '../../../../core/theme/colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../pages/order_details.dart';
import '../../../../core/services/dio_service.dart';

/// Re-order function that reuses create order logic
Future<void> _reorderOrder(BuildContext context, ClientOrder order) async {
  // Show loading dialog
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(color: AppColors.primary,),
          SizedBox(width: 20),
          Text('Creating reorder...'),
        ],
      ),
    ),
  );

  try {
    final List<CreateOrderItemRequest> orderItems = [];

    if (order.items != null) {
      for (final item in order.items!) {
        int productId = 0;
        int quantity = 1;

        if (item is Map<String, dynamic>) {
          productId = (item['productId'] as int?) ?? 0;
          quantity = (item['quantity'] as int?) ?? 1;

          final product = item['product'];
          if (product is Map<String, dynamic>) {
            productId = (product['id'] as int?) ?? productId;
          }
        }

        if (productId > 0) {
          orderItems.add(
            CreateOrderItemRequest(
              productId: productId,
              quantity: quantity,
              notes: '',
            ),
          );
        }
      }
    }

    if (orderItems.isEmpty) {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop(); // Close loading dialog
      }
      return;
    }

    final int deliveryAddressId = order.deliveryAddress is Map
        ? ((order.deliveryAddress as Map)['id'] as int?) ?? 41
        : (order.deliveryAddress?.id ?? 41);

    final orderRequest = CreateOrderRequest(
      items: orderItems,
      deliveryAddressId: deliveryAddressId,
      couponId: 0,
      notes: 'Reorder from order #${order.id}',
      terminalId: 0,
    );

    debugPrint(' REORDER REQUEST => ${orderRequest.toJson()}');

    final orderController = OrdersController(dio: DioService.dio);
    await orderController.createOrder(request: orderRequest);

    // Only show results if context is still valid
    if (context.mounted) {
      // Close loading dialog safely
      try {
        Navigator.of(context, rootNavigator: true).pop();
      } catch (e) {
        debugPrint('Error closing dialog: $e');
      }
      
      if (orderController.error == null) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reorder created successfully!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        
        // Navigate to orders screen after a short delay
        Future.delayed(const Duration(milliseconds: 500), () {
          if (context.mounted) {
            Navigator.of(context).pushReplacementNamed('/orders');
          }
        });
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(orderController.error ?? 'Failed to create reorder'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  } catch (e) {
    debugPrint(' Reorder error: $e');
    
    // Close loading dialog and show error
    if (context.mounted) {
      try {
        Navigator.of(context, rootNavigator: true).pop(); // Close loading dialog
      } catch (e) {
        debugPrint('Error closing dialog: $e');
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to create reorder'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

Widget BuildOrderButtons(
  BuildContext context,
  double screenWidth,
  double screenHeight,
  String orderStatus,
  String paymentStatus,
  ClientOrder? clientOrder,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      /// ===================== View Details =====================
      Expanded(
        child: InkWell(
          onTap: () {
            if (clientOrder == null) return;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderDetailScreen(
                  orderStatus: orderStatus,
                  paymentStatus: paymentStatus,
                  clientOrder: clientOrder,
                ),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.only(right: screenWidth * .01),
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: screenHeight * .01,
                horizontal: orderStatus == 'Pending'
                    ? screenWidth * .006
                    : screenWidth * .015,
              ),
              height: screenHeight * .055,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/orders/hugeicons_view.svg',
                    color: AppColors.whiteColor,
                    width: screenWidth * .05,
                  ),
                  SizedBox(width: screenWidth * .01),
                  Flexible(
                    child: Text(
                      AppLocalizations.of(context)!.viewDetails,
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: screenWidth * .029,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      /// ===================== Re-order =====================
      Expanded(
        child: InkWell(
          onTap: () {
            if (clientOrder == null) return;
            _reorderOrder(context, clientOrder);
          },
          child: Padding(
            padding: EdgeInsetsGeometry.only(
              right: screenWidth * .01,
              left: orderStatus == 'Pending' ? 0 : screenWidth * .01,
            ),
            child: Container(
              padding: EdgeInsetsGeometry.symmetric(
                vertical: screenHeight * .01,
                horizontal: orderStatus == 'Pending'
                    ? screenWidth * .006
                    : screenWidth * .015,
              ),
              height: screenHeight * .055,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.blueBorder,
                  width: .7,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/orders/hugeicons_reload.svg',
                    color: AppColors.secondary,
                    width: screenWidth * .05,
                  ),
                  SizedBox(width: screenWidth * .01),
                  Flexible(
                    child: Text(
                      AppLocalizations.of(context)!.reOrder,
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontSize: screenWidth * .029,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      /// ===================== Cancel (Pending only) =====================
      orderStatus == 'Pending'
          ? Expanded(
              child: InkWell(
                onTap: () {
                  if (clientOrder == null) return;

                  showDialog<bool>(
                    context: context,
                    builder: (ctx) => CancelAlertDialog(
                      orderId: clientOrder.id.toString(),
                    ),
                  ).then((success) async {
                    if (success == true) {
                      // ✅ Refresh the SAME controller used in OrdersScreen (Provider)
                      final ctrl = context.read<OrdersController>();

                      // If you want refresh current list only:
                      await ctrl.fetchOrders(executeClear: true);

                      // If you want force pending tab filter specifically, do this instead:
                      // ctrl.setQuery(OrdersQuery(statusId: 1));
                      // await ctrl.fetchOrders(executeClear: true);
                    }
                  });
                },
                child: Padding(
                  padding: EdgeInsetsGeometry.only(right: screenWidth * .01),
                  child: Container(
                    padding: EdgeInsetsGeometry.symmetric(
                      vertical: screenHeight * .01,
                      horizontal: screenWidth * .015,
                    ),
                    height: screenHeight * .055,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.greyDarktextIntExtFieldAndIconsHome,
                        width: .5,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            AppLocalizations.of(context)!.cancel,
                            style: TextStyle(
                              color:
                                  AppColors.greyDarktextIntExtFieldAndIconsHome,
                              fontSize: screenWidth * .029,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : SizedBox(),
    ],
  );
}