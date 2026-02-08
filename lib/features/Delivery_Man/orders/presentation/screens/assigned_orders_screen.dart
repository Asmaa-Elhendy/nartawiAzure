import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../coupons/presentation/widgets/custom_text.dart';
import '../../../../home/presentation/widgets/background_home_Appbar.dart';
import '../../../../home/presentation/widgets/build_ForegroundAppBarHome.dart';
import '../../../../orders/domain/models/order_model.dart';
import 'package:newwwwwwww/features/orders/presentation/provider/order_controller.dart';
import 'package:newwwwwwww/core/services/dio_service.dart';
import '../../../../orders/presentation/widgets/order_card.dart';
import '../../../../orders/presentation/widgets/payement_status_widget.dart';
import '../../../../profile/presentation/widgets/filter_date_widget.dart';
import '../widgets/filter_area.dart';
import '../widgets/order_card_delivery.dart' hide formatOrderDate;

class AssignedOrderedScreen extends StatefulWidget {
  const AssignedOrderedScreen({super.key});

  @override
  State<AssignedOrderedScreen> createState() => _AssignedOrderedScreenState();
}

class _AssignedOrderedScreenState extends State<AssignedOrderedScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late OrdersController ordersController;
  final ScrollController _scrollController = ScrollController();
// ====== Filter data (TEMP / Example) ======
  final List<String> zonesList = ["Zone 1", "Zone 2", "Zone 3"];
  final List<String> streetsList = ["Street A", "Street B", "Street C"];
  final List<String> buildingsList = ["Building 10", "Building 11", "Building 12"];

// ====== Selected values ======
  String? selectedZone;
  String? selectedStreet;
  String? selectedBuilding;

  // ✅ 6 tabs
  static const List<String> _tabs = [
    'All',
    'Pending',
    'In Progress',
    'Delivered',
    'Canceled',
    'Disputed',
  ];


// مثال بيانات (بدلها من API أو حسب orders)
  final List<String> zones = ['Zone A', 'Zone B', 'Zone C'];
  final List<String> streets = ['Street 10', 'Street 20', 'Street 30'];
  final List<String> buildings = ['Building 1', 'Building 2', 'Building 3'];
