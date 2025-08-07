import 'package:flutter/material.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/suppliers/tabbar_second_page.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/suppliers/tapBarfirstPage.dart';

import '../../../../../../core/theme/colors.dart';
import '../product_card.dart';

class StackOver extends StatefulWidget {
  @override
  double width;
  double height;
  StackOver({required  this.height,required this.width});

  State<StackOver> createState() => _StackOverState(); // ✅ FIXED

}//

class _StackOverState extends State<StackOver>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return  Padding(
      padding:  EdgeInsets.symmetric(vertical: widget.height*.02),
        child: Column(
          children: [
            // give the tab bar a height [can change height to preferred height]
            Container(
              margin: EdgeInsets.symmetric(horizontal: widget.width*.04),
              height: widget.height*.05,
             // width: widget.width-widget.width*.04,
              decoration: BoxDecoration(
                color: AppColors.tabViewBackground,
                borderRadius: BorderRadius.circular(
                  8,
                ),

              ),
              child: TabBar(
                controller: _tabController,
                // give the indicator a decoration (color and border radius)
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    8,
                  ),

                  color: AppColors.whiteColor,
                ),indicatorSize: TabBarIndicatorSize.tab,dividerColor: Colors.transparent,
                labelStyle: TextStyle(fontWeight: FontWeight.w600,color: AppColors.primary),
                unselectedLabelColor: AppColors.greyDarktextIntExtFieldAndIconsHome,

                tabs: [
                  // first tab [you can add an icon using the icon property]
                  SizedBox(
                    width:widget.width*.5,
                    child: Tab(
                      text: 'Product Details',

                    ),
                  ),

                  // second tab [you can add an icon using the icon property]
                  SizedBox(
                    width:widget.width*.5,
                    child: Tab(
                      text: 'Reviews',
                    ),
                  ),
                ],
              ),
            ),
            // tab bar view here
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // first tab bar view widget
                Padding(
                  padding:  EdgeInsets.symmetric(vertical:  widget.height * 0.02,),
                  child: TabBarFirstPage(),
                ),
                TabBarSecondPage()
                ],
              ),
            ),
          ],
        ),
      );
  }
}