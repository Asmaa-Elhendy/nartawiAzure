import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../orders/domain/models/order_model.dart';
import '../../../../orders/presentation/widgets/order_image_network_widget.dart';

String _formatDeliveryAddress(dynamic addr) {
  if (addr == null) return 'No address provided';
  if (addr is String) return addr;
  if (addr is Map<String, dynamic>) {
    final area = addr['areaName'] ?? '';
    final street = addr['address'] ?? addr['streetNum'] ?? '';
    final building = addr['building'] ?? addr['buildingNum'] ?? '';
    final apartment = addr['apartment'] ?? addr['doorNumber'] ?? '';
    final floor = addr['floor'] ?? addr['floorNum'] ?? '';
    
    List<String> parts = [];
    if (area.isNotEmpty) parts.add(area);
    if (street.isNotEmpty) parts.add(street);
    if (building.isNotEmpty) parts.add('Building $building');
    if (floor.isNotEmpty) parts.add('Floor $floor');
    if (apartment.isNotEmpty) parts.add('Flat $apartment');
    
    return parts.isEmpty ? 'No address details' : parts.join(', ');
  }
  return addr.toString();
}

Widget CustomerCardInformation(
  double screenWidth,
  double screenHeight,
  ClientOrder clientOrder,
) {
  String imageUrl = '';

  return Container(
    margin: EdgeInsets.symmetric(vertical: screenHeight * .02),
    padding: EdgeInsets.symmetric(
      vertical: screenHeight * .02,
      horizontal: screenWidth * .03,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: AppColors.whiteColor,
      // boxShadow: [
      //   BoxShadow(
      //     color: AppColors.shadowColor,
      //     offset: Offset(0, 2),
      //     blurRadius: 8,
      //     spreadRadius: 0,
      //   ),
      // ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title
        Text(
          'Customer Information',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: screenWidth * .04,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: screenHeight * .02),

        // Item 1
        Padding(
          padding: EdgeInsets.symmetric(vertical: screenHeight * .01),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BuildNetworkOrderImage(
                screenWidth,
                screenHeight,
                imageUrl,
                'assets/images/orders/order.jpg',
                fromDelivery: true,
              ),

              SizedBox(width: screenWidth * .03),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    clientOrder.customerName ?? 'Unknown Customer',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: screenWidth * .037,
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(vertical: screenHeight * .01),
                    child: Text(
                      'One Time Purchase',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: screenWidth * .034,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: screenWidth * .1),
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/delivery_man/orders/whatsapp.svg',
                    width: screenWidth * .08,
                    // height: screenHeight*.1,
                  ),
                  SizedBox(width: screenWidth * .05),
                  SvgPicture.asset(
                    'assets/images/delivery_man/orders/maps-global-02.svg',
                    width: screenWidth * .08,
                    // height: screenHeight*.1,
                  ),
                ],
              ),
            ],
          ),
        ),
        Row(
          children: [
            SvgPicture.asset(
              'assets/images/delivery_man/location.svg',
              color: Colors.black,
              // height: screenHeight*.1,
            ),
            Text(
              _formatDeliveryAddress(clientOrder.deliveryAddress),
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: screenWidth * .034,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
