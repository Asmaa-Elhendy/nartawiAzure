import 'package:flutter/material.dart';
import 'singlePaymentCard.dart';

class RadioPaymentCard extends StatefulWidget {
  final Function(int)? onPaymentMethodSelected;
  
  const RadioPaymentCard({super.key, this.onPaymentMethodSelected});

  @override
  State<RadioPaymentCard> createState() => _RadioPaymentCardState();
}

class _RadioPaymentCardState extends State<RadioPaymentCard> {
  int? _groupValue; // null = unselected

  // Getter to access the selected payment method
  int? get selectedPaymentMethod => _groupValue;

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
              // Notify parent widget about the selection
              widget.onPaymentMethodSelected?.call(val ?? 0);
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
              // Notify parent widget about the selection
              widget.onPaymentMethodSelected?.call(val ?? 0);
            },
            mainTitle: 'Use Card',
            firstText: 'Please have QAR 500.00 ready when your order arrives.',
            secondText: '',
          ),
        ),
        // Padding(
        //   padding: EdgeInsets.symmetric(vertical: screenHeight * .01),
        //   child: SinglePaymentCard(
        //     value: 3,
        //     groupValue: _groupValue ?? 0,
        //     // 👈 pass the current group value
        //     onChanged: (val) {
        //       setState(() {
        //         _groupValue = val;
        //       });
        //     },
        //     mainTitle: 'Cash on delivery_man',
        //     firstText: 'Please have QAR 500.00 ready when your order arrives.',
        //     secondText: '',
        //   ),
        // ),
      ],
    );
  }
}
