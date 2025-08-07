import 'package:flutter/material.dart';

import '../../../../../core/theme/colors.dart';

class CustomCheckboxExample extends StatefulWidget {
  double width;
  double height;
  CustomCheckboxExample( this.width, this.height);

  State<CustomCheckboxExample> createState() => _CustomCheckboxExampleState();
}

class _CustomCheckboxExampleState extends State<CustomCheckboxExample> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: widget.width*.1, // الحجم العرض
      height: widget.height*.045, // الحجم الارتفاع
      child: Center(
        child: Checkbox(
              value: isChecked,
              onChanged: (bool? value) {
                setState(() {
                  isChecked = value ?? false;
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),fillColor:  MaterialStateProperty.all(AppColors.whiteColor),
              activeColor: Colors.white, // لون الخلفية لما يكون مختار
              checkColor: AppColors.primary, // لون علامة الصح
              side: const BorderSide(
                color: AppColors.primary, // لون البوردر
                width: 1,
              ),
            ),
      ),
    );
  }
}