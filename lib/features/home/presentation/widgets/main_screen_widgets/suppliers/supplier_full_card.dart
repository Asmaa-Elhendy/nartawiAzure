import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';

import '../../../../../../core/theme/colors.dart';
import 'build_row_raing.dart';
import 'build_info_button.dart';
import 'build_verified_widget.dart';

class BuildFullCardSupplier extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;
  final bool isFeatured;
  final bool fromFavouritesScreen;
  final bool fromCartScreen;

  const BuildFullCardSupplier(
      this.screenHeight,
      this.screenWidth,
      this.isFeatured, {
        this.fromFavouritesScreen = false,
        this.fromCartScreen = false,
        super.key,
      });

  @override
  State<BuildFullCardSupplier> createState() => _BuildFullCardSupplierState();
}

class _BuildFullCardSupplierState extends State<BuildFullCardSupplier> {
  bool isFavourite = false;
  bool isExpanded = false;

  final String description =
      'Premium Water Supplier With Quality Products And Reliable Delivery Service. This description is long and should show fully when expanded.';

  @override
  Widget build(BuildContext context) {
    final h = widget.screenHeight;
    final w = widget.screenWidth;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: widget.fromCartScreen ? 0 : w * .04,
        vertical: widget.fromFavouritesScreen ? h * .01 :
        0,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: h * .01,
          horizontal: w * .03,
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
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ اللوجو بحجم ثابت
                SizedBox(
                  width: h * .09,
                  height: h * .09,
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
                      child: Image.asset(
                        "assets/images/home/main_page/company.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                SizedBox(width: w * .03),

                // ✅ باقي الكارت في Expanded عشان ما يحصلش overflow
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ====== اسم الشركة + زر الفيفوريت ======
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // اسم الشركة ياخد أكبر مساحة
                          Expanded(
                            child: Text(
                              'Company A',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: w * .036,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: w * .02),
                          InkWell(
                            onTap: () {
                              if (!widget.fromFavouritesScreen) {
                                setState(() {
                                  isFavourite = !isFavourite;
                                });
                              }
                            },
                            child: Container(
                              width: h * .045,
                              height: h * .045,
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
                              child: Center(
                                child: Iconify(
                                  widget.fromFavouritesScreen
                                      ? Mdi.heart
                                      : (isFavourite
                                      ? Mdi.heart
                                      : Mdi.heart_outline),
                                  color: widget.fromFavouritesScreen
                                      ? AppColors.redColor
                                      : AppColors.primary,
                                  size: h * .024,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // ====== Rating + Verified ======
                      Padding(
                        padding: EdgeInsets.only(
                          top: h * .015,
                          bottom: h * .008,
                        ),
                        child: Row(
                          children: [
                            // ⭐ خلي الـ Rating جوّه Flexible
                            Flexible(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: BuildRowRating(w, h),
                                ),
                              ),
                            ),
                            SizedBox(width: w * .02),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: BuildVerifiedWidget(h, w),
                            ),
                          ],
                        ),
                      ),

                      // ====== الوصف مع Expand / Collapse ======
                      AnimatedCrossFade(
                        firstChild: Text(
                          description,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: w * 0.036,
                            fontWeight: FontWeight.w400,
                            color:
                            AppColors.greyDarktextIntExtFieldAndIconsHome,
                          ),
                        ),
                        secondChild: Text(
                          description,
                          style: TextStyle(
                            fontSize: w * 0.036,
                            fontWeight: FontWeight.w400,
                            color:
                            AppColors.greyDarktextIntExtFieldAndIconsHome,
                          ),
                        ),
                        crossFadeState: isExpanded
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        duration: const Duration(milliseconds: 300),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // ====== زرار Info / Show less ======
            BuildInfoAndAddToCartButton(
              w,
              h,
              isExpanded ? 'Show less' : 'Info',
              true,
                  () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
