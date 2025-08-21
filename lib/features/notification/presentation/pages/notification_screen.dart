import 'package:flutter/material.dart';
import 'package:newwwwwwww/features/notification/presentation/widgets/all_notification_page.dart';
import '../../../../core/theme/colors.dart';
import '../../../home/presentation/widgets/background_home_Appbar.dart';
import '../../../home/presentation/widgets/build_ForegroundAppBarHome.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 6, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String? imageUrl = null;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      // 🔥 يخلي الجسم يبدأ من أعلى الشاشة خلف الـ AppBar
      backgroundColor: Colors.transparent,
      // في حالة الصورة في الخلفية
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
            title: 'Notifications',
            is_returned: true,
            //edit back from orders
            disabledNotification: 'notifications',
          ),
          Positioned.fill(
            top: MediaQuery.of(context).padding.top + screenHeight * .1,
            child: Padding(
              padding: EdgeInsets.only(
                top: screenHeight * .04,
                bottom: screenHeight * .1,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * .004,
                          horizontal: screenWidth * .004,
                        ),
                        margin: EdgeInsets.only(
                          left: .06 * screenWidth,
                          right: .06 * screenWidth,
                          bottom: screenHeight * .03,
                        ),
                        height: screenHeight * .05,
                        // width: width-widget.width*.04,
                        decoration: BoxDecoration(
                          color: AppColors.tabViewBackground,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TabBar(
                          padding: EdgeInsets.zero,
                          // isScrollable: true,
                          labelPadding: EdgeInsets.symmetric(
                            horizontal: screenWidth * .01,
                          ),
                          controller: _tabController,
                          // give the indicator a decoration (color and border radius)
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
                            // first tab [you can add an icon using the icon property]
                            SizedBox(child: Tab(text: 'All')),
                            SizedBox(child: Tab(text: 'New')),
                            SizedBox(child: Tab(text: 'Read')),
                            SizedBox(child: Tab(text: 'Orders')),
                            SizedBox(child: Tab(text: 'Coupons')),

                            SizedBox(child: Tab(text: 'Products')),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * .67,
                        child: TabBarView(
                          controller: _tabController,

                          children: [
                          AllNotificationPage(),
                            Text('2'),
                            Text('2'),
                            Text('2'),
                            Text('2'),
                            Text('2'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
