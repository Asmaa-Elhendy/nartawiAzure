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

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen>
//     with SingleTickerProviderStateMixin {
//   int _tabIndex = 2;
//   late PageController pageController;
//   final int _tabCount = 5;
//   List<String> originalTabs = [];
//
//   @override
//   void initState() {
//     originalTabs = ['Orders', 'Coupons', 'Home', 'Favourites', 'Profile'];
//     pageController = PageController(initialPage: _tabIndex);
//
//     final screenWidth =
//         WidgetsBinding.instance.window.physicalSize.width /
//         WidgetsBinding.instance.window.devicePixelRatio;
//
//     icons = [
//       Icon(
//         Icons.format_list_numbered,
//         color: AppColors.greyDarktextIntExtFieldAndIconsHome,
//         size: screenWidth * .06,
//       ),
//       Iconify(
//         Mdi.coupon_outline,
//         color: AppColors.greyDarktextIntExtFieldAndIconsHome,
//         size: screenWidth * .06,
//       ),
//       SizedBox(),
//       Iconify(
//         Mdi.heart_outline,
//         color: AppColors.greyDarktextIntExtFieldAndIconsHome,
//         size: screenWidth * .06,
//       ),
//       Iconify(
//         Carbon.user_profile,
//         color: AppColors.greyDarktextIntExtFieldAndIconsHome,
//         size: screenWidth * .06,
//       ),
//     ];
//     logoCenter = Image.asset(
//       "assets/images/onboaring/Logo.png",
//       color: AppColors.whiteColor,
//       width: screenWidth * .12,
//     );
//     onTabTapped(screenWidth,_tabIndex);
//     super.initState();
//   }
//   void onTabTapped(double screenWidth,int index) {
//     log(icons[index].toString());
//     log((myTitle.value == index).toString());
//     //pageController.jumpToPage(index);
//     if (myTitle.value == index) {
//       myTitle.value = 12;
//       setState(() {
//         _tabIndex = 2;
//       });
//
//       // originalTabs=['Orders','Coupons','Home','Favourites','Profile'];
//       icons = [
//         Icon(
//           Icons.format_list_numbered,
//           color: AppColors.greyDarktextIntExtFieldAndIconsHome,
//           size: screenWidth * .06,
//         ),
//         Iconify(
//           Mdi.coupon_outline,
//           color: AppColors.greyDarktextIntExtFieldAndIconsHome,
//           size: screenWidth * .06,
//         ),
//         SizedBox(),
//         Iconify(
//           Mdi.heart_outline,
//           color: AppColors.greyDarktextIntExtFieldAndIconsHome,
//           size: screenWidth * .06,
//         ),
//         Iconify(
//           Carbon.user_profile,
//           color: AppColors.greyDarktextIntExtFieldAndIconsHome,
//           size: screenWidth * .06,
//         ),
//       ];
//       logoCenter = Image.asset(
//         "assets/images/onboaring/Logo.png",
//         color: AppColors.whiteColor,
//         width: screenWidth * .12,
//       );
//     }
//     else {
//       if (index == 2) {
//       } else {
//         setState(() => _tabIndex = index);
//       }
//       log('index is     ' + _tabIndex.toString());
//       if (_tabIndex == 0) {
//         logoCenter = Icon(
//           Icons.format_list_numbered,
//           color: AppColors.whiteColor,
//           size: screenWidth * .06,
//         );
//         icons = [
//           Image.asset(
//             "assets/images/onboaring/Logo.png",
//             color: AppColors.greyDarktextIntExtFieldAndIconsHome,
//             width: screenWidth * .08,
//           ),
//           Iconify(
//             Mdi.coupon_outline,
//             color: AppColors.greyDarktextIntExtFieldAndIconsHome,
//             size: screenWidth * .06,
//           ),
//           SizedBox(),
//           Iconify(
//             Mdi.heart_outline,
//             color: AppColors.greyDarktextIntExtFieldAndIconsHome,
//             size: screenWidth * .06,
//           ),
//           Iconify(
//             Carbon.user_profile,
//             color: AppColors.greyDarktextIntExtFieldAndIconsHome,
//             size: screenWidth * .06,
//           ),
//         ];
//       } else if (_tabIndex == 1) {
//         logoCenter = Iconify(
//           Mdi.coupon_outline,
//           color: AppColors.whiteColor,
//           size: screenWidth * .06,
//         );
//         icons = [
//           Icon(
//             Icons.format_list_numbered,
//             color: AppColors.greyDarktextIntExtFieldAndIconsHome,
//             size: screenWidth * .06,
//           ),
//           Image.asset(
//             "assets/images/onboaring/Logo.png",
//             color: AppColors.greyDarktextIntExtFieldAndIconsHome,
//             width: screenWidth * .08,
//           ),
//           SizedBox(),
//           Iconify(
//             Mdi.heart_outline,
//             color: AppColors.greyDarktextIntExtFieldAndIconsHome,
//             size: screenWidth * .06,
//           ),
//           Iconify(
//             Carbon.user_profile,
//             color: AppColors.greyDarktextIntExtFieldAndIconsHome,
//             size: screenWidth * .06,
//           ),
//         ];
//       } else if (_tabIndex == 3) {
//         logoCenter = Iconify(
//           Mdi.heart_outline,
//           color: AppColors.whiteColor,
//           size: screenWidth * .06,
//         );
//         icons = [
//           Icon(
//             Icons.format_list_numbered,
//             color: AppColors.greyDarktextIntExtFieldAndIconsHome,
//             size: screenWidth * .06,
//           ),
//           Iconify(
//             Mdi.coupon_outline,
//             color: AppColors.greyDarktextIntExtFieldAndIconsHome,
//             size: screenWidth * .06,
//           ),
//           SizedBox(),
//           Image.asset(
//             "assets/images/onboaring/Logo.png",
//             color: AppColors.greyDarktextIntExtFieldAndIconsHome,
//             width: screenWidth * .08,
//           ),
//           Iconify(
//             Carbon.user_profile,
//             color: AppColors.greyDarktextIntExtFieldAndIconsHome,
//             size: screenWidth * .06,
//           ),
//         ];
//       }
//       else if (_tabIndex == 4) {
//         logoCenter = Iconify(
//           Carbon.user_profile,
//           color: AppColors.whiteColor,
//           size: screenWidth * .06,
//         );
//         icons = [
//           Icon(
//             Icons.format_list_numbered,
//             color: AppColors.greyDarktextIntExtFieldAndIconsHome,
//             size: screenWidth * .06,
//           ),
//           Iconify(
//             Mdi.coupon_outline,
//             color: AppColors.greyDarktextIntExtFieldAndIconsHome,
//             size: screenWidth * .06,
//           ),
//           SizedBox(),
//           Iconify(
//             Mdi.heart_outline,
//             color: AppColors.greyDarktextIntExtFieldAndIconsHome,
//             size: screenWidth * .06,
//           ),
//           Image.asset(
//             "assets/images/onboaring/Logo.png",
//             color: AppColors.greyDarktextIntExtFieldAndIconsHome,
//             width: screenWidth * .08,
//           ),
//         ];
//       }
//       //}
//
//       setState(() {});
//     }
//   }
//
//   late Widget logoCenter;
//   late double screenWidth;
//   late List<Widget> icons;
//   @override
//   Widget build(BuildContext context) {
//
//     SystemChrome.setSystemUIOverlayStyle(
//       const SystemUiOverlayStyle(
//         statusBarColor: Colors.transparent,
//         statusBarIconBrightness: Brightness.light,
//       ),
//     );
//
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     void onTabTapped(int index) {
//       log(icons[index].toString());
//       log((myTitle.value == index).toString());
//       //pageController.jumpToPage(index);
//       if (myTitle.value == index) {
//         myTitle.value = 12;
//         setState(() {
//           _tabIndex = 2;
//         });
//
//         // originalTabs=['Orders','Coupons','Home','Favourites','Profile'];
//         icons = [
//           Icon(
//             Icons.format_list_numbered,
//             color: AppColors.greyDarktextIntExtFieldAndIconsHome,
//             size: screenWidth * .06,
//           ),
//           Iconify(
//             Mdi.coupon_outline,
//             color: AppColors.greyDarktextIntExtFieldAndIconsHome,
//             size: screenWidth * .06,
//           ),
//           SizedBox(),
//           Iconify(
//             Mdi.heart_outline,
//             color: AppColors.greyDarktextIntExtFieldAndIconsHome,
//             size: screenWidth * .06,
//           ),
//           Iconify(
//             Carbon.user_profile,
//             color: AppColors.greyDarktextIntExtFieldAndIconsHome,
//             size: screenWidth * .06,
//           ),
//         ];
//         logoCenter = Image.asset(
//           "assets/images/onboaring/Logo.png",
//           color: AppColors.whiteColor,
//           width: screenWidth * .12,
//         );
//       }
//       else {
//         if (index == 2) {
//         } else {
//           setState(() => _tabIndex = index);
//         }
//         log('index is     ' + _tabIndex.toString());
//         if (_tabIndex == 0) {
//           logoCenter = Icon(
//             Icons.format_list_numbered,
//             color: AppColors.whiteColor,
//             size: screenWidth * .06,
//           );
//           icons = [
//             Image.asset(
//               "assets/images/onboaring/Logo.png",
//               color: AppColors.greyDarktextIntExtFieldAndIconsHome,
//               width: screenWidth * .08,
//             ),
//             Iconify(
//               Mdi.coupon_outline,
//               color: AppColors.greyDarktextIntExtFieldAndIconsHome,
//               size: screenWidth * .06,
//             ),
//             SizedBox(),
//             Iconify(
//               Mdi.heart_outline,
//               color: AppColors.greyDarktextIntExtFieldAndIconsHome,
//               size: screenWidth * .06,
//             ),
//             Iconify(
//               Carbon.user_profile,
//               color: AppColors.greyDarktextIntExtFieldAndIconsHome,
//               size: screenWidth * .06,
//             ),
//           ];
//         } else if (_tabIndex == 1) {
//           logoCenter = Iconify(
//             Mdi.coupon_outline,
//             color: AppColors.whiteColor,
//             size: screenWidth * .06,
//           );
//           icons = [
//             Icon(
//               Icons.format_list_numbered,
//               color: AppColors.greyDarktextIntExtFieldAndIconsHome,
//               size: screenWidth * .06,
//             ),
//             Image.asset(
//               "assets/images/onboaring/Logo.png",
//               color: AppColors.greyDarktextIntExtFieldAndIconsHome,
//               width: screenWidth * .08,
//             ),
//             SizedBox(),
//             Iconify(
//               Mdi.heart_outline,
//               color: AppColors.greyDarktextIntExtFieldAndIconsHome,
//               size: screenWidth * .06,
//             ),
//             Iconify(
//               Carbon.user_profile,
//               color: AppColors.greyDarktextIntExtFieldAndIconsHome,
//               size: screenWidth * .06,
//             ),
//           ];
//         } else if (_tabIndex == 3) {
//           logoCenter = Iconify(
//             Mdi.heart_outline,
//             color: AppColors.whiteColor,
//             size: screenWidth * .06,
//           );
//           icons = [
//             Icon(
//               Icons.format_list_numbered,
//               color: AppColors.greyDarktextIntExtFieldAndIconsHome,
//               size: screenWidth * .06,
//             ),
//             Iconify(
//               Mdi.coupon_outline,
//               color: AppColors.greyDarktextIntExtFieldAndIconsHome,
//               size: screenWidth * .06,
//             ),
//             SizedBox(),
//             Image.asset(
//               "assets/images/onboaring/Logo.png",
//               color: AppColors.greyDarktextIntExtFieldAndIconsHome,
//               width: screenWidth * .08,
//             ),
//             Iconify(
//               Carbon.user_profile,
//               color: AppColors.greyDarktextIntExtFieldAndIconsHome,
//               size: screenWidth * .06,
//             ),
//           ];
//         }
//         else if (_tabIndex == 4) {
//           logoCenter = Iconify(
//             Carbon.user_profile,
//             color: AppColors.whiteColor,
//             size: screenWidth * .06,
//           );
//           icons = [
//             Icon(
//               Icons.format_list_numbered,
//               color: AppColors.greyDarktextIntExtFieldAndIconsHome,
//               size: screenWidth * .06,
//             ),
//             Iconify(
//               Mdi.coupon_outline,
//               color: AppColors.greyDarktextIntExtFieldAndIconsHome,
//               size: screenWidth * .06,
//             ),
//             SizedBox(),
//             Iconify(
//               Mdi.heart_outline,
//               color: AppColors.greyDarktextIntExtFieldAndIconsHome,
//               size: screenWidth * .06,
//             ),
//             Image.asset(
//               "assets/images/onboaring/Logo.png",
//               color: AppColors.greyDarktextIntExtFieldAndIconsHome,
//               width: screenWidth * .08,
//             ),
//           ];
//         }
//         //}
//
//         setState(() {});
//       }
//     }
//
//     return Scaffold(
//       extendBody: true,
//
//       // ✅ أضف ده
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       floatingActionButton: Container(
//         width: screenWidth * .123,//edit float action button size
//         height: screenHeight * .064,
//         decoration: BoxDecoration(
//           gradient: AppColors.primaryGradient,
//           shape: BoxShape.rectangle,
//           // أو BoxShape.circle لو عايزه دائري تمامًا
//           borderRadius: const BorderRadius.all(Radius.circular(40)),
//         ),
//         // للتدوير
//         child: BuildFloatActionButton(_tabCount, onTabTapped, logoCenter)
//       ),
//       bottomNavigationBar: CustomBottomNav(
//         currentIndex: _tabIndex,
//         originalTabs: originalTabs,
//         onTabSelected: onTabTapped,
//         icons: icons,
//       ),
//       body: Stack(
//         children: [
//           Container(
//             width: screenWidth,
//             height: screenHeight,
//             color: AppColors.backgrounHome,
//           ),
//           buildBackgroundAppbar(screenWidth),
//           BuildForegroundappbarhome(
//             screenHeight: screenHeight,
//             screenWidth: screenWidth,title: 'NARTAWI',is_returned: false,
//           ),
//           Positioned.fill(
//             top: MediaQuery.of(context).padding.top + screenHeight * .1,
//             child:
//             PageView(
//               controller: pageController,
//
//               children: [
//                 _tabIndex == 0
//                     ? const Center(child: Text("Person Tab"))
//                     : _tabIndex == 1
//                     ? const Center(child: Text("Favorite Tab"))
//                     : _tabIndex == 2
//                     ? const Center(child: MainScreen())
//                     : _tabIndex == 3
//                     ? const Center(child: Text("Face Tab"))
//                     : _tabIndex == 4
//                     ? const Center(child: Text("Balance Tab"))
//                     : SizedBox(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/carbon.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import '../../../../core/theme/colors.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/background_home_Appbar.dart';

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
      Icon(
        Icons.format_list_numbered,
        color: AppColors.greyDarktextIntExtFieldAndIconsHome,
        size: screenWidth * .06,
      ),
      Iconify(
        Mdi.coupon_outline,
        color: AppColors.greyDarktextIntExtFieldAndIconsHome,
        size: screenWidth * .06,
      ),
      const SizedBox(),
      Iconify(
        Mdi.heart_outline,
        color: AppColors.greyDarktextIntExtFieldAndIconsHome,
        size: screenWidth * .06,
      ),
      Iconify(
        Carbon.user_profile,
        color: AppColors.greyDarktextIntExtFieldAndIconsHome,
        size: screenWidth * .06,
      ),
    ];

    logoCenter = Image.asset(
      "assets/images/onboaring/Logo.png",
      color: AppColors.whiteColor,
      width: screenWidth * .12,
    );
  }

  void onTabTapped(int index) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (myTitle.value == index) {
      myTitle.value = 12;
      setState(() {
        _tabIndex = 2;
      });
      _initIconsAndLogo();
    } else {
      if (index != 2) {
        setState(() => _tabIndex = index);
      }

      switch (_tabIndex) {
        case 0:
          logoCenter = Icon(
            Icons.format_list_numbered,
            color: AppColors.whiteColor,
            size: screenWidth * .06,
          );
          icons = [
            Image.asset(
              "assets/images/onboaring/Logo.png",
              color: AppColors.greyDarktextIntExtFieldAndIconsHome,
              width: screenWidth * .08,
            ),
            Iconify(
              Mdi.coupon_outline,
              color: AppColors.greyDarktextIntExtFieldAndIconsHome,
              size: screenWidth * .06,
            ),
            const SizedBox(),
            Iconify(
              Mdi.heart_outline,
              color: AppColors.greyDarktextIntExtFieldAndIconsHome,
              size: screenWidth * .06,
            ),
            Iconify(
              Carbon.user_profile,
              color: AppColors.greyDarktextIntExtFieldAndIconsHome,
              size: screenWidth * .06,
            ),
          ];
          break;
        case 1:
          logoCenter = Iconify(
            Mdi.coupon_outline,
            color: AppColors.whiteColor,
            size: screenWidth * .06,
          );
          icons = [
            Icon(
              Icons.format_list_numbered,
              color: AppColors.greyDarktextIntExtFieldAndIconsHome,
              size: screenWidth * .06,
            ),
            Image.asset(
              "assets/images/onboaring/Logo.png",
              color: AppColors.greyDarktextIntExtFieldAndIconsHome,
              width: screenWidth * .08,
            ),
            const SizedBox(),
            Iconify(
              Mdi.heart_outline,
              color: AppColors.greyDarktextIntExtFieldAndIconsHome,
              size: screenWidth * .06,
            ),
            Iconify(
              Carbon.user_profile,
              color: AppColors.greyDarktextIntExtFieldAndIconsHome,
              size: screenWidth * .06,
            ),
          ];
          break;
        case 3:
          logoCenter = Iconify(
            Mdi.heart_outline,
            color: AppColors.whiteColor,
            size: screenWidth * .06,
          );
          icons = [
            Icon(
              Icons.format_list_numbered,
              color: AppColors.greyDarktextIntExtFieldAndIconsHome,
              size: screenWidth * .06,
            ),
            Iconify(
              Mdi.coupon_outline,
              color: AppColors.greyDarktextIntExtFieldAndIconsHome,
              size: screenWidth * .06,
            ),
            const SizedBox(),
            Image.asset(
              "assets/images/onboaring/Logo.png",
              color: AppColors.greyDarktextIntExtFieldAndIconsHome,
              width: screenWidth * .08,
            ),
            Iconify(
              Carbon.user_profile,
              color: AppColors.greyDarktextIntExtFieldAndIconsHome,
              size: screenWidth * .06,
            ),
          ];
          break;
        case 4:
          logoCenter = Iconify(
            Carbon.user_profile,
            color: AppColors.whiteColor,
            size: screenWidth * .06,
          );
          icons = [
            Icon(
              Icons.format_list_numbered,
              color: AppColors.greyDarktextIntExtFieldAndIconsHome,
              size: screenWidth * .06,
            ),
            Iconify(
              Mdi.coupon_outline,
              color: AppColors.greyDarktextIntExtFieldAndIconsHome,
              size: screenWidth * .06,
            ),
            const SizedBox(),
            Iconify(
              Mdi.heart_outline,
              color: AppColors.greyDarktextIntExtFieldAndIconsHome,
              size: screenWidth * .06,
            ),
            Image.asset(
              "assets/images/onboaring/Logo.png",
              color: AppColors.greyDarktextIntExtFieldAndIconsHome,
              width: screenWidth * .08,
            ),
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
            page = const Center(child: Text("Person Tab"));
            break;
          case 1:
            page = const Center(child: Text("Favorite Tab"));
            break;
          case 2:
            page = const MainScreen();
            break;
          case 3:
            page = const Center(child: Text("Face Tab"));
            break;
          case 4:
            page = const Center(child: Text("Balance Tab"));
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

    return Scaffold(
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        width: screenWidth * .123,
        height: screenHeight * .064,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          shape: BoxShape.rectangle,
          borderRadius: const BorderRadius.all(Radius.circular(40)),
        ),
        child: BuildFloatActionButton(_tabCount, onTabTapped, logoCenter),
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
    );
  }
}
