import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';


import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final double size;
  final Color activeColor;
  final Color borderColor;

  const CustomCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.size = Checkbox.width, // 16.0 عندك في الكود
    this.activeColor = AppColors.primary,
    this.borderColor = AppColors.greyDarktextIntExtFieldAndIconsHome,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Theme(
      data: theme.copyWith(
        checkboxTheme: theme.checkboxTheme.copyWith(
          // 👈 علشان نلغي الـ padding حوالين الـ Checkbox
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: const VisualDensity(
            horizontal: -4,
            vertical: -4,
          ),
          // 👈 نفس الـ border behaviour بتاع الكود اللي فوق
          side: WidgetStateBorderSide.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return BorderSide(
                width: 2.0,
                color: borderColor.withOpacity(.5),
              );
            }
            if (states.contains(WidgetState.selected)) {
              return const BorderSide(width: 2.0, color: Colors.transparent);
            }
            return BorderSide(width: 2.0, color: borderColor);
          }),
          // fill color زي ما تحبي
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              if (states.contains(WidgetState.selected)) {
                return borderColor.withOpacity(.4);
              }
              return Colors.transparent;
            }
            if (states.contains(WidgetState.selected)) {
              return activeColor;
            }
            return Colors.transparent;
          }),
          checkColor: WidgetStateProperty.all<Color>(Colors.white),

          // 👈 أهم حاجة: نفس الـ rounded اللي في _CheckboxDefaultsM3
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(3.5)),
          ),
        ),
      ),
      child: SizedBox(
        width: size,
        height: size,
        child: Checkbox(
          value: value,
          onChanged: (bool? newValue) {
            if (newValue != null) {
              onChanged(newValue);
            }
          },
          // نأكد برضه من غير tap target زيادة
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: const VisualDensity(
            horizontal: -4,
            vertical: -4,
          ),
        ),
      ),
    );
  }
}

class CustomRowCheckBox extends StatelessWidget {
  final bool checkedValue;
  final double screenWidth;
  final double screenHeight;
  final ValueChanged<bool> onChanged;
  final String title;

  const CustomRowCheckBox({
    super.key,
    required this.checkedValue,
    required this.screenWidth,
    required this.screenHeight,
    required this.onChanged,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomCheckbox(
          value: checkedValue,
          onChanged: onChanged,
          size: screenWidth * 0.045, // أو سيبيها على default لو عايزة نفس 16px
        ),
        SizedBox(width: screenWidth * .02),
        Text(
          title,
          style: TextStyle(
            fontSize: screenWidth * .036,
            fontWeight: FontWeight.w500,
            color: const Color(0xff7B7B7B),
          ),
        ),
      ],
    );
  }
}
