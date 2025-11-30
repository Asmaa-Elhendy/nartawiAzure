import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/suppliers/build_info_button.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/suppliers/build_verified_widget.dart';

import '../../../../../../core/theme/colors.dart';
import '../suppliers/build_row_raing.dart';
import 'generate_specification_product.dart';


// Widget BuildComparedProductCard(
//     BuildContext context,
//     double screenHeight,
//     double screenWidth,
//     bool isFeatured,
//     ) {
//   List specifications = ['pH 7.5', '5 Gallon x 4', '15mg/L Sodium'];
//   bool isFavourite=false;
//   return Padding(
//     padding: EdgeInsets.symmetric(
//       horizontal: screenWidth * .01,
//       vertical: screenHeight * .015,
//     ),
//     child: Container(
//       // ❌ خدي بالك: ما تحطيش height ثابت هنا عشان ما يضغطش المحتوى من تحت
//       padding: EdgeInsets.symmetric(
//         vertical: screenHeight * .01,
//         horizontal: screenWidth * .02,
//       ),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         color: AppColors.backgroundCardAlert,
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.shadowColor,
//             offset: Offset(0, 2),
//             blurRadius: 8,
//             spreadRadius: 0,
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min, // 👈 مهم عشان ما يحصلش overflow من تحت
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // صورة الشركة
//               Container(
//                 height: screenHeight * .085,
//                 decoration: BoxDecoration(
//                   color: AppColors.backgrounHome,
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 4,
//                       offset: Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: Image.asset(
//                   "assets/images/home/main_page/company.png",
//                   height: screenHeight * .03,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//
//               SizedBox(width: screenWidth * .02),
//
//               // النصوص + الأيقونة جنب بعض زي ما هي
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           child: Text(
//                             'Company 1',
//                             style: TextStyle(
//                               fontWeight: FontWeight.w600,
//                               fontSize: screenWidth * .037,
//                             ),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                         SizedBox(width: screenWidth * .02),
//                         GestureDetector(
//                           onTap: (){},
//                           child: Center(
//                             child: Iconify(
//                               Mdi.heart_outline,
//                               color: AppColors.primary,
//                               size: screenHeight * .028,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     Text(
//                       '330 mlx24pcs(50packs)',
//                       style: TextStyle(
//                         color:
//                         AppColors.greyDarktextIntExtFieldAndIconsHome,
//                         fontSize: screenWidth * .03,
//                       ),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(
//                         top: screenHeight * .02,
//                         bottom: screenHeight * .01,
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           BuildRowRating(screenWidth, screenHeight),
//                           BuildVerifiedWidget(screenHeight, screenWidth),
//                         ],
//                       ),
//                     ),
//                     generateSpecifications(
//                       screenWidth,
//                       screenHeight,
//                       specifications,
//                     ),
//                     Padding(
//                       padding: EdgeInsets.symmetric(
//                         vertical: screenHeight * .01,
//                       ),
//                       child: Text(
//                         'QAR 20.00',
//                         style: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           fontSize: screenWidth * .037,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//
//           // زرار Add to Cart تحت زي ما هو
//           BuildInfoAndAddToCartButton(
//             screenWidth,
//             screenHeight,
//             'Add To Cart',
//             false,
//                 () {},
//           ),
//         ],
//       ),
//     ),
//   );
// }

class BuildComparedProductCard extends StatefulWidget {
  BuildContext context;
      double screenHeight;
  double screenWidth;
      bool isFeatured;
BuildComparedProductCard(this.context,this.screenHeight,this.screenWidth,this.isFeatured);
  @override
  State<BuildComparedProductCard> createState() => _BuildComparedProductCardState();
}

class _BuildComparedProductCardState extends State<BuildComparedProductCard> {
  List specifications = ['pH 7.5', '5 Gallon x 4', '15mg/L Sodium'];
  bool isFavourite=false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: widget.screenWidth * .01,
        vertical:widget. screenHeight * .015,
      ),
      child: Container(
        // ❌ خدي بالك: ما تحطيش height ثابت هنا عشان ما يضغطش المحتوى من تحت
        padding: EdgeInsets.symmetric(
          vertical: widget.screenHeight * .01,
          horizontal: widget.screenWidth * .02,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.backgroundCardAlert,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor,
              offset: Offset(0, 2),
              blurRadius: 8,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // 👈 مهم عشان ما يحصلش overflow من تحت
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // صورة الشركة
                Container(
                  height: widget.screenHeight * .085,
                  decoration: BoxDecoration(
                    color: AppColors.backgrounHome,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    "assets/images/home/main_page/company.png",
                    height: widget.screenHeight * .03,
                    fit: BoxFit.cover,
                  ),
                ),

                SizedBox(width: widget.screenWidth * .02),

                // النصوص + الأيقونة جنب بعض زي ما هي
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Company 1',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: widget.screenWidth * .037,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: widget.screenWidth * .02),
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                isFavourite=!isFavourite;
                              });
                            },
                            child: Center(
                              child: Iconify(
                                isFavourite?Mdi.heart:Mdi.heart_outline,
                                color: AppColors.primary,
                                size: widget.screenHeight * .028,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '330 mlx24pcs(50packs)',
                        style: TextStyle(
                          color:
                          AppColors.greyDarktextIntExtFieldAndIconsHome,
                          fontSize: widget.screenWidth * .03,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: widget.screenHeight * .02,
                          bottom: widget.screenHeight * .01,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            BuildRowRating(widget.screenWidth, widget.screenHeight),
                            BuildVerifiedWidget(widget.screenHeight, widget.screenWidth),
                          ],
                        ),
                      ),
                      generateSpecifications(
                        widget.screenWidth,
                        widget.screenHeight,
                        specifications,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: widget.screenHeight * .01,
                        ),
                        child: Text(
                          'QAR 20.00',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: widget.screenWidth * .037,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // زرار Add to Cart تحت زي ما هو
            BuildInfoAndAddToCartButton(
              widget.screenWidth,
              widget.screenHeight,
              'Add To Cart',
              false,
                  () {},
            ),
          ],
        ),
      ),
    );
  }
}

