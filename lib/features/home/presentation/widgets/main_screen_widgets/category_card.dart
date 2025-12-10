import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import '../../../../../core/theme/colors.dart';

class CategoryCard extends StatefulWidget {
  double screenWidth;
  double screenHeight;
  String icon;
  String title;
  bool fromMainPupularCategoriesScreen;

  CategoryCard({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.icon,
    required this.title,
    this.fromMainPupularCategoriesScreen = false,
  });

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: widget.screenHeight * .01,
        horizontal: widget.screenWidth * .02,
      ),
      child: Container(
        width: widget.screenWidth * .24,
        height: widget.screenHeight * .123,
        padding: EdgeInsets.symmetric(
          vertical: widget.screenHeight * .01,
          horizontal: widget.screenWidth * .04,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.secondaryColorWithOpacity8,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor,
              offset: const Offset(0, 1),
              blurRadius: 2,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ✅ الأيقونة زي ما هي
            widget.icon.contains('assets')
                ? SvgPicture.asset(
              widget.icon,
              height: widget.fromMainPupularCategoriesScreen
                  ? widget.screenHeight * .038
                  : widget.screenHeight * .027,
            )
                : Iconify(
              widget.icon,
              size: widget.fromMainPupularCategoriesScreen
                  ? widget.screenHeight * .038
                  : widget.screenHeight * .027,
              color: AppColors.primary,
            ),

            // ✅ زيادة بسيطة في المسافة بين الأيقونة والنص
            SizedBox(
              height: widget.fromMainPupularCategoriesScreen
                  ? widget.screenHeight * .014   // كانت .01 زودناها سنة بسيطة
                  : widget.screenHeight * .012,
            ),

            // ✅ النص في مساحة ثابتة عشان ما يكبرش الكارد
            SizedBox(
              height: widget.screenHeight * .028,
              child: Center(
                child: Text(
                  widget.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: widget.fromMainPupularCategoriesScreen
                        ? widget.screenWidth * .043
                        : widget.screenWidth * .032,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
