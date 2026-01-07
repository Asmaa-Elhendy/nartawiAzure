import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newwwwwwww/features/notification/presentation/widgets/all_notification_page.dart';
import '../../../../core/theme/colors.dart';
import '../../../home/presentation/widgets/background_home_Appbar.dart';
import '../../../home/presentation/widgets/build_ForegroundAppBarHome.dart';
import '../bloc/notification_bloc/bloc.dart';
import '../bloc/notification_bloc/state.dart';

class NotificationScreen extends StatefulWidget {
  bool fromDeliveryMan;
  NotificationScreen({this.fromDeliveryMan = false});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // ✅ Tabs for normal user
  static const List<String> _tabsUser = [
    'All',
    'New',
    'Read',
    'Orders',
    'Coupons',
    'Promos',
  ];

  // ✅ Tabs for delivery man
  static const List<String> _tabsDelivery = [
    'All',
    'New',
    'Read',
    'One time',
    'Coupons',
    'Disputes',
    'Canceled',
  ];

  List<String> get _tabs => widget.fromDeliveryMan ? _tabsDelivery : _tabsUser;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void didUpdateWidget(covariant NotificationScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    // ✅ لو fromDeliveryMan اتغيرت، لازم نعمل TabController جديد بطول مختلف
    if (oldWidget.fromDeliveryMan != widget.fromDeliveryMan) {
      _tabController.dispose();
      _tabController = TabController(length: _tabs.length, vsync: this);
      setState(() {});
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String? imageUrl = null;

  // ✅ helper to build each tab page (نفس UI اللي عندك)
  Widget _buildTabPage(List<NotificationItem> items) {
    return BlocProvider(
      create: (_) => NotificationBloc(initialNotifications: items),
      child: AllNotificationPage(widget.fromDeliveryMan),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            width: screenWidth,
            height: screenHeight,
            color: AppColors.backgrounHome,
          ),
          buildBackgroundAppbar(screenWidth),
          BuildForegroundappbarhome(
            fromDeliveryMan: widget.fromDeliveryMan,
            screenHeight: screenHeight,
            screenWidth: screenWidth,
            title: 'Notifications',
            is_returned: true,
            disabledNotification: 'notifications',
          ),
          Positioned.fill(
            top: MediaQuery.of(context).padding.top + screenHeight * .1,
            child: Padding(
              padding: EdgeInsets.only(
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
                        ),
                        height: screenHeight * .05,
                        decoration: BoxDecoration(
                          color: AppColors.tabViewBackground,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TabBar(
                          padding: EdgeInsets.zero,
                          isScrollable: true,
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

                          // ✅ Tabs dynamic
                          tabs: _tabs.map((t) => Tab(text: t)).toList(),
                        ),
                      ),

                      SizedBox(
                        height: screenHeight * .7,
                        child: TabBarView(
                          controller: _tabController,

                          // ✅ Pages dynamic (عددهم = عدد التابات)
                          children: widget.fromDeliveryMan
                              ? [
                            // Delivery Man (7)
                            _buildTabPage([
                              NotificationItem(
                                  id: 1,
                                  title: "Meeting",
                                  description: "Team sync at 10 AM",
                                  isRead: false),
                              NotificationItem(
                                  id: 2,
                                  title: "Order Placed Successfully",
                                  description:
                                  "Your order #30 has been placed successfully and is being processed.",
                                  isRead: false),
                              NotificationItem(
                                  id: 3,
                                  title: "Meeting",
                                  description: "Team sync at 10 AM",
                                  isRead: true),
                              NotificationItem(
                                  id: 4,
                                  title: "Report",
                                  description: "Submit monthly report",
                                  isRead: true),
                            ]),

                            _buildTabPage([
                              NotificationItem(
                                  id: 11,
                                  title: "New Notification",
                                  description: "You have a new task",
                                  isRead: false),
                              NotificationItem(
                                  id: 12,
                                  title: "New Order",
                                  description: "Order #55 is assigned to you",
                                  isRead: false),
                            ]),

                            _buildTabPage([
                              NotificationItem(
                                  id: 21,
                                  title: "Read Notification",
                                  description: "Old message",
                                  isRead: true),
                            ]),

                            _buildTabPage([
                              NotificationItem(
                                  id: 31,
                                  title: "One time",
                                  description: "One-time request received",
                                  isRead: false),
                            ]),

                            _buildTabPage([
                              NotificationItem(
                                  id: 41,
                                  title: "Coupon",
                                  description: "New coupon is available",
                                  isRead: false),
                            ]),

                            _buildTabPage([
                              NotificationItem(
                                  id: 51,
                                  title: "Dispute",
                                  description: "Order #20 has a dispute",
                                  isRead: false),
                            ]),

                            _buildTabPage([
                              NotificationItem(
                                  id: 61,
                                  title: "Canceled",
                                  description: "Order #18 was canceled",
                                  isRead: true),
                            ]),
                          ]
                              : [
                            // User (6)
                            _buildTabPage([
                              NotificationItem(
                                  id: 1,
                                  title: "Meeting",
                                  description: "Team sync at 10 AM",
                                  isRead: false),
                              NotificationItem(
                                  id: 2,
                                  title: "Order Placed Successfully",
                                  description:
                                  "Your order #30 has been placed successfully and is being processed.",
                                  isRead: false),
                              NotificationItem(
                                  id: 3,
                                  title: "Meeting",
                                  description: "Team sync at 10 AM",
                                  isRead: true),
                              NotificationItem(
                                  id: 4,
                                  title: "Report",
                                  description: "Submit monthly report",
                                  isRead: true),
                            ]),
                            _buildTabPage([
                              NotificationItem(
                                  id: 1,
                                  title: "Meeting",
                                  description: "Team sync at 10 AM",
                                  isRead: false),
                              NotificationItem(
                                  id: 2,
                                  title: "Order Placed Successfully",
                                  description:
                                  "Your order #30 has been placed successfully and is being processed.",
                                  isRead: false),
                              NotificationItem(
                                  id: 3,
                                  title: "Meeting",
                                  description: "Team sync at 10 AM",
                                  isRead: false),
                              NotificationItem(
                                  id: 4,
                                  title: "Report",
                                  description: "Submit monthly report",
                                  isRead: false),
                            ]),
                            _buildTabPage([
                              NotificationItem(
                                  id: 1,
                                  title: "Meeting",
                                  description: "Team sync at 10 AM",
                                  isRead: true),
                              NotificationItem(
                                  id: 2,
                                  title: "Order Placed Successfully",
                                  description:
                                  "Your order #30 has been placed successfully and is being processed.",
                                  isRead: true),
                              NotificationItem(
                                  id: 3,
                                  title: "Meeting",
                                  description: "Team sync at 10 AM",
                                  isRead: true),
                              NotificationItem(
                                  id: 4,
                                  title: "Report",
                                  description: "Submit monthly report",
                                  isRead: true),
                            ]),
                            _buildTabPage([
                              NotificationItem(
                                  id: 1,
                                  title: "Orders",
                                  description: "Order update",
                                  isRead: false),
                            ]),
                            _buildTabPage([
                              NotificationItem(
                                  id: 1,
                                  title: "Coupons",
                                  description: "New coupon available",
                                  isRead: false),
                            ]),
                            _buildTabPage([
                              NotificationItem(
                                  id: 1,
                                  title: "Promos",
                                  description: "New promo available",
                                  isRead: false),
                            ]),
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
