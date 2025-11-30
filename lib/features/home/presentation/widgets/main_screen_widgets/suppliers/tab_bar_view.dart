import 'package:flutter/material.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/suppliers/tabbar_second_page.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/suppliers/tapBarfirstPage.dart';

import '../../../../../../core/theme/colors.dart';
import '../products/product_card.dart';
//
// class StackOver extends StatefulWidget {
//   @override
//   double width;
//   double height;
//   StackOver({required  this.height,required this.width});
//
//   State<StackOver> createState() => _StackOverState(); // ✅ FIXED
//
// }//j
//
// class _StackOverState extends State<StackOver>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//
//   @override
//   void initState() {
//     _tabController = TabController(length: 2, vsync: this);
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _tabController.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return  Padding(
//       padding:  EdgeInsets.symmetric(vertical: widget.height*.02),
//         child: Column(
//           children: [
//             // give the tab bar a height [can change height to preferred height]
//             Container(
//               //add new padding for tapbar:
//               padding: EdgeInsets.symmetric(vertical: widget.height*.004,horizontal:  widget.width*.004),
//
//               margin: EdgeInsets.symmetric(horizontal: widget.width*.04),
//               height: widget.height*.05,
//              // width: widget.width-widget.width*.04,
//               decoration: BoxDecoration(
//                 color: AppColors.tabViewBackground,
//                 borderRadius: BorderRadius.circular(
//                   8,
//                 ),
//
//               ),
//               child: TabBar(
//                 controller: _tabController,
//                 // give the indicator a decoration (color and border radius)
//                 indicator: BoxDecoration(
//                   borderRadius: BorderRadius.circular(
//                     8,
//                   ),
//
//                   color: AppColors.whiteColor,
//                 ),indicatorSize: TabBarIndicatorSize.tab,dividerColor: Colors.transparent,
//                 labelStyle: TextStyle(fontWeight: FontWeight.w600,color: AppColors.primary),
//                 unselectedLabelColor: AppColors.greyDarktextIntExtFieldAndIconsHome,
//
//                 tabs: [
//                   // first tab [you can add an icon using the icon property]
//                   SizedBox(
//                     width:widget.width*.5,
//                     child: Tab(
//                       text: 'Product Details',
//
//                     ),
//                   ),
//
//                   // second tab [you can add an icon using the icon property]
//                   SizedBox(
//                     width:widget.width*.5,
//                     child: Tab(
//                       text: 'Reviews',
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             // tab bar view here
//             // Expanded(
//             //   child: TabBarView(
//             //     controller: _tabController,
//             //     children: [
//             //       // first tab bar view widget
//             //     Padding(
//             //       padding:  EdgeInsets.only(top:  widget.height * 0.02,bottom: widget.height*.09),
//             //       child: TabBarFirstPage(),
//             //     ),
//             //     TabBarSecondPage()
//             //     ],
//             //   ),
//             // ),
//             SizedBox(
//               height: widget.height * 0.5, // 👈 ارتفاع ثابت للـ TabBarView
//               child: TabBarView(
//                 controller: _tabController,
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.only(top: widget.height * 0.02, bottom: widget.height*.09),
//                     child: TabBarFirstPage(),
//                   ),
//                   TabBarSecondPage(),
//                 ],
//               ),
//             ),
//
//           ],
//         ),
//       );
//   }
// }

import 'package:flutter/material.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/suppliers/tabbar_second_page.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/suppliers/tapBarfirstPage.dart';
import '../../../../../../core/theme/colors.dart';

// class StackOver extends StatefulWidget {
//   double width;
//   double height;
//
//   StackOver({required this.height, required this.width, super.key});
//
//   @override
//   State<StackOver> createState() => _StackOverState();
// }
//
// class _StackOverState extends State<StackOver>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   int _currentIndex = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//
//     _tabController.addListener(() {
//       if (_tabController.indexIsChanging) return;
//       setState(() {
//         _currentIndex = _tabController.index;
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: widget.height * .02),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           // 🔹 نفس TabBar بتاعك بالظبط
//           Container(
//             padding: EdgeInsets.symmetric(
//               vertical: widget.height * .004,
//               horizontal: widget.width * .004,
//             ),
//             margin: EdgeInsets.symmetric(horizontal: widget.width * .04),
//             height: widget.height * .05,
//             decoration: BoxDecoration(
//               color: AppColors.tabViewBackground,
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: TabBar(
//               controller: _tabController,
//               indicator: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8),
//                 color: AppColors.whiteColor,
//               ),
//               indicatorSize: TabBarIndicatorSize.tab,
//               dividerColor: Colors.transparent,
//               labelStyle: TextStyle(
//                 fontWeight: FontWeight.w600,
//                 color: AppColors.primary,
//               ),
//               unselectedLabelColor:
//               AppColors.greyDarktextIntExtFieldAndIconsHome,
//               tabs: [
//                 SizedBox(
//                   width: widget.width * .5,
//                   child: const Tab(text: 'Product Details'),
//                 ),
//                 SizedBox(
//                   width: widget.width * .5,
//                   child: const Tab(text: 'Reviews'),
//                 ),
//               ],
//             ),
//           ),
//
//           SizedBox(height: widget.height * .02),
//
//           // 🔹 بدل TabBarView → IndexedStack
//           // عشان الكونتنت يبقى جزء طبيعي من الـ Scroll اللي برّه
//           IndexedStack(
//             index: _currentIndex,
//             children: [
//               Padding(
//                 padding: EdgeInsets.only(
//                   top: widget.height * 0.02,
//                   bottom: widget.height * .02,
//                 ),
//                 child: _wrapFirstTab(),
//               ),
//               Padding(
//                 padding: EdgeInsets.only(
//                   top: widget.height * 0.02,
//                   bottom: widget.height * .02,
//                 ),
//                 child: _wrapSecondTab(),
//               ),
//             ],
//           ),
//        //   SizedBox(height: widget.height*.1,)
//         ],
//       ),
//     );
//   }
//
//   /// لو صفحات التاب جوّاها ListView هنقفّل الـ Scroll الداخلي
//   Widget _wrapFirstTab() {
//     return TabBarFirstPageWrapper();
//   }
//
//   Widget _wrapSecondTab() {
//     return TabBarSecondPageWrapper();
//   }
// }
import 'package:flutter/material.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/suppliers/tabbar_second_page.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/suppliers/tapBarfirstPage.dart';

import '../../../../../../core/theme/colors.dart';

import 'package:flutter/material.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/suppliers/tabbar_second_page.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/suppliers/tapBarfirstPage.dart';
import '../../../../../../core/theme/colors.dart';

class StackOver extends StatefulWidget {
  double width;
  double height;

  StackOver({required this.height, required this.width, super.key});

  @override
  State<StackOver> createState() => _StackOverState();
}

class _StackOverState extends State<StackOver>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // 👇 دي اللي هترجع التاب الحالية بس
  Widget _buildCurrentTab(double h) {
    switch (_currentIndex) {
      case 0:
        return Padding(
          padding: EdgeInsets.only(
            top: h * 0.02,
            bottom: h * .02,
          ),
          child: TabBarFirstPage(),
        );
      case 1:
      default:
        return Padding(
          padding: EdgeInsets.only(
            top: h * 0.02,
            bottom: h * .02,
          ),
          child: TabBarSecondPage(),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = widget.height;
    final w = widget.width;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: h * .02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 🔹 نفس الـ TabBar بتاعك بالظبط
          Container(
            padding: EdgeInsets.symmetric(
              vertical: h * .004,
              horizontal: w * .004,
            ),
            margin: EdgeInsets.symmetric(horizontal: w * .04),
            height: h * .05,
            decoration: BoxDecoration(
              color: AppColors.tabViewBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.whiteColor,
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelStyle: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
              unselectedLabelColor:
              AppColors.greyDarktextIntExtFieldAndIconsHome,
              tabs: [
                SizedBox(
                  width: w * .5,
                  child: const Tab(text: 'Product Details'),
                ),
                SizedBox(
                  width: w * .5,
                  child: const Tab(text: 'Reviews'),
                ),
              ],
            ),
          ),

       //   SizedBox(height: h * .01), //handle design

          // 👇 هنا بقى بنعرض تاب واحدة بس
          _buildCurrentTab(h),
          SizedBox(height: h * .08),//space below
        ],
      ),
    );
  }
}



