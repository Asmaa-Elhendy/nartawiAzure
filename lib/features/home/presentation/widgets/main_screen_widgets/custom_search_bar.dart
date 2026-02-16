// lib/widgets/custom_search_bar.dart

import 'package:flutter/material.dart';

import '../../../../../core/theme/colors.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;
  final VoidCallback? onSearch;
  final VoidCallback? onClear;
  final double height;
  final double width;
  final bool fromSupplierDetail;
  final bool hideFliterForNow;

  const CustomSearchBar({
    Key? key,
    required this.controller,
    this.onChanged,
    this.onSearch,
    this.onClear,
    required this.height,
    required this.width,
    this.fromSupplierDetail = false
    ,this.hideFliterForNow=false
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(//k
      padding:  EdgeInsets.only(bottom: height*.01),
      child: Container(
        height:hideFliterForNow?height*.06:fromSupplierDetail?height*.07 :height*.06,
        width: hideFliterForNow?width*.9:fromSupplierDetail?width*.75:width,

        child: TextField(
          cursorColor: AppColors.primary,

          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: 'search for water products...',
            hintStyle: TextStyle(color: AppColors.greyDarktextIntExtFieldAndIconsHome,fontSize: 13,),
            prefixIcon: IconButton(
              icon: const Icon(Icons.search,color: AppColors.greyDarktextIntExtFieldAndIconsHome,),
              onPressed: onSearch,
            ),suffixIcon: controller.text.isNotEmpty
          ? IconButton(
              icon: const Icon(Icons.clear,color: AppColors.greyDarktextIntExtFieldAndIconsHome,),
              onPressed: onClear,
            )
          : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24.0),

            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24.0),
              borderSide: const BorderSide(
                color: AppColors.primary, // Change this to your desired color
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24.0),
              borderSide: const BorderSide(
                color: AppColors.primary, // Color when the field is focused
                width: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
