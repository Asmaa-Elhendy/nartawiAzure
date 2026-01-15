// =======================================
// File: build_custome_full_text_field.dart  (COMPLETED)
// =======================================
import 'package:flutter/material.dart';
import 'package:newwwwwwww/features/auth/presentation/widgets/signup_textfield.dart';

import '../../../../core/theme/text_styles.dart';

Widget buildCustomeFullTextField(
    String label,
    String hintText,
    TextEditingController controller,
    bool required,
    double height, {
      bool fromEditProfile = false,
      bool isNumberKeyboard = false,
      String countryCode = '+974',

      // ✅ NEW
      String? Function(String?)? validator,
      ValueChanged<String>? onChanged,
      GlobalKey<FormFieldState>? fieldKey,
    }) {
  return Padding(
    padding: EdgeInsets.only(top: height * .01),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.LabelInTextField),
            if (required) Image.asset("assets/images/auth/required.png"),
          ],
        ),
        SizedBox(height: height * .01),
        SignUpTextField(
          hintText: hintText,
          label: label,
          controller: controller,
          required: required,
          fromEditProfile: fromEditProfile,
          isNumberKeyboard: isNumberKeyboard,
          countryCode: countryCode,

          // ✅ pass down
          validator: validator,
          onChanged: onChanged,
          fieldKey: fieldKey,
        ),
      ],
    ),
  );
}
