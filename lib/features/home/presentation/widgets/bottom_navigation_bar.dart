
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/carbon.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:newwwwwwww/core/theme/colors.dart';

class CustomBottomNav extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTabSelected;
  final List<String> originalTabs;
  final List<Widget> icons;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,required this.icons,required this.originalTabs
  });

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}
ValueNotifier<int> myTitle = ValueNotifier<int>(12);

class _CustomBottomNavState extends State<CustomBottomNav> {
@override
  void initState() {
    // TODO: implement initState

    super.initState();
  }


  List<String> get dynamicTabOrder {

    if (widget.currentIndex == 2) {
      return widget.originalTabs;
    } else {
      // تبديل التاب المختار مع Home (index = 2)
      List<String> updated = List.from(widget.originalTabs);
      updated[2] = widget.originalTabs[widget.currentIndex];
      updated[widget.currentIndex] = 'Home';
      myTitle.value=widget.currentIndex;

      return updated;
    }

  }
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    List<Widget> icons = [
      Icon(Icons.format_list_numbered,
          color: AppColors.whiteColor,
          size: screenWidth * .06),
      Iconify(
        Mdi.coupon_outline,
        color: AppColors.whiteColor,
        size: screenWidth * .06,
      ),
      Image.asset(
        "assets/images/onboaring/Logo.png", color: AppColors.whiteColor,
        width: screenWidth * .12,),
      Iconify(
        Mdi.heart_outline,
        color: AppColors.whiteColor,
        size: screenWidth * .06,
      ),
      Iconify(
        Carbon.user_profile,
        color: AppColors.whiteColor,
        size: screenWidth * .06,
      )
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
                    _getTabIcon(1, screenWidth),
                    dynamicTabOrder[1],
                    1,
                  ),
                  SizedBox(width: screenWidth * 0.10), // Space for FAB
                  _buildNavItem(
                    context,
                    _getTabIcon(3, screenWidth),
                    dynamicTabOrder[3],
                    3,
                  ),
                  _buildNavItem(
                    context,
                    _getTabIcon(4, screenWidth),
                    dynamicTabOrder[4],
                    4,
                  ),
                ],
              ),
              // Home label تحت اللوجو
              Positioned(
                bottom: screenHeight * 0.026,
                child: GestureDetector(
                  onTap: () => widget.onTabSelected(2),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: screenHeight * 0.005),
                      Text(
                        widget.originalTabs[widget.currentIndex],
                        style: TextStyle(
                          color: widget.currentIndex == 2
                              ? AppColors.darkBlue
                              : AppColors.textIntExtFieldAndIconsHome,
                          fontSize: screenWidth * 0.03,
                          fontWeight: widget.currentIndex == 2
                              ? FontWeight.bold
                              : FontWeight.normal,
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
      case 1:
        return widget.icons[1];

      case 3:
        return widget.icons[3];
      case 4:
        return widget.icons[4];
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
              color: AppColors.textIntExtFieldAndIconsHome,
              fontSize: screenWidth * 0.03,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
