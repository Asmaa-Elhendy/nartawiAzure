  
  import 'dart:developer';
  import 'package:flutter/material.dart';
  import 'package:flutter/services.dart';
  import 'package:flutter_svg/flutter_svg.dart';
  import 'package:iconify_flutter/iconify_flutter.dart';
  import 'package:iconify_flutter/icons/carbon.dart';
  import 'package:iconify_flutter/icons/game_icons.dart';
  import 'package:iconify_flutter/icons/mdi.dart';
  
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
    List<String> originalTabs=[];
    @override
    void initState() {
       originalTabs=['Orders','Coupons','Home','Favourites','Profile'];
      pageController = PageController(initialPage: _tabIndex);
  
      final screenWidth = WidgetsBinding.instance.window.physicalSize.width /
          WidgetsBinding.instance.window.devicePixelRatio;
  
      icons = [
        Icon(Icons.format_list_numbered,
            color: AppColors.textIntExtFieldAndIconsHome,
            size: screenWidth * .06),
        Iconify(
          Mdi.coupon_outline,
          color: AppColors.textIntExtFieldAndIconsHome,
          size: screenWidth * .06,
        ),SizedBox(),
        Iconify(
          Mdi.heart_outline,
          color: AppColors.textIntExtFieldAndIconsHome,
          size: screenWidth * .06,
        ),
        Iconify(
          Carbon.user_profile,
          color: AppColors.textIntExtFieldAndIconsHome,
          size: screenWidth * .06,
        )
      ];
      logoCenter=Image.asset(
        "assets/images/onboaring/Logo.png", color: AppColors.whiteColor,
        width: screenWidth * .12,);
  
      super.initState();
    }
  
    // void onPageChanged(int index) {
    //   setState(() => _tabIndex = index);
    // }
  
    late Widget logoCenter;
    late double screenWidth;
    late List<Widget> icons;
  
    @override
    Widget build(BuildContext context) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ));
  
      final screenHeight = MediaQuery
          .of(context)
          .size
          .height;
      final screenWidth = MediaQuery
          .of(context)
          .size
          .width;


      void onTabTapped(int index) {
        log(icons[index].toString());log((myTitle.value==  index).toString());
        //pageController.jumpToPage(index);
        if(myTitle.value==  index){
          myTitle.value=12;
          setState(() {
            _tabIndex=2;
          });

        // originalTabs=['Orders','Coupons','Home','Favourites','Profile'];
         icons = [
           Icon(Icons.format_list_numbered,
               color: AppColors.textIntExtFieldAndIconsHome,
               size: screenWidth * .06),
           Iconify(
             Mdi.coupon_outline,
             color: AppColors.textIntExtFieldAndIconsHome,
             size: screenWidth * .06,
           ),SizedBox(),
           Iconify(
             Mdi.heart_outline,
             color: AppColors.textIntExtFieldAndIconsHome,
             size: screenWidth * .06,
           ),
           Iconify(
             Carbon.user_profile,
             color: AppColors.textIntExtFieldAndIconsHome,
             size: screenWidth * .06,
           )
         ];
         logoCenter=Image.asset(
           "assets/images/onboaring/Logo.png", color: AppColors.whiteColor,
           width: screenWidth * .12,);

        }
        else{
          if(index==2){

        }else{
          setState(() => _tabIndex = index);
        }
        log('index is     '+_tabIndex.toString());
        if(_tabIndex==0){
          logoCenter=Icon(Icons.format_list_numbered,
              color: AppColors.whiteColor,
              size: screenWidth * .06);
          icons = [
            Image.asset(
              "assets/images/onboaring/Logo.png", color: AppColors.textIntExtFieldAndIconsHome,
              width: screenWidth * .08,),
            Iconify(
              Mdi.coupon_outline,
              color: AppColors.textIntExtFieldAndIconsHome,
              size: screenWidth * .06,
            ),SizedBox(),
            Iconify(
              Mdi.heart_outline,
              color: AppColors.textIntExtFieldAndIconsHome,
              size: screenWidth * .06,
            ),
            Iconify(
              Carbon.user_profile,
              color: AppColors.textIntExtFieldAndIconsHome,
              size: screenWidth * .06,
            )
          ];
        }
        else if (_tabIndex==1){
          logoCenter=Iconify(
            Mdi.coupon_outline,
            color: AppColors.whiteColor,
            size: screenWidth * .06,
          );
          icons = [
            Icon(Icons.format_list_numbered,
                color: AppColors.textIntExtFieldAndIconsHome,
                size: screenWidth * .06),
            Image.asset(
              "assets/images/onboaring/Logo.png", color: AppColors.textIntExtFieldAndIconsHome,
              width: screenWidth * .08,),
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
            )
          ];
        }
        else if (_tabIndex==3){
          logoCenter= Iconify(
            Mdi.heart_outline,
            color: AppColors.whiteColor,
            size: screenWidth * .06,
          );
          icons = [
            Icon(Icons.format_list_numbered,
                color: AppColors.textIntExtFieldAndIconsHome,
                size: screenWidth * .06),
            Iconify(
              Mdi.coupon_outline,
              color: AppColors.textIntExtFieldAndIconsHome,
              size: screenWidth * .06,
            ),SizedBox(),
            Image.asset(
              "assets/images/onboaring/Logo.png", color: AppColors.textIntExtFieldAndIconsHome,
              width: screenWidth * .08,),
            Iconify(
              Carbon.user_profile,
              color: AppColors.textIntExtFieldAndIconsHome,
              size: screenWidth * .06,
            )
          ];
        }
        else if (_tabIndex==4){
          logoCenter=  Iconify(
            Carbon.user_profile,
            color: AppColors.whiteColor,
            size: screenWidth * .06,
          );
          icons = [
            Icon(Icons.format_list_numbered,
                color: AppColors.textIntExtFieldAndIconsHome,
                size: screenWidth * .06),
            Iconify(
              Mdi.coupon_outline,
              color: AppColors.textIntExtFieldAndIconsHome,
              size: screenWidth * .06,
            ),SizedBox(),
            Iconify(
              Mdi.heart_outline,
              color: AppColors.textIntExtFieldAndIconsHome,
              size: screenWidth * .06,
            ),
            Image.asset(
              "assets/images/onboaring/Logo.png", color: AppColors.textIntExtFieldAndIconsHome,
              width: screenWidth * .08,),
          ];
        }
        //}
  
        setState(() {
  
        });
  
      }}
      // bool notsELECTED=false;
      // List<Widget> updatedIcons=[];
  
  
      // List<Widget> icons = [
      //   Icon(Icons.format_list_numbered,
      //       color:AppColors.textIntExtFieldAndIconsHome,
      //       size: screenWidth * .06),
      //   Iconify(
      //     Mdi.coupon_outline,
      //     color:AppColors.textIntExtFieldAndIconsHome,
      //     size: screenWidth * .06,
      //   ),
      //   // Image.asset(
      //   //   "assets/images/onboaring/Logo.png", color: AppColors.whiteColor,
      //   //   width: screenWidth * .12,),
      //   Iconify(
      //     Mdi.heart_outline,
      //     color:AppColors.textIntExtFieldAndIconsHome,
      //     size: screenWidth * .06,
      //   ),
      //   Iconify(
      //     Carbon.user_profile,
      //     color:AppColors.textIntExtFieldAndIconsHome,
      //     size: screenWidth * .06,
      //   )
      // ];
      // if(updatedIcons.length>0){
      //   if( updatedIcons[2]==Image.asset(
      //     "assets/images/onboaring/Logo.png", color: notsELECTED?AppColors.whiteColor:AppColors.textIntExtFieldAndIconsHome,
      //     width: screenWidth * .12,)){
      //     notsELECTED=true;
      //   }
      //
      //   else{
      //     notsELECTED=false;
      //   }}
      // setState(() {
      //
      // });
  // أولاً، انسخي قائمة icons الأصلية
  //      updatedIcons = List.from(icons);
  //
  // // لو التاب مش هو Home (اللي في النص)
  //     if (_tabIndex == 2) {
  // // اللوجو يظهر مكان التاب اللي ضغطنا عليه
  //
  //
  // // والأيقونة دي تروح مكان اللوجو
  //       updatedIcons[2] = icons[_tabIndex];
  //       updatedIcons[_tabIndex]=Image.asset(
  //         "assets/images/onboaring/Logo.png",
  //         color: AppColors.whiteColor,
  //         width: screenWidth * .12,
  //       );
  //       log(updatedIcons[2].toString());
  //     }
  //
  // // أخيرًا خزّن القائمة في متغير جديد ثابت
  //     List<Widget> dynamicTabIcons = updatedIcons;
  //
  
      return Scaffold(
        extendBody: true,
        // ✅ أضف ده
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          width: screenWidth * .13,
          height: screenHeight * .07,
          decoration:
          BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.rectangle,
              // أو BoxShape.circle لو عايزه دائري تمامًا
              borderRadius: const BorderRadius.all(Radius.circular(40))),
          // للتدوير
          child: FloatingActionButton( //backgroundColor: AppColors.primary,
            backgroundColor: Colors.transparent,
            elevation: 0,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(40))),
            onPressed: () {
              final middleTab = (_tabCount / 2).floor(); // 🧠 احسبي النص
              onTabTapped(middleTab);
            },
            child: logoCenter,)),
        bottomNavigationBar: CustomBottomNav(
          currentIndex: _tabIndex,originalTabs: originalTabs,
          onTabSelected: onTabTapped,icons: icons,
  
        ),
        body: Stack(
          children: [
            Container(width: screenWidth,
                height: screenHeight,
                color: AppColors.backgrounHome),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SvgPicture.asset(
                "assets/images/home/rec.svg",
                width: screenWidth,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
            Positioned(
              top: MediaQuery
                  .of(context)
                  .padding
                  .top + screenHeight * .05,
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
                    width: screenWidth * .45,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Iconify(GameIcons.water_gallon,
                            size: screenWidth * .06, color: AppColors.whiteColor),
                        Icon(Icons.notifications,
                            color: AppColors.whiteColor, size: screenWidth * .06),
                        Icon(Icons.shopping_cart_outlined,
                            color: AppColors.whiteColor, size: screenWidth * .06),
                        SvgPicture.asset("assets/images/home/Language.svg",
                            width: screenWidth * .06),
                        SvgPicture.asset("assets/images/home/headphone.svg",
                            width: screenWidth * .06),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned.fill(
              top: MediaQuery
                  .of(context)
                  .padding
                  .top + screenHeight * .1,
              child: PageView(
                controller: pageController,
  
                children: [
               _tabIndex==0?   const Center(child: Text("Person Tab")):
                  _tabIndex==1?     const Center(child: Text("Favorite Tab")):
                  _tabIndex==2?    const Center(child: Text("Home Tab")):
                  _tabIndex==3?    const Center(child: Text("Face Tab")):
                  _tabIndex==4?     const Center(child: Text("Balance Tab")):SizedBox()
                ],
              ),
            ),
          ],
        ),
      );
    }
  }