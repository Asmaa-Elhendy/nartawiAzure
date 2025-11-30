import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/suppliers/supplier_full_card.dart';
import '../../../../../../core/theme/colors.dart';
import '../products/compared_product_card.dart';

Widget BuildFilterButton(double width, double height, void Function()? fun) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: height * .01),
    child: InkWell(
      onTap: fun,
      child: Container(
        width: width * .12,
        padding: EdgeInsets.symmetric(
          vertical: height * .01,
          horizontal: width * .01,
        ),
        height: height * .065,
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: SvgPicture.asset(
            'assets/images/home/main_page/supplier_detail/filter.svg',
            color: AppColors.whiteColor,
            height: height * .03,
          ),
        ),
      ),
    ),
  );
}

Widget BuildCompareButton(double width, double height,context) {
  return InkWell(
    onTap: (){
      showDialog(
        context: context,
        builder: (ctx) => Dialog( // Use Dialog instead of AlertDialog
          backgroundColor: AppColors.backgroundAlert,
          insetPadding: EdgeInsets.all(16), // controls distance from screen edges
          child: SizedBox(
            width: MediaQuery.of(ctx).size.width * 0.94, // 90% screen width
         //   height: MediaQuery.of(ctx).size.height * 0.69, // adjust height
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: [
                    BuildComparedProductCard(
                      ctx,
                      MediaQuery.of(ctx).size.height,
                      MediaQuery.of(ctx).size.width,
                      true,
                    ),
                    BuildComparedProductCard(
                      ctx,
                      MediaQuery.of(ctx).size.height,
                      MediaQuery.of(ctx).size.width,
                      true,
                    ),
                  ],
                ),

              ],
            ),
          ),
        ),
      );


    },
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: height * .01),
      child: Container(
        width: width * .12,
        padding: EdgeInsets.symmetric(
          vertical: height * .01,
          horizontal: width * .01,
        ),
        height: height * .065,
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: SvgPicture.asset(
            'assets/images/home/main_page/compare.svg',
            color: AppColors.whiteColor,
            height: height * .03,
          ),
        ),
      ),
    ),
  );
}
