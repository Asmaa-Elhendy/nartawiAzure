import 'package:flutter/material.dart';
import 'package:newwwwwwww/features/home/domain/models/supplier_model.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/suppliers/build_row_raing.dart';

import '../../../../../../core/theme/colors.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../pages/suppliers/supplier_detail.dart';

Widget BuildCardSupplier(
    BuildContext context,
    double screenHeight,
    double screenWidth,
    Supplier supplier,
    ) {
  final double avatarSize = screenHeight * 0.09;

  return GestureDetector(
    onTap: () {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => SupplierDetails(supplier:supplier)),
      );
    },
    child: Padding(
      padding: EdgeInsets.only(bottom: screenHeight * .035),
      child: Container(
        // خليه ياخد الارتفاع الطبيعي بدل fixed height
        padding: EdgeInsets.symmetric(
          vertical: screenHeight * .01,
          horizontal: screenWidth * .02,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.whiteColor,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor,
              offset: const Offset(0, 2),
              blurRadius: 8,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 👇 اللوجو بحجم ثابت لكن جوه SizedBox صغير
            SizedBox(
              width: avatarSize,
              height: avatarSize,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.backgrounHome,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipOval(
                  child:  supplier.logoUrl==null||supplier.logoUrl==''?
                  Image.asset(
                      'assets/images/home/main_page/person.png'
                    //  fit: BoxFit.cover,
                  )
                      :
                  Image.network(
                    supplier.logoUrl! ,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                          'assets/images/home/main_page/person.png'
                        //  fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
              ),
            ),

            SizedBox(width: screenWidth * .03),

            // 👇 باقي المحتوى في Expanded عشان ما يطلعش برة
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // ====== السطر الأول: الاسم + Featured/Sponsored
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                         AppLocalizations.of(context)!.localeName == 'ar' 
                             ? supplier.arName 
                             : supplier.enName,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: screenWidth * .036,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: screenWidth * .01),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: BuildFeaturedOrSponsered(
                          screenHeight,
                          screenWidth,
                          supplier.isVerified?'Verified':'Not Verified'//isActive ? 'Featured' : 'Sponsored',
                        ,  context,),
                      ),
                    ],
                  ),

                  SizedBox(height: screenHeight * .006),

                  // ====== السطر الثاني: Rating + View Details
                  Row(
                    children: [
                      // 👇 هنا لفينا الـ Rating بـ FittedBox كمان
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: BuildRowRating(screenWidth, screenHeight,title: supplier.rating.toString()),
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth * .015),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * .007,
                            horizontal: screenWidth * .025,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.blueBorder,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.viewDetails,
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: screenWidth * .034,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget BuildFeaturedOrSponsered(
    double screenHeight,
    double screenWidth,
    String title,
    BuildContext context
    ) {
  return Container(
    padding: EdgeInsets.symmetric(
      vertical: screenHeight * .003,
      horizontal: screenWidth * .02,
    ),
    decoration: BoxDecoration(
      color:title=='Verified'?AppColors.primaryLight: title == 'Featured'
          ? AppColors.greenLight
          : AppColors.orangeLight,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      title=='Verified'? AppLocalizations.of(context)!.verified: AppLocalizations.of(context)!.notVerified,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        color:title=='Verified'?AppColors.nextRefillTextColor: title == 'Featured'
            ? AppColors.greenColor
            : AppColors.orangeColor,
        fontSize: screenWidth * .032,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ),
  );
}
