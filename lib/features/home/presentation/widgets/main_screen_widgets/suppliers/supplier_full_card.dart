import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:newwwwwwww/features/home/domain/models/supplier_model.dart';
import 'package:newwwwwwww/features/favourites/pesentation/provider/favourite_controller.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/theme/colors.dart';
import '../../../../../../l10n/app_localizations.dart';
import 'build_row_raing.dart';
import 'build_info_button.dart';
import 'build_verified_widget.dart';

class BuildFullCardSupplier extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;
  final bool isFeatured;
  final bool fromFavouritesScreen;
  final bool fromCartScreen;
  final Supplier supplier;

  const BuildFullCardSupplier(
      this.screenHeight,
      this.screenWidth,
       this.supplier,

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
  
  // ✅ يمنع الضغط المتكرر بسرعة (optional)
  bool _isToggling = false;
  
  // ✅ Store controller reference to avoid context issues in dispose
  FavoritesController? _favoritesController;

  @override
  void initState() {
    super.initState();
    
    // ✅ Check initial favorite status from controller
    if (widget.fromFavouritesScreen) {
      // In favorites screen, it's always favorited
      isFavourite = true;
    } else {
      // In other screens, check from controller
      _favoritesController = context.read<FavoritesController>();
      isFavourite = _favoritesController!.isVendorFavorited(widget.supplier.id);
      
      // ✅ Listen for changes to update UI automatically
      _favoritesController!.addListener(_onFavoritesChanged);
    }
  }

  @override
  void dispose() {
    if (!widget.fromFavouritesScreen && _favoritesController != null) {
      _favoritesController!.removeListener(_onFavoritesChanged);
    }
    super.dispose();
  }

  void _onFavoritesChanged() {
    if (!widget.fromFavouritesScreen && mounted && _favoritesController != null) {
      final newStatus = _favoritesController!.isVendorFavorited(widget.supplier.id);
      if (isFavourite != newStatus) {
        setState(() {
          isFavourite = newStatus;
        });
      }
    }
  }

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
                      child:  widget.supplier.logoUrl==null||widget.supplier.logoUrl==''?
                      Image.asset(
                          'assets/images/home/main_page/person.png'
                        //  fit: BoxFit.cover,
                      )
                          :
                      Image.network(
                        widget.supplier.logoUrl! ,
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
                              AppLocalizations.of(context)!.localeName == 'ar' 
                                  ? widget.supplier.arName 
                                  : widget.supplier.enName,
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
                            onTap: () async {
                              if (widget.fromFavouritesScreen) return;
                              
                              if (_isToggling) return;
                              _isToggling = true;

                              final oldValue = isFavourite;

                              setState(() {
                                isFavourite = !isFavourite;
                              });

                              // ✅ LOG في الـ terminal
                              if (isFavourite) {
                                debugPrint('❤️ [VENDOR FAVORITE] Added locally (not API yet)');
                              } else {
                                debugPrint('🤍 [VENDOR FAVORITE] Removed locally (not API yet)');
                              }

                              // ✅ API call with automatic refresh
                              final favoritesController = _favoritesController ?? context.read<FavoritesController>();
                              try {
                                if (isFavourite) {
                                  await favoritesController.makeVendorFavorite(widget.supplier.id);
                                  debugPrint('✅ API: Vendor added to favorites');
                                } else {
                                  await favoritesController.removeVendorFavorite(widget.supplier.id);
                                  debugPrint('✅ API: Vendor removed from favorites');
                                }
                                
                                // ✅ Show SnackBar after successful API call
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(isFavourite ? 'Vendor added to favorites' : 'Vendor removed from favorites'),
                                      behavior: SnackBarBehavior.floating,
                                      duration: const Duration(milliseconds: 800),
                                    ),
                                  );
                                }
                              } catch (e) {
                                debugPrint('❌ API ERROR: $e');
                                setState(() => isFavourite = oldValue); // rollback
                                
                                // ✅ Show error SnackBar
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Failed to update favorites: $e'),
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.red,
                                      duration: const Duration(milliseconds: 1500),
                                    ),
                                  );
                                }
                              }

                              _isToggling = false;
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
                                  child: BuildRowRating(w, h,title: widget.supplier.rating.toString()),
                                ),
                              ),
                            ),
                            SizedBox(width: w * .02),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: BuildVerifiedWidget(h, w,widget.supplier.isVerified,context),
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
              isExpanded ?   AppLocalizations.of(context)!.showLess :   AppLocalizations.of(context)!.info,
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
