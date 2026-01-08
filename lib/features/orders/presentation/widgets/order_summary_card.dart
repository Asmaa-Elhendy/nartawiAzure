import 'package:flutter/material.dart';
import 'package:newwwwwwww/core/theme/text_styles.dart';
import 'package:newwwwwwww/features/orders/domain/models/order_model.dart';
import '../../../../core/theme/colors.dart';

Widget OrderSummaryCard(
    double screenWidth,
    double screenHeight,
    ClientOrder clientOrder, {
      bool fromDeliveryMan = false,
      bool fromCart = false,
    }) {
  // ===============================
  // Extract items
  // ===============================
  final List<Object> items = clientOrder.items ?? [];

  // ===============================
  // Normalize & group items
  // ===============================
  List<Map<String, dynamic>> normalizeAndGroupItems(List<Object> rawItems) {
    final Map<String, Map<String, dynamic>> grouped = {};

    for (final item in rawItems) {
      String name = 'Unknown Product';
      double price = 0.0;
      int quantity = 1;

      if (item is Map<String, dynamic>) {
        name = (item['name'] ??
            item['enName'] ??
            item['arName'] ??
            'Unknown Product')
            .toString();
        price = (item['price'] as num?)?.toDouble() ?? 0.0;
        quantity = (item['quantity'] as num?)?.toInt() ?? 1;
      } else {
        name = item.toString();
        price = 0.0;
        quantity = 1;
      }

      final key = '$name|$price';

      if (grouped.containsKey(key)) {
        grouped[key]!['quantity'] =
            (grouped[key]!['quantity'] as int) + quantity;
      } else {
        grouped[key] = {
          'name': name,
          'price': price,
          'quantity': quantity,
        };
      }
    }

    return grouped.values.toList();
  }

  final groupedItems = normalizeAndGroupItems(items);

  // ===============================
  // Calculations
  // ===============================
  final double itemsSubtotal = groupedItems.fold(
    0.0,
        (sum, item) =>
    sum +
        ((item['price'] as num).toDouble() *
            (item['quantity'] as int)),
  );

  final num? deliveryFee = clientOrder.deliveryCost;
  final double tax = 0.0; // 👈 عدليها بعدين لو VAT
  final double total = itemsSubtotal + deliveryFee! + tax;

  // ===============================
  // UI Helpers
  // ===============================
  Widget buildItemRow(
      String name, double price, int quantity) {
    final double subtotal = price * quantity;

    return Container(
      margin: EdgeInsets.only(bottom: screenHeight * .01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyles.textSummaryStyle),
                Text(
                  'QAR ${price.toStringAsFixed(2)}',
                  style: TextStyle(
                    color:
                    AppColors.greyDarktextIntExtFieldAndIconsHome,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$quantity × QAR ${price.toStringAsFixed(2)}',
                style: AppTextStyles.textSummaryStyle,
              ),
              Text(
                'Subtotal: QAR ${subtotal.toStringAsFixed(2)}',
                style: AppTextStyles.textSummaryStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===============================
  // UI
  // ===============================
  return Container(
    padding: EdgeInsets.symmetric(
      vertical: screenHeight * .02,
      horizontal: screenWidth * .03,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: AppColors.whiteColor,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            'Order Summary',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: screenWidth * .04,
              color: AppColors.primary,
            ),
          ),
        ),

        SizedBox(height: screenHeight * .02),

        // ===============================
        // Items List
        // ===============================
        if (!fromDeliveryMan) ...[
          if (groupedItems.isNotEmpty) ...[
            ...groupedItems.map((item) {
              return buildItemRow(
                item['name'],
                (item['price'] as num).toDouble(),
                item['quantity'],
              );
            }).toList(),
            Divider(color: AppColors.backgrounHome),
          ] else
            Center(
              child: Text(
                'No items found',
                style: TextStyle(
                  color:
                  AppColors.greyDarktextIntExtFieldAndIconsHome,
                  fontSize: 12,
                ),
              ),
            ),
        ],

        SizedBox(height: screenHeight * .02),

        // ===============================
        // Subtotal & Delivery
        // ===============================
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Items Subtotal',
                      style: AppTextStyles.textSummaryStyle),
                  SizedBox(height: 4),
                  Text(
                    'QAR ${itemsSubtotal.toStringAsFixed(2)}',
                    style: AppTextStyles.textSummaryStyle,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: screenHeight * .1,
              child: VerticalDivider(
                color: AppColors.backgrounHome,
                thickness: 1,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Delivery Fee',
                      style: AppTextStyles.textSummaryStyle),
                  SizedBox(height: 4),
                  Text(
                    'QAR ${deliveryFee.toStringAsFixed(2)}',
                    style: AppTextStyles.textSummaryStyle,
                  ),
                ],
              ),
            ),
          ],
        ),

        SizedBox(height: screenHeight * .02),

        // ===============================
        // Tax & Total
        // ===============================
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tax',
                      style: AppTextStyles.textSummaryStyle),
                  SizedBox(height: 4),
                  Text(
                    'QAR ${tax.toStringAsFixed(2)}',
                    style: AppTextStyles.textSummaryStyle,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: screenHeight * .1,
              child: VerticalDivider(
                color: AppColors.backgrounHome,
                thickness: 1,
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * .02,
                  horizontal: screenWidth * .03,
                ),
                decoration: BoxDecoration(
                  color: AppColors.backgrounHome,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total',
                        style: AppTextStyles.textSummaryStyle),
                    SizedBox(height: 4),
                    Text(
                      'QAR ${total.toStringAsFixed(2)}',
                      style: AppTextStyles.textSummaryStyle,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
