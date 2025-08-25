import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import 'package:iconify_flutter/iconify_flutter.dart';


class SignUpTextField extends StatefulWidget {
  final String hintText;
  final String label;
  final bool fromEditProfile;

  final TextEditingController? controller;
  final bool required;

  const SignUpTextField({
    Key? key,
    required this.hintText,
    this.label = '',
    this.controller,
    required this.required,
    this.fromEditProfile=false
  }) : super(key: key);

  @override
  State<SignUpTextField> createState() => _SignUpTextFieldState();
}

class _SignUpTextFieldState extends State<SignUpTextField> {
  bool _obscureText = true;

  @override
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final isPasswordField = widget.label.toLowerCase().contains('password');
    final isPhoneField = widget.label.toLowerCase().contains('phone');

    if (isPhoneField) {
      // Phone field with country code and divider
      return Container(
        height: widget.fromEditProfile?height*.06: height * .07,
        decoration: BoxDecoration(
          color: AppColors.fillColorTextFilled,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.BorderAnddividerAndIconColor),
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            SizedBox(
              width: 50,
              child: TextFormField(
                initialValue: '+974',
                style: AppTextStyles.textInTextField,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  border: InputBorder.none,enabled: false,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 4),
                ),
              ),
            ),
            const SizedBox(width: 4),
            const VerticalDivider(
              thickness: 1,
              width: 1,
              color: AppColors.BorderAnddividerAndIconColor,
              indent: 10,
              endIndent: 10,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: widget.controller,
                keyboardType: TextInputType.phone,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                // validator: (value) {
                //   if(widget.required==true) {
                //     if (value == null || value.isEmpty) {
                //       return 'This field is required';
                //     }
                //
                //     return null;
                //   }
                //   return null;
                // },
                style: AppTextStyles.textInTextField,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: AppTextStyles.textInTextField,
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
      );
    }

    // Default text field (for password, email, etc.)
    return Container(
      height: widget.fromEditProfile?height*.06:height * .07,
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: widget.controller,
        obscureText: isPasswordField ? _obscureText : false,
        // validator: (value) {
        //   if (value == null || value.isEmpty) {
        //     return 'This field is required';
        //   }
        //   return null;
        // },
        cursorColor: AppColors.primary,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: AppTextStyles.textInTextField,
          prefixIcon: isPasswordField
              ? Padding(
            padding: EdgeInsets.only(left: width * .05, right: width * .02),
            child: const Iconify(
              MaterialSymbols.lock_outline,
              size: 18,
              color: AppColors.BorderAnddividerAndIconColor,
            ),
          )
              : null,
          suffixIcon: isPasswordField
              ? IconButton(
            icon: Icon(
              _obscureText ?Icons.visibility_off: Icons.visibility ,
              color: AppColors.BorderAnddividerAndIconColor,size: width*.05
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          )
              : null,
          filled: true,
          fillColor: AppColors.fillColorTextFilled,
          contentPadding: EdgeInsets.symmetric(vertical: height * .01, horizontal: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.BorderAnddividerAndIconColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.red),
          ),
        ),
      ),
    );
  }

}
