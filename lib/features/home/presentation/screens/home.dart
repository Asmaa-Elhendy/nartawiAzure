import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/carbon.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:newwwwwwww/features/auth/presentation/widgets/buildFloadtActionButton.dart';
import 'package:newwwwwwww/features/home/presentation/screens/mainscreen.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/background_home_Appbar.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/build_ForegroundAppBarHome.dart';
import '../../../../core/theme/colors.dart';
import '../widgets/bottom_navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _tabIndex = 2;
  late PageController pageController;
  final int _tabCount = 5;
  List<String> originalTabs = [];

  @override
  void initState() {
    originalTabs = ['Orders', 'Coupons', 'Home', 'Favourites', 'Profile'];
    pageController = PageController(initialPage: _tabIndex);

    final screenWidth =
        WidgetsBinding.instance.window.physicalSize.width /
        WidgetsBinding.instance.window.devicePixelRatio;

    icons = [
      Icon(
        Icons.format_list_numbered,
        color: AppColors.textIntExtFieldAndIconsHome,
        size: screenWidth * .06,
      ),
      Iconify(
        Mdi.coupon_outline,
        color: AppColors.textIntExtFieldAndIconsHome,
        size: screenWidth * .06,
      ),
      SizedBox(),
      Iconify(
        Mdi.heart_outline,
        color: AppColors.textIntExtFieldAndIconsHome,
        size: screenWidth * .06,
      ),
      Iconify(
        Carbon.user_profile,
        color: AppColors.textIntExtFieldAndIconsHome,
        size: screenWidth * .06,
      ),
    ];
    logoCenter = Image.asset(
      "assets/images/onboaring/Logo.png",
      color: AppColors.whiteColor,
      width: screenWidth * .12,
    );

    super.initState();
  }

  late Widget logoCenter;
  late double screenWidth;
  late List<Widget> icons;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    void onTabTapped(int index) {
      log(icons[index].toString());
      log((myTitle.value == index).toString());
      //pageController.jumpToPage(index);
      if (myTitle.value == index) {
        myTitle.value = 12;
        setState(() {
          _tabIndex = 2;
        });

        // originalTabs=['Orders','Coupons','Home','Favourites','Profile'];
        icons = [
          Icon(
            Icons.format_list_numbered,
            color: AppColors.textIntExtFieldAndIconsHome,
            size: screenWidth * .06,
          ),
          Iconify(
            Mdi.coupon_outline,
            color: AppColors.textIntExtFieldAndIconsHome,
            size: screenWidth * .06,
          ),
          SizedBox(),
          Iconify(
            Mdi.heart_outline,
            color: AppColors.textIntExtFieldAndIconsHome,
            size: screenWidth * .06,
          ),
          Iconify(
            Carbon.user_profile,
            color: AppColors.textIntExtFieldAndIconsHome,
            size: screenWidth * .06,
          ),
        ];
        logoCenter = Image.asset(
          "assets/images/onboaring/Logo.png",
          color: AppColors.whiteColor,
          width: screenWidth * .12,
        );
      }
      else {
        if (index == 2) {
        } else {
          setState(() => _tabIndex = index);
        }
        log('index is     ' + _tabIndex.toString());
        if (_tabIndex == 0) {
          logoCenter = Icon(
            Icons.format_list_numbered,
            color: AppColors.whiteColor,
            size: screenWidth * .06,
          );
          icons = [
            Image.asset(
              "assets/images/onboaring/Logo.png",
              color: AppColors.textIntExtFieldAndIconsHome,
              width: screenWidth * .08,
            ),
            Iconify(
              Mdi.coupon_outline,
              color: AppColors.textIntExtFieldAndIconsHome,
              size: screenWidth * .06,
            ),
            SizedBox(),
            Iconify(
              Mdi.heart_outline,
              color: AppColors.textIntExtFieldAndIconsHome,
              size: screenWidth * .06,
            ),
            Iconify(
              Carbon.user_profile,
              color: AppColors.textIntExtFieldAndIconsHome,
              size: screenWidth * .06,
            ),
          ];
        } else if (_tabIndex == 1) {
          logoCenter = Iconify(
            Mdi.coupon_outline,
            color: AppColors.whiteColor,
            size: screenWidth * .06,
          );
          icons = [
            Icon(
              Icons.format_list_numbered,
              color: AppColors.textIntExtFieldAndIconsHome,
              size: screenWidth * .06,
            ),
            Image.asset(
              "assets/images/onboaring/Logo.png",
              color: AppColors.textIntExtFieldAndIconsHome,
              width: screenWidth * .08,
            ),
            SizedBox(),
            Iconify(
              Mdi.heart_outline,
              color: AppColors.textIntExtFieldAndIconsHome,
              size: screenWidth * .06,
            ),
            Iconify(
              Carbon.user_profile,
              color: AppColors.textIntExtFieldAndIconsHome,
              size: screenWidth * .06,
            ),
          ];
        } else if (_tabIndex == 3) {
          logoCenter = Iconify(
            Mdi.heart_outline,
            color: AppColors.whiteColor,
            size: screenWidth * .06,
          );
          icons = [
            Icon(
              Icons.format_list_numbered,
              color: AppColors.textIntExtFieldAndIconsHome,
              size: screenWidth * .06,
            ),
            Iconify(
              Mdi.coupon_outline,
              color: AppColors.textIntExtFieldAndIconsHome,
              size: screenWidth * .06,
            ),
            SizedBox(),
            Image.asset(
              "assets/images/onboaring/Logo.png",
              color: AppColors.textIntExtFieldAndIconsHome,
              width: screenWidth * .08,
            ),
            Iconify(
              Carbon.user_profile,
              color: AppColors.textIntExtFieldAndIconsHome,
              size: screenWidth * .06,
            ),
          ];
        }
        else if (_tabIndex == 4) {
          logoCenter = Iconify(
            Carbon.user_profile,
            color: AppColors.whiteColor,
            size: screenWidth * .06,
          );
          icons = [
            Icon(
              Icons.format_list_numbered,
              color: AppColors.textIntExtFieldAndIconsHome,
              size: screenWidth * .06,
            ),
            Iconify(
              Mdi.coupon_outline,
              color: AppColors.textIntExtFieldAndIconsHome,
              size: screenWidth * .06,
            ),
            SizedBox(),
            Iconify(
              Mdi.heart_outline,
              color: AppColors.textIntExtFieldAndIconsHome,
              size: screenWidth * .06,
            ),
            Image.asset(
              "assets/images/onboaring/Logo.png",
              color: AppColors.textIntExtFieldAndIconsHome,
              width: screenWidth * .08,
            ),
          ];
        }
        //}

        setState(() {});
      }
    }

    return Scaffold(
      extendBody: true,
      // ✅ أضف ده
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        width: screenWidth * .13,
        height: screenHeight * .07,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          shape: BoxShape.rectangle,
          // أو BoxShape.circle لو عايزه دائري تمامًا
          borderRadius: const BorderRadius.all(Radius.circular(40)),
        ),
        // للتدوير
        child: BuildFloatActionButton(_tabCount, onTabTapped, logoCenter)
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _tabIndex,
        originalTabs: originalTabs,
        onTabSelected: onTabTapped,
        icons: icons,
      ),
      body: Stack(
        children: [
          Container(
            width: screenWidth,
            height: screenHeight,
            color: AppColors.backgrounHome,
          ),
          buildBackgroundAppbar(screenWidth),
          BuildForegroundappbarhome(
            screenHeight: screenHeight,
            screenWidth: screenWidth,
          ),
          Positioned.fill(
            top: MediaQuery.of(context).padding.top + screenHeight * .1,
            child: PageView(
              controller: pageController,

              children: [
                _tabIndex == 0
                    ? const Center(child: Text("Person Tab"))
                    : _tabIndex == 1
                    ? const Center(child: Text("Favorite Tab"))
                    : _tabIndex == 2
                    ? const Center(child: MainScreen())
                    : _tabIndex == 3
                    ? const Center(child: Text("Face Tab"))
                    : _tabIndex == 4
                    ? const Center(child: Text("Balance Tab"))
                    : SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
