import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';

class CustomTextFieldAlert extends StatefulWidget {
  String label;
  CustomTextFieldAlert( this.label);

  @override
  State<CustomTextFieldAlert> createState() => _CustomTextFieldAlertState();
}

class _CustomTextFieldAlertState extends State<CustomTextFieldAlert> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return  Container(
      height: screenHeight*.1,
      margin: EdgeInsets.only(
        bottom: screenHeight * .015,
      ),
      padding: EdgeInsets.symmetric(
      //  vertical: screenHeight * .03,
        horizontal: screenWidth * .01,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.greyDarktextIntExtFieldAndIconsHome, // 👈 Border color
          width: .5, // 👈 Optional: Border thickness
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        decoration: InputDecoration(
          contentPadding: EdgeInsetsGeometry.symmetric(horizontal: screenWidth*.01,vertical: 0),
          labelText: widget.label, // Optional: A label for the text field
          border: InputBorder.none, // Removes the default underline border
          labelStyle: TextStyle(
            fontSize: screenWidth * .036,color: AppColors.greyDarktextIntExtFieldAndIconsHome,
            fontWeight: FontWeight.w300,),
            hintStyle: TextStyle(
          fontSize: screenWidth * .03,
          fontWeight: FontWeight.w300,)
        ),
        keyboardType: TextInputType.multiline, // Enables multi-line input on the soft keyboard
        minLines: 1, // Optional: Sets the initial minimum number of lines
        maxLines: 5, // Optional: Limits the maximum number of visible lines before scrolling
        // or maxLines: null, // Allows the text field to expand indefinitely based on content
      ),
    );
  }
}
