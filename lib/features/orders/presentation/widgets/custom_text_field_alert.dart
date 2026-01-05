import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';

class CustomTextFieldAlert extends StatefulWidget {
  final String label;

  // ✅ new optional params
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final int maxLines;
  final int minLines;
  final TextInputType keyboardType;

  const CustomTextFieldAlert(
      this.label, {
        super.key,
        this.controller,
        this.validator,
        this.maxLines = 5,
        this.minLines = 1,
        this.keyboardType = TextInputType.multiline,
      });

  @override
  State<CustomTextFieldAlert> createState() => _CustomTextFieldAlertState();
}

class _CustomTextFieldAlertState extends State<CustomTextFieldAlert> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: screenHeight * .13,
      margin: EdgeInsets.only(bottom: screenHeight * .015),
      padding: EdgeInsets.symmetric(horizontal: screenWidth * .01),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.greyDarktextIntExtFieldAndIconsHome,
          width: .5,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        controller: widget.controller,
        validator: widget.validator, // ✅ optional
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: screenWidth * .01,
            vertical: 0,
          ),
          label: Text(
            widget.label,
            maxLines: 2,
            overflow: TextOverflow.visible,
            style: TextStyle(
              fontSize: screenWidth * .034,
              color: AppColors.greyDarktextIntExtFieldAndIconsHome,
              fontWeight: FontWeight.w400,
            ),
          ),
          border: InputBorder.none,
          hintStyle: TextStyle(
            fontSize: screenWidth * .03,
            fontWeight: FontWeight.w300,
          ),
        ),
        keyboardType: widget.keyboardType,
        minLines: widget.minLines,
        maxLines: widget.maxLines,
      ),
    );
  }
}
