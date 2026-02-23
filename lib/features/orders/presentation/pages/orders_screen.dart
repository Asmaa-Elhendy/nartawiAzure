import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/colors.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../core/services/dio_service.dart';
import '../../../home/presentation/widgets/background_home_Appbar.dart';
import '../../../home/presentation/widgets/build_ForegroundAppBarHome.dart';
import '../../domain/models/order_model.dart';
import '../provider/order_controller.dart';
import '../widgets/order_card.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>  with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late OrdersController ordersController;
  final ScrollController _scrollController = ScrollController();

  // Get status ID based on tab index
  int? _getStatusIdForIndex(int index) {
    switch (index) {
      case 0: return null;        // All
      case 1: return 1;           // Pending
      case 2: return 3;           // In Progress
      case 3: return 4;           // Delivered
      case 4: return 5;           // Canceled
      default: return null;
    }
  }

  // Fetch orders for the current tab
  Future<void> _fetchOrdersForCurrentTab() async {
    if (ordersController.isLoading) return;
    
    final statusId = _getStatusIdForIndex(_tabController.index);
    
    // Set the query with the current status filter
    ordersController.setQuery(OrdersQuery(statusId: statusId));
    
    // Clear existing orders and fetch fresh ones with the current filter
    await ordersController.fetchOrders(executeClear: true);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);

    ordersController = OrdersController(dio: DioService.dio);
    

    
    // Add scroll listener
    _scrollController.addListener(_onScroll);
    
    // Add tab change listener
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        // Reset scroll position when changing tabs
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(0);
        }
        // Fetch orders for the newly selected tab
        _fetchOrdersForCurrentTab();
      }
    });
    
    // Initial fetch for the first tab
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _fetchOrdersForCurrentTab();
      }
    });
  }

  // Handle scroll events
  void _onScroll() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent * 0.9) {
      if (!ordersController.isLoadingMore && 
          ordersController.hasMore && 
          !ordersController.isLoading) {
        // Update the query before loading more
        final statusId = _getStatusIdForIndex(_tabController.index);
        ordersController.setQuery(OrdersQuery(statusId: statusId));
        ordersController.loadMore();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    ordersController.dispose();
    super.dispose();
  }

  void _onLanguageChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  String? imageUrl = null;

  Widget _buildOrderList(int? statusId) {
    return AnimatedBuilder(
      animation: ordersController,
      builder: (context, _) {
        final screenHeight = MediaQuery.of(context).size.height;
        final screenWidth = MediaQuery.of(context).size.width;

        if (ordersController.isLoading) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (ordersController.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 60, color: Colors.red),
                SizedBox(height: 16),
                Text(
                  ordersController.error!,
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ordersController.fetchOrders(executeClear: true),
                  child: Text(AppLocalizations.of(context)!.retry),
                ),
              ],
            ),
          );
        }

        List<ClientOrder> orders;
        if (statusId == null) {
          orders = ordersController.orders;
        } else {
          orders = ordersController.orders
              .where((order) => order.statusId == statusId)
              .toList();
        }

        if (orders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_bag_outlined, size: 60, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.noOrdersFound,
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            await ordersController.fetchOrders(executeClear: true);
          },
          child: ListView.builder(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.only(bottom: screenHeight * .06),
            itemCount: orders.length + (ordersController.hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              // Show loading indicator at the bottom when loading more
              if (index >= orders.length) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  ),
                );
              }
              final order = orders[index];
              final statusText = order.statusName ?? AppLocalizations.of(context)!.unknown;
              final paymentText = order.isPaid == true ? AppLocalizations.of(context)!.paid :
              AppLocalizations.of(context)!.pendingPayment;

              return BuildOrderCard(
                order: order,
                context,
                screenHeight,
                screenWidth,
                statusText,
                paymentText,
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider(
      create: (_) => ordersController,
      child: Scaffold(
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
              title: AppLocalizations.of(context)!.orders,
              is_returned: false,//edit back from orders
            ),
            Positioned.fill(
              top: MediaQuery.of(context).padding.top + screenHeight * .1,
              bottom: screenHeight*.05,
              child: Padding(
                padding: EdgeInsets.only(
                //  top: screenHeight * .03,//04 handle design shimaa
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
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * .06,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(//lkj jk
                                AppLocalizations.of(context)!.myOrders,
                                style: TextStyle(fontWeight: FontWeight.w600,fontSize: screenWidth*.045),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * .004,
                                  horizontal: screenWidth * .004,
                                ),
                                margin: EdgeInsets.only(
                                  bottom: screenHeight * .02,
                                ),
                                height: screenHeight * .05,
                                decoration: BoxDecoration(
                                  color: AppColors.tabViewBackground,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: TabBar(
                                  isScrollable: true, // Make tabs scrollable
                                  padding: EdgeInsets.zero,
                                  labelPadding: EdgeInsets.symmetric(horizontal: screenWidth * .03),
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
                                  unselectedLabelColor: AppColors.greyDarktextIntExtFieldAndIconsHome,
                                  tabs: [
                                    Tab(text: AppLocalizations.of(context)!.all),
                                    Tab(text: AppLocalizations.of(context)!.pending),
                                    Tab(text: AppLocalizations.of(context)!.inProgress),
                                    Tab(text: AppLocalizations.of(context)!.delivered),
                                    Tab(text: AppLocalizations.of(context)!.canceled),
                                  ],
                                ),
                              ),
                              SizedBox(height: screenHeight*.65,
                                child: TabBarView(
                                  controller: _tabController,
                                  children: [
                                    _buildOrderList(null),     // All orders
                                    _buildOrderList(1),        // Pending (statusId = 1)
                                    _buildOrderList(3),        // In Progress (statusId = 3)
                                    _buildOrderList(4),        // Delivered (statusId = 4)
                                    _buildOrderList(5),        // Canceled (statusId = 5)
                                  ],
                                ),
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
      ),
    );
  }
}
