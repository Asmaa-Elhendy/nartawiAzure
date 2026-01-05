import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // لو بتستخدمي Provider
import '../../../../core/theme/colors.dart';
import '../provider/order_controller.dart';
import 'cancel_order_buttons.dart';
import 'custom_text_field_alert.dart';

class CancelAlertDialog extends StatefulWidget {
  final String orderId;
  const CancelAlertDialog({super.key, required this.orderId});

  @override
  State<CancelAlertDialog> createState() => _CancelAlertDialogState();
}

class _CancelAlertDialogState extends State<CancelAlertDialog> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _onCancelOrderPressed() async {
    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;

    final id = int.tryParse(widget.orderId);
    if (id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid order id'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final ctrl = context.read<OrdersController>();

    final success = await ctrl.cancelOrder(
      id: id,
      reason: _reasonController.text.trim(),
      refreshAfter: true,
    );

    setState(() => _isSubmitting = false);

    if (!mounted) return;

    if (success) {
      Navigator.pop(context); // close dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order canceled successfully'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ctrl.error ?? 'Order cannot be canceled'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      backgroundColor: AppColors.backgroundAlert,
      insetPadding: const EdgeInsets.all(16),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.94,
        height: MediaQuery.of(context).size.height * 0.5,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: screenHeight * .02,
            horizontal: screenWidth * .05,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey, // ✅ form here
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Cancel Order',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: screenWidth * .04,
                          color: AppColors.redColor,
                        ),
                      ),
                      IconButton(
                        onPressed: _isSubmitting ? null : () => Navigator.pop(context),
                        icon: Icon(
                          Icons.close,
                          size: screenWidth * .05,
                          color: AppColors.greyDarktextIntExtFieldAndIconsHome,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: screenHeight * .01),

                  Text(
                    'Are you sure you want to cancel order #${widget.orderId}? The amount will be refunded to your wallet.',
                    style: TextStyle(
                      fontSize: screenWidth * .036,
                      color: AppColors.greyDarktextIntExtFieldAndIconsHome,
                      fontWeight: FontWeight.w300,
                    ),
                  ),

                  SizedBox(height: screenHeight * .03),

                  Text(
                    'Reason For Cancellation',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: screenWidth * .04,
                    ),
                  ),

                  // ✅ required only here by validator
                  CustomTextFieldAlert(
                    'Please provide a reason for cancellation',
                    controller: _reasonController,
                    validator: (v) {
                      final text = (v ?? '').trim();
                      if (text.isEmpty) return 'Reason is required';
                      if (text.length < 5) return 'Please enter at least 5 characters';
                      return null;
                    },
                  ),

                  // buttons
                  CancelOrderWidget(
                    context,
                    screenWidth,
                    screenHeight,
                    'Keep Order',
                    _isSubmitting ? 'Canceling...' : 'Cancel Order',
                        () {
                      if (_isSubmitting) return;
                      Navigator.pop(context);
                    },
                        () async {
                      if (_isSubmitting) return;
                      await _onCancelOrderPressed();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
