import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';

class GeneralAlert extends StatelessWidget {
  final double width;
  final String? message;

  const GeneralAlert({
    Key? key,
    required this.width,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Not Allowed',
        style: TextStyle(
          fontSize: width * .036,
          fontWeight: FontWeight.w600,color: AppColors.redColor
        ),
      ),
      content: Text(
        message ?? 'This action is not allowed.',
        style: TextStyle(
          color: Colors.grey[600],
        ),
      ),
      actions: [
        TextButton( onPressed: () => Navigator.pop(context, false),
          child: Text('OK',style: TextStyle(color: AppColors.primary),), ),
      ],
    );
  }
}
