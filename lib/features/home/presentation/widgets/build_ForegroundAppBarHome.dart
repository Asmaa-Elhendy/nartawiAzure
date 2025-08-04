import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/game_icons.dart';

import '../../../../core/theme/colors.dart';

class BuildForegroundappbarhome extends StatefulWidget {
 double screenHeight;
 double screenWidth;
 BuildForegroundappbarhome({required this.screenHeight,required this.screenWidth});

  @override
  State<BuildForegroundappbarhome> createState() => _BuildForegroundappbarhomeState();
}

class _BuildForegroundappbarhomeState extends State<BuildForegroundappbarhome> {
  @override
  Widget build(BuildContext context) {
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
          const Text("NARTAWI",
              style: TextStyle(
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 16)),
          SizedBox(
            width: widget.screenWidth * .45,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Iconify(GameIcons.water_gallon,
                    size: widget.screenWidth * .06, color: AppColors.whiteColor),
                Icon(Icons.notifications,
                    color: AppColors.whiteColor, size: widget.screenWidth * .06),
                Icon(Icons.shopping_cart_outlined,
                    color: AppColors.whiteColor, size: widget.screenWidth * .06),
                SvgPicture.asset("assets/images/home/Language.svg",
                    width: widget.screenWidth * .06),
                SvgPicture.asset("assets/images/home/headphone.svg",
                    width: widget.screenWidth * .06),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
