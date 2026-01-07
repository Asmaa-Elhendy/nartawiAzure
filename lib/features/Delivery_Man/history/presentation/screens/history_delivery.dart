import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:newwwwwwww/features/profile/presentation/widgets/transaction_card.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../coupons/presentation/widgets/custom_text.dart';
import '../../../../home/presentation/widgets/background_home_Appbar.dart';
import '../../../../home/presentation/widgets/build_ForegroundAppBarHome.dart';
import '../../../../profile/domain/models/wallet_transaction.dart';
import '../../../../profile/presentation/widgets/filter_date_widget.dart';

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

  static const List<String> _tabs = [
    'All',
    'Delivered',
    'Cancelled',
    'Disputed',
  ];

  // ✅ Static list
  late final List<WalletTransaction> txs = [
    WalletTransaction(
      id: 101,
      type: 'TopUp',
      amount: 150,
      currency: 'QAR',
      description: 'Wallet Top Up',
      linkedAccountName: 'Mohamed Ali',
      issuedAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      completedAt: DateTime.now().subtract(const Duration(days: 1, hours: 1)),
      status: 'Completed',
    ),
    WalletTransaction(
      id: 102,
      type: 'BundlePurchase',
      amount: -45,
      currency: 'QAR',
      description: 'Bundle Purchase',
      linkedAccountName: 'Ahmed',
      issuedAt: DateTime.now().subtract(const Duration(days: 2, hours: 3)),
      completedAt: DateTime.now().subtract(
        const Duration(days: 2, hours: 2, minutes: 30),
      ),
      status: 'Delivered',
    ),
    WalletTransaction(
      id: 103,
      type: 'Transfer',
      amount: -20,
      currency: 'QAR',
      description: 'Transfer to Seller',
      linkedAccountName: 'Ali Mostafa',
      issuedAt: DateTime.now().subtract(const Duration(days: 4, hours: 5)),
      completedAt: null,
      status: 'Pending',
    ),
    WalletTransaction(
      id: 104,
      type: 'Refund',
      amount: 30,
      currency: 'QAR',
      description: 'Order Refund',
      linkedAccountName: 'Gamal',
      issuedAt: DateTime.now().subtract(const Duration(days: 6, hours: 1)),
      completedAt: DateTime.now().subtract(const Duration(days: 6)),
      status: 'Cancelled',
    ),
    WalletTransaction(
      id: 105,
      type: 'Refund',
      amount: 30,
      currency: 'QAR',
      description: 'Order Dispute',
      linkedAccountName: 'Hany',
      issuedAt: DateTime.now().subtract(const Duration(days: 7, hours: 1)),
      completedAt: null,
      status: 'Disputed',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ✅ فلترة التابات حسب status الحقيقي
  List<WalletTransaction> _filterByTab(List<WalletTransaction> all, int tabIndex) {
    if (tabIndex == 0) return all;

    final tab = _tabs[tabIndex].toLowerCase();

    return all.where((t) {
      final s = t.status.toLowerCase();

      if (tab == 'delivered') {
        // ✅ Delivered تشمل Completed كمان
        return s.contains('delivered') || s.contains('completed');
      }
      if (tab == 'cancelled') {
        return s.contains('cancel'); // cancelled/canceled
      }
      if (tab == 'disputed') {
        return s.contains('dispute');
      }
      return true;
    }).toList();
  }

  // ✅ فلترة بالتاريخ (اختياري)
  List<WalletTransaction> _applyDateFilter(List<WalletTransaction> list) {
    final from = selectedFromDate;
    final to = selectedToDate;

    if (from == null && to == null) return list;

    DateTime dayStart(DateTime d) => DateTime(d.year, d.month, d.day);
    DateTime dayEnd(DateTime d) => DateTime(d.year, d.month, d.day, 23, 59, 59);

    return list.where((t) {
      final d = (t.completedAt ?? t.issuedAt).toLocal();
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

                    // ✅ Scroll الحقيقي للـ transactions
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: List.generate(_tabs.length, (tabIndex) {
                          final filteredByTab = _filterByTab(txs, tabIndex);
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

                          return ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.only(bottom: screenHeight * .06),
                            itemCount: finalList.length,
                            itemBuilder: (context, index) {
                              final tx = finalList[index];
                              return TransactionCard(
                                screenHeight,
                                screenWidth,
                                tx,
                                fromDeliveryMan: true,
                              );
                            },
                          );
                        }),
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
