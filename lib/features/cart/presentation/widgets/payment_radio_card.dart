import 'package:flutter/material.dart';
import 'singlePaymentCard.dart';

class RadioPaymentCard extends StatefulWidget {
  const RadioPaymentCard({super.key});

  @override
  State<RadioPaymentCard> createState() => _RadioPaymentCardState();
}

class _RadioPaymentCardState extends State<RadioPaymentCard> {
  int? _groupValue; // null = unselected

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(

      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: screenHeight * .01),
          child: SinglePaymentCard(
            value: 1,
            groupValue: _groupValue ?? 0,
            // 👈 pass the current group value
            onChanged: (val) {
              setState(() {
                _groupValue = val;
              });
            },
            mainTitle: 'Use eWallet Balance First',
            firstText: 'Available Balance: QAR 840.00',
            secondText: 'Your eWallet Will Cover The Full Amount (QAR 500.00)',
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: screenHeight * .01),
          child: SinglePaymentCard(
            value: 2,
            groupValue: _groupValue ?? 0,
            // 👈 pass the current group value
            onChanged: (val) {
              setState(() {
                _groupValue = val;
              });
            },
            mainTitle: 'I confirm my order and agree to pay with my eWallet upon delivery',
            firstText: 'Please have QAR 500.00 ready when your order arrives.',
            secondText: '',
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: screenHeight * .01),
          child: SinglePaymentCard(
            value: 3,
            groupValue: _groupValue ?? 0,
            // 👈 pass the current group value
            onChanged: (val) {
              setState(() {
                _groupValue = val;
              });
            },
            mainTitle: 'Cash on delivery',
            firstText: 'Please have QAR 500.00 ready when your order arrives.',
            secondText: '',
          ),
        ),
      ],
    );
  }
}
