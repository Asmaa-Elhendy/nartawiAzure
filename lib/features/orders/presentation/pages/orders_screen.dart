import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    ordersController = OrdersController(dio: Dio());
    
    // ✅ Delay the fetch call to avoid calling notifyListeners during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ordersController.fetchOrders(executeClear: true); // ✅ تحميل كل الطلبات
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    ordersController.dispose();

    super.dispose();
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
                  child: Text('Retry'),
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
                  'No orders found',
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
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.only(bottom: screenHeight * .06),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final statusText = order.statusName ?? 'Unknown';
              final paymentText = order.isPaid == true ? 'Paid' : 'Pending Payment';

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
            title: 'Orders',
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
                            Text(
                              'My Orders',
                              style: TextStyle(fontWeight: FontWeight.w600,fontSize: screenWidth*.045),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: screenHeight*.004,horizontal: screenWidth*.004),
                              margin: EdgeInsets.symmetric(horizontal: screenWidth*.04,vertical: screenHeight*.03),
                              height: screenHeight*.05,
                              // width: widget.width-widget.width*.04,
                              decoration: BoxDecoration(
                                color: AppColors.tabViewBackground,
                                borderRadius: BorderRadius.circular(
                                  8,
                                ),

                              ),
                              child:
                              TabBar(
                                padding: EdgeInsets.zero,
                                labelPadding: EdgeInsets.symmetric(horizontal: screenWidth*.01),
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
                                   width:screenWidth*.25,
                                    child: Tab(
                                      text: 'All',

                                    ),
                                  ),

                                  // second tab [you can add an icon using the icon property]
                                  SizedBox(
                                    width:screenWidth*.25,
                                    child: Tab(
                                      text: 'Pending',
                                    ),
                                  ),
                                  SizedBox(
                                    width:screenWidth*.25,
                                    child: Tab(
                                      text: 'Delivered',
                                    ),
                                  ),
                                  SizedBox(
                                    width:screenWidth*.25,
                                    child: Tab(
                                      text: 'Canceled',

                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: screenHeight*.65,
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  _buildOrderList(null),     // All orders
                                  _buildOrderList(1),        // Pending (statusId = 1)
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
    );
  }
}
