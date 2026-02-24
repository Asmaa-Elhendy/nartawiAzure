

import 'package:flutter/material.dart';
import 'package:newwwwwwww/features/coupons/domain/models/bundle_purchase.dart';

import '../../../../core/components/coupon_status_widget.dart';
import '../../../../core/theme/colors.dart';
import '../../../../l10n/app_localizations.dart';
import 'custom_text.dart';

Widget latestCouponTracker(BuildContext context,double screenWidth,double screenHeight,Function onReorder,BundlePurchase bundle){
  return
      Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              customCouponPrimaryTitle(
                AppLocalizations.of(context)!.couponBalance,
                screenWidth,
                screenHeight,
              ),
              GestureDetector(
                onTap: (){
                  onReorder();
                },
                  child: CouponStatus(screenHeight, screenWidth,AppLocalizations.of(context)!.reOrder)),
            ],
          ),//k

          /// Progress bar
          Padding(
            padding: EdgeInsets.symmetric(vertical: screenHeight * .02),
            child: LinearProgressIndicator(
              value:(bundle.totalCoupons-bundle.couponsPerBundle).toDouble(),
              backgroundColor: AppColors.primaryLight,
              minHeight: screenHeight * .012,
              borderRadius: BorderRadius.circular(10),
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),

          /// Totals row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              customCouponSecondaryTitle(
                '${bundle.totalCoupons} ${AppLocalizations.of(context)!.total}',
                screenWidth,
                screenHeight,
              ),
              customCouponSecondaryTitle(
                '${bundle.couponsPerBundle} ${AppLocalizations.of(context)!.used}',
                screenWidth,
                screenHeight,
              ),
              customCouponSecondaryTitle(
                '${bundle.totalCoupons-bundle.couponsPerBundle} ${AppLocalizations.of(context)!.remaining}',
                screenWidth,
                screenHeight,
              ),
            ],
          ),

        ],
      );
}