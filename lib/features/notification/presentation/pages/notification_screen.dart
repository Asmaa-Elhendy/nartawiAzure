import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:newwwwwwww/features/notification/presentation/provider/notification_controller.dart';
import 'package:newwwwwwww/core/services/dio_service.dart';
import '../../../../core/theme/colors.dart';
import '../../../home/presentation/widgets/background_home_Appbar.dart';
import '../../../home/presentation/widgets/build_ForegroundAppBarHome.dart';
import '../bloc/notification_bloc/bloc.dart';
import '../bloc/notification_bloc/state.dart';
import '../provider/notification_controller.dart';
import '../../domain/notification_model.dart';

class NotificationScreen extends StatefulWidget {
  bool fromDeliveryMan;
  NotificationScreen({this.fromDeliveryMan = false});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late NotificationController _notificationController;
  late ScrollController _scrollController;

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
    _scrollController = ScrollController();
    _notificationController = NotificationController(dio: DioService.dio);
    
    _notificationController.fetchNotifications();
    
    _startPolling();
    _scrollController.addListener(_onScroll);
  }

  void _startPolling() {
    Future.delayed(Duration(seconds: 60), () {
      if (mounted) {
        _notificationController.refreshUnreadCount();
        _startPolling();
      }
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 200) {
      if (_notificationController.hasMore && !_notificationController.isLoading) {
        _notificationController.fetchNotifications(loadMore: true);
      }
    }
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
    _scrollController.dispose();
    _notificationController.dispose();
    super.dispose();
  }

  String? imageUrl = null;

  Widget _buildTabPage(String tabName) {
    return ListenableBuilder(
      listenable: _notificationController,
      builder: (context, child) {
        if (_notificationController.isLoading && 
            _notificationController.allNotifications.isEmpty) {
          return Center(child: CircularProgressIndicator(color: AppColors.primary,));
        }

        if (_notificationController.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 60, color: Colors.red),
                SizedBox(height: 16),
                Text('Error: ${_notificationController.error}'),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _notificationController.fetchNotifications(),
                  child: Text('Retry'),
                ),
              ],
            ),
          );
        }

        final notifications = _notificationController.getNotificationsByTab(tabName);

        if (notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.notifications_none, size: 80, color: Colors.grey),
                SizedBox(height: 16),
                Text('No notifications', style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => _notificationController.fetchNotifications(),
          child: ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.symmetric(vertical: 8),
            itemCount: notifications.length + 
                (_notificationController.isLoading && _notificationController.hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= notifications.length) {
                return Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final notification = notifications[index];
              return _buildNotificationCard(notification);
            },
          ),
        );
      },
    );
  }

  Widget _buildNotificationCard(NotificationModel notification) {
    return InkWell(
      onTap: () => _handleNotificationTap(notification),
      child: Container(
        color: notification.isRead 
            ? Colors.white 
            : Colors.blue.withOpacity(0.05),
        padding: EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: notification.iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                notification.icon,
                color: notification.iconColor,
                size: 20,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            fontWeight: notification.isRead 
                                ? FontWeight.normal 
                                : FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      if (!notification.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    notification.message,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    notification.timeAgo,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleNotificationTap(NotificationModel notification) async {
    if (!notification.isRead) {
      await _notificationController.markAsRead(notification.id);
    }
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
                          children: _tabs.map((tab) => _buildTabPage(tab)).toList(),
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
