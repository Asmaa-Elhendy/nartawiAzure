import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import '../../../../../../core/theme/colors.dart';
import '../../../../../../l10n/app_localizations.dart';

Widget BuildVerifiedWidget(double screenHeight,double screenWidth,bool isVerified,BuildContext context){

    return   Container(
      padding: EdgeInsets.symmetric(vertical: screenHeight*.01,horizontal: screenWidth*.02),
      decoration: BoxDecoration(
        color:  AppColors.greenLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Iconify(
            MaterialSymbols.verified_outline_rounded,  // This uses the Material Symbols "star" icon
            size: screenHeight*.027,
            color: AppColors.greenColor,
          ),SizedBox(width: screenWidth*.02,),
          Text(
          isVerified?  AppLocalizations.of(context)!.verified:AppLocalizations.of(context)!.notVerified,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.greenColor,
              fontSize: screenWidth*.034,
            ),
          ),
        ],
      ),
    );
  }
