// lib/widgets/custom_search_bar.dart

import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onSearch;
  final double height;
  final double width;

  const CustomSearchBar({
    Key? key,
    required this.controller,
    this.onSearch,required this.height,required this.width
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height*.06,
      width: width,

      child: TextField(
        controller: controller,

        decoration: InputDecoration(
          hintText: 'search for water products...',
          hintStyle: TextStyle(color: AppColors.textIntExtFieldAndIconsHome,fontSize: 13,),
          prefixIcon: IconButton(
            icon: const Icon(Icons.search,color: AppColors.textIntExtFieldAndIconsHome,),
            onPressed: onSearch,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),

          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(
              color: AppColors.primary, // Change this to your desired color
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(
              color: AppColors.primary, // Color when the field is focused
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}
