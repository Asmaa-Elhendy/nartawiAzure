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
     this.isFeatured,{
    this.fromFavouritesScreen = false,
        this.fromCartScreen=false
  }) : super();

  @override
  State<BuildFullCardSupplier> createState() => _BuildFullCardSupplierState();
}

class _BuildFullCardSupplierState extends State<BuildFullCardSupplier> {
  bool isFavourite=false;
  bool isExpanded = false;
  final String description =
      'Premium Water Supplier With Quality Products And Reliable Delivery Service. This description is long and should show fully when expanded.';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: widget.fromCartScreen?0:widget.screenWidth * .04,
          vertical: widget.fromFavouritesScreen ? widget.screenHeight * .01 : 0),
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: widget.screenHeight * .01,
            horizontal: widget.screenWidth * .02),
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
                Container(
                  height: widget.screenHeight * .09,
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
                  child: Image.asset(
                    "assets/images/home/main_page/company.png",
                    height: widget.screenHeight * .03,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: widget.screenWidth * .03),
                SizedBox(
                  width: widget.screenWidth * .66,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Company A',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: widget.screenWidth * .036)),
                          InkWell(
                            onTap: (){
                           if(!widget.fromFavouritesScreen){
                             isFavourite=!isFavourite;
                             setState(() {

                             });
                           }
                            },
                            child: Container(
                              width: widget.screenWidth * .1,
                              height: widget.screenHeight * .045,
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
                                      :isFavourite?Mdi.heart: Mdi.heart_outline,
                                  color: widget.fromFavouritesScreen
                                      ? AppColors.redColor
                                      : AppColors.primary,
                                  size: widget.screenHeight * .03,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: widget.screenHeight * .02,
                            bottom: widget.screenHeight * .01),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            BuildRowRating(
                                widget.screenWidth, widget.screenHeight),
                            BuildVerifiedWidget(
                                widget.screenHeight, widget.screenWidth),
                          ],
                        ),
                      ),
                      AnimatedCrossFade(
                        firstChild: Text(
                          description,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: widget.screenWidth * 0.036,
                            fontWeight: FontWeight.w400,
                            color: AppColors
                                .greyDarktextIntExtFieldAndIconsHome,
                          ),
                        ),
                        secondChild: Text(
                          description,
                          style: TextStyle(
                            fontSize: widget.screenWidth * 0.036,
                            fontWeight: FontWeight.w400,
                            color: AppColors
                                .greyDarktextIntExtFieldAndIconsHome,
                          ),
                        ),
                        crossFadeState: isExpanded
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        duration: const Duration(milliseconds: 300),
                      ),
                    ],
                  ),
                )
              ],
            ),
            BuildInfoAndAddToCartButton(
              widget.screenWidth,
              widget.screenHeight,
              isExpanded ? 'Show less' : 'Info',
              true,
                  () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
