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
 final List<dynamic> items = clientOrder.items != null 
    ? (clientOrder.items is List ? List.from(clientOrder.items!) : [clientOrder.items])
    : [];

  // ===============================
  // Normalize & group items
  // ===============================
  List<Map<String, dynamic>> normalizeAndGroupItems(List<dynamic> rawItems) {
    final Map<String, Map<String, dynamic>> grouped = {};

    for (final item in rawItems) {
      String name = 'Unknown Product';
      double price = 0.0;
      int quantity = 1;

      if (item is Map<String, dynamic>) {
        // Check for the new format first (from delivery man)
        if (item.containsKey('productName')) {
          name = item['productName']?.toString() ?? 'Unknown Product';
          price = (item['price'] as num?)?.toDouble() ?? 0.0;
          quantity = (item['quantity'] as num?)?.toInt() ?? 1;
        } 
        // Handle the old format
        else {
          name = (item['name'] ??
                  item['enName'] ??
                  item['arName'] ??
                  'Unknown Product')
              .toString();
          price = (item['price'] as num?)?.toDouble() ?? 0.0;
          quantity = (item['quantity'] as num?)?.toInt() ?? 1;
        }
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
  final double total = itemsSubtotal + (deliveryFee ?? 0.0) + tax;
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
    width: screenWidth,
    padding: EdgeInsets.symmetric(
      horizontal: screenWidth * .04,
      vertical: screenHeight * .02,
    ),
    decoration: BoxDecoration(
      color: AppColors.whiteColor,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: AppColors.shadowColor,
          offset: const Offset(0, 2),
          blurRadius: 8,
          spreadRadius: 0,
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order Summary',
          style: AppTextStyles.textSummaryStyle.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        
        // Display items list
        if (groupedItems.isNotEmpty) ...[

          const SizedBox(height: 8),
          ...groupedItems.map((item) {
            final price = (item['price'] as num).toDouble();
            final quantity = item['quantity'] as int;
            final subtotal = price * quantity;
            
            return Container(
              margin: EdgeInsets.only(bottom: screenHeight * .01),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['name'],
                              style: AppTextStyles.textSummaryStyle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),SizedBox(height: screenHeight*.01,),

                      Text(
                              'Item Description',
                              style: TextStyle(
                                color: AppColors.greyDarktextIntExtFieldAndIconsHome,
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
                            '$quantity * QAR ${price.toStringAsFixed(2)}',
                            style: AppTextStyles.textSummaryStyle,
                          ),SizedBox(height: screenHeight*.01,),
                          Text(
                            'Subtotal: ${subtotal.toStringAsFixed(2)}',
                            style: AppTextStyles.textSummaryStyle,
                          ),


                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight*.01,),
                  Divider(
                    //height: 12,
                    thickness: 1,
                    color: AppColors.backgrounHome,
                  ),
                ],
              ),
            );
          }).toList(),
        ] else ...[
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'No items found',
                style: TextStyle(
                  color: AppColors.greyDarktextIntExtFieldAndIconsHome,
                  fontSize: 12,
                ),
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
  'QAR ${(clientOrder.deliveryCost ?? 0).toStringAsFixed(2)}',
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
