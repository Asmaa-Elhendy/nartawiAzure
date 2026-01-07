import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../coupons/presentation/widgets/custom_text.dart';
import '../../../../home/presentation/widgets/background_home_Appbar.dart';
import '../../../../home/presentation/widgets/build_ForegroundAppBarHome.dart';
import '../../../../orders/domain/models/order_model.dart';
import '../../../../orders/presentation/provider/order_controller.dart';
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
    'On The Way',
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
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);

     ordersController = OrdersController(dio: Dio());
    //
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (mounted) {
    //     ordersController.fetchOrders(executeClear: true);
    //   }
    // });
  }

  @override
  void dispose() {//k
    _tabController.dispose();
    // ordersController.dispose();
    zoneCtrl.dispose();
    streetCtrl.dispose();
    buildingCtrl.dispose();
    super.dispose();
  }

  List<ClientOrder> _filterOrdersByTab(List<ClientOrder> allOrders, int tabIndex) {
    if (tabIndex == 0) return allOrders;

    final tabName = _tabs[tabIndex].toLowerCase();

    return allOrders.where((order) {
      final status = (order.statusName ?? '').toLowerCase();

      // ✅ status matching
      if (tabName == 'on the way') {
        // in case backend returns variations
        return status.contains('on the way') ||
            status.contains('ontheway') ||
            status.contains('out for delivery_man') ||
            status.contains('on_way') ||
            status.contains('shipping');
      }

      if (tabName == 'pending') {
        return status.contains('pending');
      }

      if (tabName == 'delivered') {
        return status.contains('delivered');
      }

      if (tabName == 'canceled') {
        return status.contains('canceled') || status.contains('cancelled');
      }

      if (tabName == 'disputed') {
        return status.contains('disputed') || status.contains('dispute');
      }

      // fallback (shouldn’t happen)
      return false;
    }).toList();
  }

  Widget _buildOrdersList({
    required double screenHeight,
    required double screenWidth,
    required List<ClientOrder> orders,
  }) {
    if (orders.isEmpty) {
      return const Center(child: Text('No orders found'));
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        await ordersController.fetchOrders(executeClear: true);
      },
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(bottom: screenHeight * .06),
        itemCount: orders.length,
        itemBuilder: (context, index) {
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
          BuildForegroundappbarhome(
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
                                  if (ordersController.isLoading) {
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

                                  final allOrders =[
                                    ClientOrder(id: 0,issueTime: DateTime.now(),statusName: 'Pending',isPaid: true,subTotal: 55,total: 60,deliveryCost: 5,deliveryAddress: 'Zone abc, Street 20, Building 21'),
                                    ClientOrder(id: 1,issueTime: DateTime.now(),statusName: 'On The Way',isPaid: true,subTotal: 55,total: 60,deliveryCost: 5,deliveryAddress: 'Zone abc, Street 20, Building 21'),
                                    ClientOrder(id: 3,issueTime: DateTime.now(),statusName: 'Delivered',isPaid: true,subTotal: 55,total: 60,deliveryCost: 5,deliveryAddress: 'Zone abc, Street 20, Building 21'),
                                    ClientOrder(id: 4,issueTime: DateTime.now(),statusName: 'Pending',isPaid: false,subTotal: 55,total: 60,deliveryCost: 5,deliveryAddress: 'Zone abc, Street 20, Building 21'),
                                    ClientOrder(id: 5,issueTime: DateTime.now(),statusName: 'Cancelled',isPaid: false,subTotal: 55,total: 60,deliveryCost: 5,deliveryAddress: 'Zone abc, Street 20, Building 21'),



                                  ];// ordersController.orders;

                                  return TabBarView(
                                    controller: _tabController,
                                    children: List.generate(_tabs.length, (tabIndex) {
                                      final filtered =
                                      _filterOrdersByTab(allOrders, tabIndex);

                                      return _buildOrdersList(
                                        screenHeight: screenHeight,
                                        screenWidth: screenWidth,
                                        orders:
                                        filtered

                                        //filtered,
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
