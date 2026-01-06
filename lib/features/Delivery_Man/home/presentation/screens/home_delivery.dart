import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newwwwwwww/features/auth/presentation/widgets/buildFloadtActionButton.dart';
import 'package:newwwwwwww/features/orders/presentation/pages/orders_screen.dart';
import 'package:newwwwwwww/features/profile/presentation/pages/my_ewallet_screen.dart';
import '../../../../../../core/theme/colors.dart';
import '../../../../home/presentation/pages/mainscreen.dart';
import '../../../../profile/presentation/pages/profile.dart';
import '../../../history/presentation/screens/history_delivery.dart';
import '../../../orders/presentation/screens/assigned_orders_screen.dart';
import '../../../profile/presentation/screens/delivery_profile.dart';
import '../widgets/custom_navigation_bar_delivery.dart';



class MainScreenDelivery extends StatefulWidget {
  const MainScreenDelivery({super.key});

  @override
  State<MainScreenDelivery> createState() => _MainScreenDeliveryState();
}

class _MainScreenDeliveryState extends State<MainScreenDelivery> with SingleTickerProviderStateMixin {
  int _tabIndex = 1;
  late List<String> originalTabs;
  late List<Widget> icons;
  late Widget logoCenter;
  final int _tabCount = 3;
  late PageController pageController;

  // مفاتيح لكل Navigator
  final List<GlobalKey<NavigatorState>> _navigatorKeys = List.generate(
    3,
        (index) => GlobalKey<NavigatorState>(),
  );

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: _tabIndex);
    originalTabs = ['History','Orders', 'Profile'];
    _initIconsAndLogo();
  }

  void _initIconsAndLogo() {
    final screenWidth = WidgetsBinding.instance.window.physicalSize.width /
        WidgetsBinding.instance.window.devicePixelRatio;

    icons = [
      SvgPicture.asset("assets/images/navigation_bar/work_history.svg", color: AppColors.greyDarktextIntExtFieldAndIconsHome,),



      const SizedBox(),



      SvgPicture.asset("assets/images/navigation_bar/user-profile_navigation_bar.svg", color: AppColors.greyDarktextIntExtFieldAndIconsHome,),

    ];

    logoCenter =

    SvgPicture.asset("assets/images/navigation_bar/orderIcon.svg", color: AppColors.whiteColor,);

  }

  void onTabTapped(int index) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (myTitleDelivery.value == index) {
      myTitleDelivery.value = 12;
      setState(() {
        _tabIndex = 1;
      });
      _initIconsAndLogo();
    }

    else {
      if (index != 1) {
        setState(() => _tabIndex = index);

      }

      switch (_tabIndex) {
        case 0:
          logoCenter =
          SvgPicture.asset("assets/images/navigation_bar/work_history.svg", color: AppColors.whiteColor,);

          icons = [

            SvgPicture.asset("assets/images/navigation_bar/orderIcon.svg", color: AppColors.greyDarktextIntExtFieldAndIconsHome,),


            const SizedBox(),


            SvgPicture.asset("assets/images/navigation_bar/user-profile_navigation_bar.svg", color: AppColors.greyDarktextIntExtFieldAndIconsHome,),

          ];
          break;


        case 2:
          logoCenter =

          SvgPicture.asset("assets/images/navigation_bar/user-profile_navigation_bar.svg", color: AppColors.whiteColor,);

          icons = [

            SvgPicture.asset("assets/images/navigation_bar/work_history.svg", color: AppColors.greyDarktextIntExtFieldAndIconsHome,),


            const SizedBox(),


            SvgPicture.asset("assets/images/navigation_bar/orderIcon.svg", color: AppColors.greyDarktextIntExtFieldAndIconsHome,),

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
            page = const HistoryDelivery();
            break;

          case 1:
            page = const AssignedOrderedScreen();
            break;

          case 2:
            page = const DeliveryProfile();
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
        bottomNavigationBar: CustomBottomNavDelivery(
          currentIndex: _tabIndex,
          originalTabs: originalTabs,
          onTabSelected: onTabTapped,
          icons: icons,
        ),
        body:

        IndexedStack(
          index: _tabIndex,
          children: List.generate(_tabCount, (index) => _buildTabNavigator(index)),
        ),


      ),
    );
  }
}