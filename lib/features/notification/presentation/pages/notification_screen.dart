import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newwwwwwww/features/notification/presentation/widgets/all_notification_page.dart';
import '../../../../core/theme/colors.dart';
import '../../../home/presentation/widgets/background_home_Appbar.dart';
import '../../../home/presentation/widgets/build_ForegroundAppBarHome.dart';
import '../bloc/notification_bloc/bloc.dart';
import '../bloc/notification_bloc/state.dart';

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
             //   top: screenHeight * .03,//04 handle design shimaa
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
                        //  bottom: screenHeight * .03,
                        ),
                        height: screenHeight * .05,
                        decoration: BoxDecoration(
                          color: AppColors.tabViewBackground,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TabBar(
                          padding: EdgeInsets.zero,

                          // 👇 خلّيها true عشان السطور الطويلة تتحرك يمين/شمال
                          isScrollable: true,

                          // 👈 padding بسيط بين التابات
                          labelPadding: EdgeInsets.symmetric(
                            horizontal: screenWidth * .02,
                          ),

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

                          tabs: const [
                            Tab(text: 'All'),
                            Tab(text: 'New'),
                            Tab(text: 'Read'),
                            Tab(text: 'Orders'),
                            Tab(text: 'Coupons'),
                            Tab(text: 'Promos'),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: screenHeight * .7,//
                        child: TabBarView(
                          controller: _tabController,

                          children: [
                            BlocProvider(
                              create: (_) => NotificationBloc(
                                initialNotifications: [
                                  NotificationItem(id: 1, title: "Meeting", description: "Team sync at 10 AM", isRead: false),
                                  NotificationItem(id: 2, title: "Order Placed Successfully", description: "Your order #30 has been placed successfully and is being processed.", isRead: false),
                                  NotificationItem(id: 3, title: "Meeting", description: "Team sync at 10 AM", isRead: true),
                                  NotificationItem(id: 4, title: "Report", description: "Submit monthly report", isRead: true),
                                ],
                              ),
                              child: AllNotificationPage(),
                            ),
                            BlocProvider(
                              create: (_) => NotificationBloc(
                                initialNotifications: [
                                  NotificationItem(id: 1, title: "Meeting", description: "Team sync at 10 AM", isRead: false),
                                  NotificationItem(id: 2, title: "Order Placed Successfully", description: "Your order #30 has been placed successfully and is being processed.", isRead: false),
                                  NotificationItem(id: 3, title: "Meeting", description: "Team sync at 10 AM", isRead: false),
                                  NotificationItem(id: 4, title: "Report", description: "Submit monthly report", isRead: false),
                                ],
                              ),
                              child: AllNotificationPage(),
                            ),
                            BlocProvider(
                              create: (_) => NotificationBloc(
                                initialNotifications: [
                                  NotificationItem(id: 1, title: "Meeting", description: "Team sync at 10 AM", isRead: true),
                                  NotificationItem(id: 2, title: "Order Placed Successfully", description: "Your order #30 has been placed successfully and is being processed.", isRead: true),
                                  NotificationItem(id: 3, title: "Meeting", description: "Team sync at 10 AM", isRead: true),
                                  NotificationItem(id: 4, title: "Report", description: "Submit monthly report", isRead: true),
                                ],
                              ),
                              child: AllNotificationPage(),
                            ),
                            BlocProvider(
                              create: (_) => NotificationBloc(
                                initialNotifications: [
                                  NotificationItem(id: 1, title: "Meeting", description: "Team sync at 10 AM", isRead: false),
                                  NotificationItem(id: 2, title: "Order Placed Successfully", description: "Your order #30 has been placed successfully and is being processed.", isRead: false),
                                  NotificationItem(id: 3, title: "Meeting", description: "Team sync at 10 AM", isRead: true),
                                  NotificationItem(id: 4, title: "Report", description: "Submit monthly report", isRead: true),
                                ],
                              ),
                              child: AllNotificationPage(),
                            ),
                            BlocProvider(
                              create: (_) => NotificationBloc(
                                initialNotifications: [
                                  NotificationItem(id: 1, title: "Meeting", description: "Team sync at 10 AM", isRead: false),
                                  NotificationItem(id: 2, title: "Order Placed Successfully", description: "Your order #30 has been placed successfully and is being processed.", isRead: false),
                                  NotificationItem(id: 3, title: "Meeting", description: "Team sync at 10 AM", isRead: true),
                                  NotificationItem(id: 4, title: "Report", description: "Submit monthly report", isRead: true),
                                ],
                              ),
                              child: AllNotificationPage(),
                            ),
                            BlocProvider(
                              create: (_) => NotificationBloc(
                                initialNotifications: [
                                  NotificationItem(id: 1, title: "Meeting", description: "Team sync at 10 AM", isRead: false),
                                  NotificationItem(id: 2, title: "Order Placed Successfully", description: "Your order #30 has been placed successfully and is being processed.", isRead: false),
                                  NotificationItem(id: 3, title: "Meeting", description: "Team sync at 10 AM", isRead: true),
                                  NotificationItem(id: 4, title: "Report", description: "Submit monthly report", isRead: true),
                                ],
                              ),
                              child: AllNotificationPage(),
                            ),
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