// ✅ ADD THESE
  final TextEditingController zoneCtrl = TextEditingController();
  final TextEditingController streetCtrl = TextEditingController();
  final TextEditingController buildingCtrl = TextEditingController();
  // Get status ID based on tab index
  int? _getStatusIdForTab(String tabName) {
    switch (tabName.toLowerCase()) {
      case 'all': return null;
      case 'pending': return 1;
      case 'in progress': return 3;
      case 'delivered': return 4;
      case 'canceled': return 5;
      case 'disputed': return 6; // Adjust this ID based on your API
      default: return null;
    }
  }

  // Fetch orders for the current tab
  Future<void> _fetchOrdersForTab() async {
    if (ordersController.isLoading) return;
    
    final statusId = _getStatusIdForTab(_tabs[_tabController.index]);
    
    // Set the query with the current status filter
    ordersController.setQuery(OrdersQuery(statusId: statusId));
    
    // Clear existing orders and fetch fresh ones with the current filter
    await ordersController.fetchOrders(executeClear: true);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    ordersController = OrdersController(dio: DioService.dio, userRole: 'Delivery');

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
        _fetchOrdersForTab();
      }
    });

    // Initial load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _fetchOrdersForTab();
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
        final statusId = _getStatusIdForTab(_tabs[_tabController.index]);
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
    zoneCtrl.dispose();
    streetCtrl.dispose();
    buildingCtrl.dispose();
    super.dispose();
  }

  // This method is kept for backward compatibility
  // but won't be used for filtering since we're using server-side filtering now
  List<ClientOrder> _filterOrdersByTab(List<ClientOrder> allOrders, int tabIndex) {
    // No filtering needed as we're using server-side filtering
    return allOrders;
  }

  Widget _buildOrdersList({
    required double screenHeight,
    required double screenWidth,
    required List<ClientOrder> orders,
  }) {
    if (orders.isEmpty && !ordersController.isLoading && !ordersController.isLoadingMore) {
      return const Center(
        child: Text(
          'No orders found',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: _fetchOrdersForTab,
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
          final statusText = order.statusName ?? 'Unknown';
          final paymentText = order.isPaid == true ? 'Paid' : 'Pending Payment';

          return BuildOrderDeliveryCard(
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
          BuildForegroundappbarhome(fromDeliveryMan: true,
            screenHeight: screenHeight,
            screenWidth: screenWidth,
            title: 'Orders',
            is_returned: false,
          ),
          Positioned.fill(
            top: MediaQuery.of(context).padding.top + screenHeight * .1,
            bottom: screenHeight * .05,
            child: Padding(
              padding: EdgeInsets.only(bottom: screenHeight * .1),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * .06),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Assigned Orders',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: screenWidth * .045,
                              ),
                            ),
                           Padding(
                             padding:  EdgeInsets.symmetric(vertical: screenHeight*.02),
                             child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset("assets/images/orders/calendar.svg",
                                          width: screenWidth * .042,color: AppColors.textLight,),
                                        SizedBox(width: screenWidth*.02,),
                                        Text(
                                          formatOrderDate(DateTime.now())
                                         ,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: screenWidth * .036,
                                          ),
                                        )
                                      ],
                                    ),

                                  ],
                                ),
                           ),

                            /// ✅ Tabs container (مع Scroll)
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: screenHeight * .004,
                                horizontal: screenWidth * .004,
                              ),
                              margin: EdgeInsets.only(
                                // right: screenWidth * .04,
                                // left: screenWidth * .04,
                               bottom: screenHeight * .02,
                             //   top: screenHeight * .01,
                              ),
                              height: screenHeight * .05,
                              decoration: BoxDecoration(
                                color: AppColors.tabViewBackground,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TabBar(
                                isScrollable: true, // ✅ مهم عشان 6 tabs
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
                                unselectedLabelColor:
                                AppColors.greyDarktextIntExtFieldAndIconsHome,
                                tabs: _tabs.map((t) => Tab(text: t)).toList(),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // FROM
                                // Column(
                                //   crossAxisAlignment: CrossAxisAlignment.start,
                                //   children: [
                                //     customCouponAlertTitle(
                                //       'Filter By',
                                //       screenWidth,
                                //       screenHeight,//j
                                //     ),
                                //     GestureDetector(
                                //       onTap: () async {},
                                //       child:FilterByRowTypeAhead(
                                //         width: screenWidth,
                                //         height: screenHeight,
                                //         zones: zonesList,
                                //         streets: streetsList,
                                //         buildings: buildingsList,
                                //         zoneController: zoneCtrl,
                                //         streetController: streetCtrl,
                                //         buildingController: buildingCtrl,
                                //         onZoneSelected: (v) => setState(() {}),
                                //         onStreetSelected: (v) => setState(() {}),
                                //         onBuildingSelected: (v) => setState(() {}),
                                //         onClearZone: () => setState(() {}),
                                //         onClearStreet: () => setState(() {}),
                                //         onClearBuilding: () => setState(() {}),
                                //       ),
                                //
                                //
                                //
                                //
                                //     ),
                                //   ],
                                // ),

                              ],
                            ),

                            /// ✅ TabBarView
                            SizedBox(
                              height: screenHeight * .65,
                              child: AnimatedBuilder(
                                animation: ordersController,
                                builder: (context, _) {
                                  if (ordersController.isLoading && ordersController.orders.isEmpty) {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        color: AppColors.primary,
                                      ),
                                    );
                                  }

                                  if (ordersController.error != null) {
                                    return Center(
                                      child: Text(
                                        ordersController.error!,
                                        style: const TextStyle(color: Colors.red),
                                      ),
                                    );
                                  }

                                  final allOrders = ordersController.orders;

                                  return TabBarView(
                                    controller: _tabController,
                                    children: List.generate(_tabs.length, (tabIndex) {
                                      final filtered = _filterOrdersByTab(allOrders, tabIndex);
                                      
                                      if (filtered.isEmpty && !ordersController.isLoading && !ordersController.isLoadingMore) {
                                        return const Center(
                                          child: Text(
                                            'No orders found',
                                            style: TextStyle(color: Colors.grey),
                                          ),
                                        );
                                      }

                                      return _buildOrdersList(
                                        screenHeight: screenHeight,
                                        screenWidth: screenWidth,
                                        orders: filtered,
                                      );
                                    }),
                                  );
                                },
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
    );
  }
}
