import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';


class CustomeTextField extends StatefulWidget {
  final String iconPath;
  final String hintText;
  final String label;
  final TextEditingController? controller;

  const CustomeTextField({
    Key? key,
    required this.iconPath,
    required this.hintText,
    this.label = '',
    this.controller,
  }) : super(key: key);

  @override
  State<CustomeTextField> createState() => _CustomeTextFieldState();
}

class _CustomeTextFieldState extends State<CustomeTextField> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    double height=MediaQuery.of(context).size.height;
    return Container(//height: height*.07,
     // padding: EdgeInsets.symmetric(vertical: height*.001),

      child: TextFormField(autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: widget.controller,
        obscureText: widget.label.toLowerCase().contains('password') ? _obscureText : false,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field is required';
          }
          return null;
        },cursorColor: AppColors.primary,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: AppTextStyles.textInTextField,
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: width * .04, right: width * .02),
            child: Image.asset(
              widget.iconPath,
              width: width * .11,
            ),
          ),
          suffixIcon: widget.label.toLowerCase().contains('password')
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off: Icons.visibility ,
                    color: AppColors.BorderAnddividerAndIconColor,
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
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(color: AppColors.BorderAnddividerAndIconColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
