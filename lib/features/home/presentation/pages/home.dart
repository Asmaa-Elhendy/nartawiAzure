import 'dart:developer';
import 'dart:ui' as Svg;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/carbon.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:newwwwwwww/features/auth/presentation/widgets/buildFloadtActionButton.dart';
import 'package:newwwwwwww/features/orders/presentation/pages/orders_screen.dart';
import '../../../../core/theme/colors.dart';
import '../../../coupons/presentation/screens/coupons_screen.dart';
import '../../../favourites/pesentation/screens/favourites_screen.dart';
import '../../../profile/presentation/pages/profile.dart';
import '../widgets/bottom_navigation_bar.dart';


import 'mainscreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _tabIndex = 2;
  late List<String> originalTabs;
  late List<Widget> icons;
  late Widget logoCenter;
  final int _tabCount = 5;
  late PageController pageController;

  // مفاتيح لكل Navigator
  final List<GlobalKey<NavigatorState>> _navigatorKeys = List.generate(
    5,
        (index) => GlobalKey<NavigatorState>(),
  );

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: _tabIndex);
    originalTabs = ['Orders', 'Coupons', 'Home', 'Favourites', 'Profile'];
    _initIconsAndLogo();
  }

  void _initIconsAndLogo() {
    final screenWidth = WidgetsBinding.instance.window.physicalSize.width /
        WidgetsBinding.instance.window.devicePixelRatio;

    icons = [
      SvgPicture.asset("assets/images/navigation_bar/orderIcon.svg", color: AppColors.greyDarktextIntExtFieldAndIconsHome,),

      // Icon(
      //   Icons.format_list_numbered,
      //   color: AppColors.greyDarktextIntExtFieldAndIconsHome,
      //   size: screenWidth * .06,
      // ),
      // Iconify(
      //   Mdi.coupon_outline,
      //   color: AppColors.greyDarktextIntExtFieldAndIconsHome,
      //   size: screenWidth * .06,
      // ),
      SvgPicture.asset("assets/images/navigation_bar/couponsvg.svg", color: AppColors.greyDarktextIntExtFieldAndIconsHome,),

      const SizedBox(),
      // Iconify(
      //   Mdi.heart_outline,
      //   color: AppColors.greyDarktextIntExtFieldAndIconsHome,
      //   size: screenWidth * .06,
      // ),
      SvgPicture.asset("assets/images/navigation_bar/heart_navigation_bar.svg", color: AppColors.greyDarktextIntExtFieldAndIconsHome,),


      // Iconify(
      //   Carbon.user_profile,
      //   color: AppColors.greyDarktextIntExtFieldAndIconsHome,
      //   size: screenWidth * .06,
      // ),
      SvgPicture.asset("assets/images/navigation_bar/user-profile_navigation_bar.svg", color: AppColors.greyDarktextIntExtFieldAndIconsHome,),

    ];

    logoCenter =
    //     Image.asset(
    //   "assets/images/onboaring/Logo.png",
    //   color: AppColors.whiteColor,
    //   width: screenWidth * .12,//k
    // );
    SvgPicture.asset("assets/images/navigation_bar/Logosvg.svg", color: AppColors.whiteColor,width: screenWidth*.12,);

  }

  void onTabTapped(int index) {
    final screenWidth = MediaQuery.of(context).size.width;

     if (myTitle.value == index) {
      myTitle.value = 12;
      setState(() {
        _tabIndex = 2;
      });
      _initIconsAndLogo();
    }

    else {
      if (index != 2) {
        setState(() => _tabIndex = index);

      }

      switch (_tabIndex) {
        case 0:
          logoCenter =
          //     Icon(
          //   Icons.format_list_numbered,
          //   color: AppColors.whiteColor,
          //   size: screenWidth * .06,
          // );
      SvgPicture.asset("assets/images/navigation_bar/orderIcon.svg", color: AppColors.whiteColor,);

      icons = [
            // Image.asset(
            //   "assets/images/onboaring/Logo.png",
            //   color: AppColors.greyDarktextIntExtFieldAndIconsHome,
            //   width: screenWidth * .06,
            // ),
        SvgPicture.asset("assets/images/navigation_bar/Logosvg.svg", color: AppColors.greyDarktextIntExtFieldAndIconsHome,),

        // Iconify(
            //   Mdi.coupon_outline,
            //   color: AppColors.greyDarktextIntExtFieldAndIconsHome,
            //   size: screenWidth * .06,
            // ),
            SvgPicture.asset("assets/images/navigation_bar/couponsvg.svg", color: AppColors.greyDarktextIntExtFieldAndIconsHome,),

            const SizedBox(),
            // Iconify(
            //   Mdi.heart_outline,
            //   color: AppColors.greyDarktextIntExtFieldAndIconsHome,
            //   size: screenWidth * .06,
            // ),
        SvgPicture.asset("assets/images/navigation_bar/heart_navigation_bar.svg", color: AppColors.greyDarktextIntExtFieldAndIconsHome,),

        // Iconify(
        //       Carbon.user_profile,
        //       color: AppColors.greyDarktextIntExtFieldAndIconsHome,
        //       size: screenWidth * .06,
        //     ),
        SvgPicture.asset("assets/images/navigation_bar/user-profile_navigation_bar.svg", color: AppColors.greyDarktextIntExtFieldAndIconsHome,),

      ];
          break;
        case 1:
          logoCenter =
          //     Iconify(
          //   Mdi.coupon_outline,
          //   color: AppColors.whiteColor,
          //   size: screenWidth * .06,
          // );
          SvgPicture.asset("assets/images/navigation_bar/couponsvg.svg", color: AppColors.whiteColor,);

      icons = [
            // Icon(
            //   Icons.format_list_numbered,
            //   color: AppColors.greyDarktextIntExtFieldAndIconsHome,
            //   size: screenWidth * .06,
            // ),
        SvgPicture.asset("assets/images/navigation_bar/orderIcon.svg", color: AppColors.greyDarktextIntExtFieldAndIconsHome,),
            // Image.asset(
            //   "assets/images/onboaring/Logo.png",
            //   color: AppColors.greyDarktextIntExtFieldAndIconsHome,
            //   width: screenWidth * .06,
            // ),
        SvgPicture.asset("assets/images/navigation_bar/Logosvg.svg", color: AppColors.greyDarktextIntExtFieldAndIconsHome,),

        const SizedBox(),
            // Iconify(
            //   Mdi.heart_outline,
            //   color: AppColors.greyDarktextIntExtFieldAndIconsHome,
            //   size: screenWidth * .06,
            // ),
        SvgPicture.asset("assets/images/navigation_bar/heart_navigation_bar.svg", color: AppColors.greyDarktextIntExtFieldAndIconsHome,),

        // Iconify(
        //       Carbon.user_profile,
        //       color: AppColors.greyDarktextIntExtFieldAndIconsHome,
        //       size: screenWidth * .06,
        //     ),
        SvgPicture.asset("assets/images/navigation_bar/user-profile_navigation_bar.svg", color: AppColors.greyDarktextIntExtFieldAndIconsHome,),

      ];
          break;
        case 3:
          logoCenter =
          //     Iconify(
          //   Mdi.heart_outline,
          //   color: AppColors.whiteColor,
          //   size: screenWidth * .06,
          // );
      SvgPicture.asset("assets/images/navigation_bar/heart_navigation_bar.svg", color: AppColors.whiteColor,);

      icons = [
            // Icon(
            //   Icons.format_list_numbered,
            //   color: AppColors.greyDarktextIntExtFieldAndIconsHome,
            //   size: screenWidth * .06,
            // ),
            SvgPicture.asset("assets/images/navigation_bar/orderIcon.svg", color: AppColors.greyDarktextIntExtFieldAndIconsHome,),
            // Iconify(
            //   Mdi.coupon_outline,
            //   color: AppColors.greyDarktextIntExtFieldAndIconsHome,
            //   size: screenWidth * .06,
            // ),
      SvgPicture.asset("assets/images/navigation_bar/couponsvg.svg", color: AppColors.greyDarktextIntExtFieldAndIconsHome,),

      const SizedBox(),
            // Image.asset(
            //   "assets/images/onboaring/Logo.png",
            //   color: AppColors.greyDarktextIntExtFieldAndIconsHome,
            //   width: screenWidth * .06,
            // ),
        SvgPicture.asset("assets/images/navigation_bar/Logosvg.svg", color: AppColors.greyDarktextIntExtFieldAndIconsHome,),

        // Iconify(
            //   Carbon.user_profile,
            //   color: AppColors.greyDarktextIntExtFieldAndIconsHome,
            //   size: screenWidth * .06,
            // ),
        SvgPicture.asset("assets/images/navigation_bar/user-profile_navigation_bar.svg", color: AppColors.greyDarktextIntExtFieldAndIconsHome,),

      ];
          break;
        case 4:
          logoCenter =
          //     Iconify(
          //   Carbon.user_profile,
          //   color: AppColors.whiteColor,
          //   size: screenWidth * .06,
          // );
      SvgPicture.asset("assets/images/navigation_bar/user-profile_navigation_bar.svg", color: AppColors.whiteColor,);

      icons = [
            // Icon(
            //   Icons.format_list_numbered,
            //   color: AppColors.greyDarktextIntExtFieldAndIconsHome,
            //   size: screenWidth * .06,
            // ),
            SvgPicture.asset("assets/images/navigation_bar/orderIcon.svg", color: AppColors.greyDarktextIntExtFieldAndIconsHome,),
            // Iconify(
            //   Mdi.coupon_outline,
            //   color: AppColors.greyDarktextIntExtFieldAndIconsHome,
            //   size: screenWidth * .06,
            // ),
            SvgPicture.asset("assets/images/navigation_bar/couponsvg.svg", color: AppColors.greyDarktextIntExtFieldAndIconsHome,),

      const SizedBox(),
            // Iconify(
            //   Mdi.heart_outline,
            //   color: AppColors.greyDarktextIntExtFieldAndIconsHome,
            //   size: screenWidth * .06,
            // ),
            SvgPicture.asset("assets/images/navigation_bar/heart_navigation_bar.svg", color: AppColors.greyDarktextIntExtFieldAndIconsHome,),

            // Image.asset(
            //   "assets/images/onboaring/Logo.png",
            //   color: AppColors.greyDarktextIntExtFieldAndIconsHome,
            //   width: screenWidth * .06,
            // ),
        SvgPicture.asset("assets/images/navigation_bar/Logosvg.svg", color: AppColors.greyDarktextIntExtFieldAndIconsHome,),

      ];
          break;
        default:
          _initIconsAndLogo();
      }
      setState(() {});
    }
  }

  // صفحة لكل تاب بداخل Nested Navigator
  Widget _buildTabNavigator(int index) {
    return Navigator(
      key: _navigatorKeys[index],
      onGenerateRoute: (RouteSettings settings) {
        Widget page;
        switch (index) {
          case 0:
            page = const OrdersScreen();
            break;
          case 1:
            page =  CouponsScreen();
            break;
          case 2:
            page = const MainScreen();
            break;
          case 3:
            page = const FavouritesScreen();
            break;
          case 4:
            page = const ProfileScreen();
            break;
          default:
            page = const SizedBox();
        }
        return MaterialPageRoute(builder: (_) => page, settings: settings);
      },
    );
  }

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

    return GestureDetector(
      onTap:  ()=> FocusScope.of(context).unfocus(),
      child: Scaffold(
        extendBody: true,
        resizeToAvoidBottomInset: false, // 👈 الكيبورد مش هيأثر على FAB
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          width:screenWidth*.14,// screenWidth * .123,
          height: screenWidth*.14,//screenHeight * .064,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            shape: BoxShape.rectangle,
            borderRadius: const BorderRadius.all(Radius.circular(40)),
          ),
          child: BuildFloatActionButton(_tabIndex, logoCenter,_navigatorKeys),
        ),
        bottomNavigationBar: CustomBottomNav(
          currentIndex: _tabIndex,
          originalTabs: originalTabs,
          onTabSelected: onTabTapped,
          icons: icons,
        ),
        body:
        // Stack(
        //   children: [
        //     Container(
        //       width: screenWidth,
        //       height: screenHeight,
        //       color: AppColors.backgrounHome,
        //     ),
        //     buildBackgroundAppbar(screenWidth),
        //     BuildForegroundappbarhome(
        //       screenHeight: screenHeight,
        //       screenWidth: screenWidth,
        //       title: 'NARTAWI',
        //       is_returned: false,
        //     ),
        //     Positioned.fill(
        //       top: MediaQuery.of(context).padding.top + screenHeight * .1,
        //       child:
        IndexedStack(
          index: _tabIndex,
          children: List.generate(_tabCount, (index) => _buildTabNavigator(index)),
        ),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}