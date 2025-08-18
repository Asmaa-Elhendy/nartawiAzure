import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/game_icons.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:newwwwwwww/features/cart/presentation/screens/cart_screen.dart';

import '../../../../core/theme/colors.dart';

class BuildForegroundappbarhome extends StatefulWidget {
 double screenHeight;
 double screenWidth;
 String title;
 bool is_returned;
 BuildForegroundappbarhome({required this.screenHeight,required this.screenWidth,required this.title,required this.is_returned});

  @override
  State<BuildForegroundappbarhome> createState() => _BuildForegroundappbarhomeState();
}

class _BuildForegroundappbarhomeState extends State<BuildForegroundappbarhome> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return   Positioned(
      top: MediaQuery
          .of(context)
          .padding
          .top + widget.screenHeight * .05,
      left: 16,
      right: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
           Row(mainAxisAlignment: MainAxisAlignment.start,
             children: [
               widget.is_returned?  GestureDetector(
                 onTap: (){
                   Navigator.pop(context);
                 },
                 child: Padding(
                   padding:  EdgeInsets.only(right: screenWidth*.02,left: screenWidth*.02),
                   child: Iconify(
                     MaterialSymbols.arrow_back_ios,
                     size: screenWidth*.05,
                     color: AppColors.whiteColor,
                   ),
                 ),
               ):SizedBox(),
               Text(widget.title,
                  style: TextStyle(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w400,
                      fontSize: widget.screenWidth*.044)),
             ],
           ),
          SizedBox(
            width: widget.screenWidth * .38,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Iconify(GameIcons.water_gallon,
                    size: widget.screenWidth * .05, color: AppColors.whiteColor),
                Icon(Icons.notifications,
                    color: AppColors.whiteColor, size: widget.screenWidth * .05),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>CartScreen()));
                  },
                  child: Icon(Icons.shopping_cart_outlined,
                      color: AppColors.whiteColor, size: widget.screenWidth * .05),
                ),
                SvgPicture.asset("assets/images/home/Language.svg",
                    width: widget.screenWidth * .05),
                SvgPicture.asset("assets/images/home/headphone.svg",
                    width: widget.screenWidth * .05),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
