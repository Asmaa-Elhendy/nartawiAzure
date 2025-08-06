import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';


import '../../../../core/theme/colors.dart';


Widget buildInfoPhoneInfo(double width){
  return  Padding(
    padding: const EdgeInsets.only(top:5.0),
    child: Row(
      children: [
        const Iconify(
          MaterialSymbols.info_outline,
          size: 18,
          color: AppColors.textSecondary,
        ),SizedBox(width: width*.01,),
        Text('8-digit Qatar phone number',style: TextStyle(color: AppColors.BorderAnddividerAndIconColor),),
      ],
    ),
  );
}