import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../coupons/presentation/widgets/custom_text.dart';

class SelectAllRow extends StatelessWidget {
  final bool isChecked;
  final ValueChanged<bool?> onChanged;
  final double screenWidth;
  final double screenHeight;

  const SelectAllRow({
    super.key,
    required this.isChecked,
    required this.onChanged,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * .1,
        vertical: screenHeight * .01,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: screenWidth * .05,
            height: screenHeight * .05,
            child: Transform.scale(
              scale: .9,
              child: Checkbox(
                value: isChecked,
                activeColor: AppColors.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                onChanged: onChanged,
              ),
            ),
          ),
          SizedBox(width: screenWidth * .03),
          customCouponAlertTitle(
            'Select All',
            screenWidth,
            screenHeight,
          ),
        ],
      ),
    );
  }
}

