import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newwwwwwww/features/home/domain/models/product_categories_models/product_category_model.dart';
import 'package:newwwwwwww/features/home/presentation/pages/all_product_screen.dart';
import 'package:newwwwwwww/features/home/presentation/pages/popular_category_screen.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/utils/components/confirmation_alert.dart';
import '../../../../../../l10n/app_localizations.dart';

Widget AddCoupon(BuildContext context,double screenWidth,double screenHeight){
  return InkWell(
    onTap: () {
      showDialog(
        context: context,
        builder: (dialogContext) => ConfirmationAlert(price: 0,
          centerTitle: AppLocalizations.of(context)!.maxCouponsReached,
          leftTtile: AppLocalizations.of(context)!.continueShopping,rightTitle: AppLocalizations.of(context)!.cancel,
          leftOnTap: () {
            // 👈 ده هيقفل الـ Dialog بس
            Navigator.of(dialogContext).pop();
            // go to products filter by coupons
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PopularCategoryScreen(category: ProductCategory(id: 0, arName: 'arName', enName: 'enName', uiOrderId: 0, products: []),)),
            );
          },rightOnTap: (){
          Navigator.pop(dialogContext);
        },
        ),
      );
    },
    child: Container(
      width: screenWidth*.1,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primary,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.add,
          color: AppColors.primary,
          size: screenWidth*.065,
        ),
      ),
    ),
  );
}
