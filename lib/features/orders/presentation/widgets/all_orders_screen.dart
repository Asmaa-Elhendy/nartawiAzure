import 'package:flutter/material.dart';
import 'package:newwwwwwww/features/orders/presentation/widgets/order_card.dart';

class AllOrdersScreen extends StatefulWidget {
  const AllOrdersScreen({super.key});

  @override
  State<AllOrdersScreen> createState() => _AllOrdersScreenState();
}

class _AllOrdersScreenState extends State<AllOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      child:ListView(
        children: [
          BuildOrderCard(context, screenHeight, screenWidth, 'Delivered','Paid'),
            BuildOrderCard(context, screenHeight, screenWidth, 'Pending','Pending Payment'),
          BuildOrderCard(context, screenHeight, screenWidth, 'Cancelled','Pending Payment'),
        ],),
    );
  }
}
