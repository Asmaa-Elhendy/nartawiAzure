
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/carbon.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:newwwwwwww/core/theme/colors.dart';
import 'dart:io' show Platform;
class CustomBottomNavDelivery extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTabSelected;
  final List<String> originalTabs;
  final List<Widget> icons;

  const CustomBottomNavDelivery({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,required this.icons,required this.originalTabs
  });

  @override
  State<CustomBottomNavDelivery> createState() => _CustomBottomNavDeliveryState();
}
ValueNotifier<int> myTitleDelivery = ValueNotifier<int>(12);

class _CustomBottomNavDeliveryState extends State<CustomBottomNavDelivery> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }


  List<String> get dynamicTabOrder {

    if (widget.currentIndex == 1) {
      return widget.originalTabs;
    } else {
      // تبديل التاب المختار مع Home (index = 2)
      List<String> updated = List.from(widget.originalTabs);
      updated[1] = widget.originalTabs[widget.currentIndex];
      updated[widget.currentIndex] = 'Orders';
      myTitleDelivery.value=widget.currentIndex;

      return updated;
    }

  }
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    List<Widget> icons = [

      SvgPicture.asset("assets/images/navigation_bar/work_history.svg", color: AppColors.whiteColor,),


      SvgPicture.asset("assets/images/navigation_bar/orderIcon.svg", color: AppColors.whiteColor,),


      SvgPicture.asset("assets/images/navigation_bar/user-profile_navigation_bar.svg", color: AppColors.whiteColor),

    ];
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      child: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: screenWidth * 0.018,
        color: Colors.white,
        child: Container(
          height: screenHeight * 0.09,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    context,
                    _getTabIcon(0, screenWidth),
                    dynamicTabOrder[0],
                    0,
                  ),
                  _buildNavItem(
                    context,
                    _getTabIcon(2, screenWidth),
                    dynamicTabOrder[2],
                    2,
                  ),

                ],
              ),
              // Home label تحت اللوجو
              Positioned(
                bottom:Platform.isAndroid ?  screenHeight * 0.022:screenHeight*0.018, //0.026
                child: GestureDetector(
                  onTap: () => widget.onTabSelected(1),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: screenHeight * 0.005),
                      Text(
                        dynamicTabOrder[1], // 👈 دايماً اسم التاب اللي في النص فعلياً
                        style: TextStyle(
                          color: AppColors.darkBlue, // 👈 اللي في النص دايماً أزرق
                          fontSize: screenWidth * 0.032,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getTabIcon(int index, double screenWidth) {
    switch (index) {
      case 0:
        return widget.icons[0];
      case 2:
        return widget.icons[2];

      default:
        return const SizedBox();
    }
  }

  Widget _buildNavItem(
      BuildContext context, Widget icon, String label, int index) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () => widget.onTabSelected(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          SizedBox(height: screenHeight * 0.008),
          Text(
            label,
            style: TextStyle(
              color: AppColors.greyDarktextIntExtFieldAndIconsHome,
              fontSize: screenWidth * 0.03,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

