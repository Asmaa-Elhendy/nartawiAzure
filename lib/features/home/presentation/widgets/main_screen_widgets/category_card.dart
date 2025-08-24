import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import '../../../../../core/theme/colors.dart';

class CategoryCard extends StatefulWidget {
  double screenWidth;
  double screenHeight;
  String icon;
  String title;
  CategoryCard({required  this.screenWidth,required this.screenHeight,required this.icon,required this.title});

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: widget.screenHeight*.01,horizontal: widget.screenWidth*.02),
      child: Container(
        width: widget.screenWidth*.24,
         height: widget.screenHeight*.123,
          padding:  EdgeInsets.symmetric(vertical: widget.screenHeight*.01,horizontal: widget.screenWidth*.04),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColors.secondaryColorWithOpacity8,
            boxShadow: [
              BoxShadow(
                color:AppColors.shadowColor, // ظل خفيف
                offset: Offset(0, 1),
                blurRadius: 2,
                spreadRadius: 0,
              ),
            ],
          ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.icon.contains('assets')?
          SvgPicture.asset(
           widget. icon,
            height: widget.screenHeight*.027,
          ):
          Iconify(
           widget.icon,
            size: widget.screenHeight*.027,
            color: AppColors.primary,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: widget.screenHeight*.008),
            child: Text(widget.title,style: TextStyle(color: AppColors.primary,fontSize: widget.screenWidth*.032,fontWeight: FontWeight.w500),),
          )
        ],
      ),
      ),
    );
  }
}
