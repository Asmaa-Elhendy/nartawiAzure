import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../coupons/presentation/widgets/custom_text.dart';
import '../../../../home/presentation/widgets/background_home_Appbar.dart';
import '../../../../home/presentation/widgets/build_ForegroundAppBarHome.dart';
import '../../../../profile/presentation/widgets/filter_date_widget.dart';
import '../../../../orders/presentation/provider/orders_controller.dart';
import '../../../../orders/domain/models/order_model.dart';
import '../widgets/delivery_history_card.dart';

class HistoryDelivery extends StatefulWidget {
  const HistoryDelivery({super.key});

  @override
  State<HistoryDelivery> createState() => _HistoryDeliveryState();
}

class _HistoryDeliveryState extends State<HistoryDelivery>
    with SingleTickerProviderStateMixin {
  DateTime? selectedFromDate;
  DateTime? selectedToDate;

  late final TabController _tabController;
  late OrdersController ordersController;

  static const List<String> _tabs = [
    'All',
    'Delivered',
    'Canceled',
    'Disputed',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    ordersController = OrdersController(dio: Dio());
    
    // Fetch delivered orders on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ordersController.fetchOrders(
          statusId: 4, // Delivered status
          executeClear: true,
        );
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    ordersController.dispose();
    super.dispose();
  }

  List<ClientOrder> _filterByTab(List<ClientOrder> all, int tabIndex) {
    if (tabIndex == 0) return all;

    final tab = _tabs[tabIndex].toLowerCase();

    return all.where((order) {
      final status = (order.statusName ?? '').toLowerCase();

      if (tab == 'delivered') {
        return status.contains('delivered');
      }
      if (tab == 'canceled') {
        return status.contains('cancel');
      }
      if (tab == 'disputed') {
        return status.contains('dispute');
      }
      return true;
    }).toList();
  }

  List<ClientOrder> _applyDateFilter(List<ClientOrder> list) {
    final from = selectedFromDate;
    final to = selectedToDate;

    if (from == null && to == null) return list;

    DateTime dayStart(DateTime d) => DateTime(d.year, d.month, d.day);
    DateTime dayEnd(DateTime d) => DateTime(d.year, d.month, d.day, 23, 59, 59);

    return list.where((order) {
      final d = order.issueTime?.toLocal();
      if (d == null) return false;
      if (from != null && d.isBefore(dayStart(from))) return false;
      if (to != null && d.isAfter(dayEnd(to))) return false;
      return true;
    }).toList();
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
            fromDeliveryMan: true,
            screenHeight: screenHeight,
            screenWidth: screenWidth,
            title: 'History',
            is_returned: true,
          ),
          Positioned.fill(
            top: MediaQuery.of(context).padding.top + screenHeight * .1,
            bottom: screenHeight * .05,
            child: Padding(
              padding: EdgeInsets.only(
                top: screenHeight * .03,
                bottom: screenHeight * .1,
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: screenWidth * .06,
                  right: screenWidth * .06,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [


                    // ✅ Tabs
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * .004,
                        horizontal: screenWidth * .004,
                      ),
                      margin: EdgeInsets.only(bottom: screenHeight * .02),
                      height: screenHeight * .05,
                      decoration: BoxDecoration(
                        color: AppColors.tabViewBackground,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TabBar(
                        isScrollable: true,
                        padding: EdgeInsets.zero,
                        labelPadding: EdgeInsets.symmetric(horizontal: screenWidth * .03),
                        controller: _tabController,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.whiteColor,
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Colors.transparent,
                        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                        labelColor: AppColors.primary,
                        unselectedLabelColor: AppColors.greyDarktextIntExtFieldAndIconsHome,
                        tabs: _tabs.map((t) => Tab(text: t)).toList(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: screenHeight * .02),
                      child: customCouponAlertTitle(
                        'Orders History',
                        screenWidth,
                        screenHeight,
                      ),
                    ),
                    // ✅ Date Filter ثابت فوق
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            customCouponAlertTitle('From', screenWidth, screenHeight),
                            GestureDetector(
                              onTap: () async {
                                final now = DateTime.now();
                                final results = await showCalendarDatePicker2Dialog(
                                  context: context,
                                  value: [
                                    selectedFromDate ?? DateTime(now.year, now.month, now.day),
                                  ],
                                  dialogSize: Size(screenWidth * 0.9, screenHeight * 0.55),
                                  borderRadius: BorderRadius.circular(16),
                                  config: CalendarDatePicker2WithActionButtonsConfig(
                                    calendarType: CalendarDatePicker2Type.single,
                                    selectedDayHighlightColor: AppColors.primary,
                                  ),
                                );

                                if (results != null && results.isNotEmpty && results.first != null) {
                                  setState(() {
                                    selectedFromDate = results.first;
                                    if (selectedToDate != null &&
                                        selectedToDate!.isBefore(selectedFromDate!)) {
                                      selectedToDate = null;
                                    }
                                  });
                                }
                              },
                              child: buildFilterDateWidget(
                                screenHeight,
                                screenWidth,
                                selectedDate: selectedFromDate,
                                onClear: () async {
                                  if (selectedFromDate == null) return;
                                  setState(() => selectedFromDate = null);
                                },
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            customCouponAlertTitle('To', screenWidth, screenHeight),
                            GestureDetector(
                              onTap: () async {
                                final now = DateTime.now();
                                final results = await showCalendarDatePicker2Dialog(
                                  context: context,
                                  value: [
                                    selectedToDate ??
                                        selectedFromDate ??
                                        DateTime(now.year, now.month, now.day),
                                  ],
                                  dialogSize: Size(screenWidth * 0.9, screenHeight * 0.55),
                                  borderRadius: BorderRadius.circular(16),
                                  config: CalendarDatePicker2WithActionButtonsConfig(
                                    calendarType: CalendarDatePicker2Type.single,
                                    selectedDayHighlightColor: AppColors.primary,
                                  ),
                                );

                                if (results != null && results.isNotEmpty && results.first != null) {
                                  final picked = results.first as DateTime;

                                  if (selectedFromDate != null && picked.isBefore(selectedFromDate!)) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('To date cannot be before From date'),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                    return;
                                  }

                                  setState(() => selectedToDate = picked);
                                }
                              },
                              child: buildFilterDateWidget(
                                screenHeight,
                                screenWidth,
                                selectedDate: selectedToDate,
                                onClear: () async {
                                  if (selectedToDate == null) return;
                                  setState(() => selectedToDate = null);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: screenHeight * .02),

                    // ✅ Orders history list
                    Expanded(
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
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    ordersController.error!,
                                    style: const TextStyle(color: Colors.red),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () {
                                      ordersController.fetchOrders(
                                        statusId: 4,
                                        executeClear: true,
                                      );
                                    },
                                    child: Text('Retry'),
                                  ),
                                ],
                              ),
                            );
                          }

                          return TabBarView(
                            controller: _tabController,
                            children: List.generate(_tabs.length, (tabIndex) {
                              final allOrders = ordersController.orders;
                              final filteredByTab = _filterByTab(allOrders, tabIndex);
                              final finalList = _applyDateFilter(filteredByTab);

                              if (finalList.isEmpty) {
                                return Center(
                                  child: Text(
                                    'No orders found',
                                    style: TextStyle(
                                      fontSize: screenWidth * .04,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              }

                              return RefreshIndicator(
                                color: AppColors.primary,
                                onRefresh: () async {
                                  await ordersController.fetchOrders(
                                    statusId: tabIndex == 0 ? null : (tabIndex == 1 ? 4 : tabIndex == 2 ? 5 : 6),
                                    executeClear: true,
                                  );
                                },
                                child: ListView.builder(
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  padding: EdgeInsets.only(bottom: screenHeight * .06),
                                  itemCount: finalList.length,
                                  itemBuilder: (context, index) {
                                    final order = finalList[index];
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: screenHeight * .015),
                                      child: BuildOrderDeliveryCard(
                                        context,
                                        screenHeight,
                                        screenWidth,
                                        order.statusName ?? 'Unknown',
                                        order.isPaid == true ? 'Paid' : 'Pending Payment',
                                        order: order,
                                      ),
                                    );
                                  },
                                ),
                              );
                            }),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
