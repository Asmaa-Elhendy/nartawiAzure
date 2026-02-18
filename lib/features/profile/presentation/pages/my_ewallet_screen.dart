import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../core/services/dio_service.dart';
import '../../../../../l10n/app_localizations.dart';
import 'package:newwwwwwww/features/profile/presentation/widgets/filter_date_widget.dart';
import 'package:newwwwwwww/features/profile/presentation/widgets/transaction_card.dart';

import '../../../../core/theme/colors.dart';
import '../../../coupons/presentation/widgets/custom_text.dart';
import '../../../home/presentation/widgets/background_home_Appbar.dart';
import '../../../home/presentation/widgets/build_ForegroundAppBarHome.dart';
import '../../domain/models/wallet_transaction.dart';
import '../provider/wallet_transaction_controller.dart';
import '../widgets/e_wallet_card.dart';



class MyeWalletScreen extends StatefulWidget {
  const MyeWalletScreen({super.key});

  @override
  State<MyeWalletScreen> createState() => _MyeWalletScreenState();
}

class _MyeWalletScreenState extends State<MyeWalletScreen>
    with SingleTickerProviderStateMixin {
  late final WalletTransactionsController _txController;
  final ScrollController _scrollController = ScrollController();

  DateTime? selectedFromDate;
  DateTime? selectedToDate;

  @override
  void initState() {
    super.initState();

    _txController = WalletTransactionsController(dio: DioService.dio);
    _txController.fetchTransactions(reset: true);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _txController.loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _txController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    await _txController.refreshAll();
  }

  Future<void> _applyFilterAndFetch() async {
    _txController.setDateFilter(
      fromDate: selectedFromDate,
      toDate: selectedToDate,
    );
    await _txController.fetchTransactions(reset: true);
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
            title:  AppLocalizations.of(context)!.myEWallet,
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
              child: RefreshIndicator(
                color: AppColors.primary,
                onRefresh: _handleRefresh,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: screenWidth * .06,
                      bottom: screenHeight * .04,
                      right: screenWidth * .06,
                    ),
                    child: AnimatedBuilder(
                      animation: _txController,
                      builder: (context, _) {
                        final txs = _txController.transactions;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            eWalletCard(context, screenWidth, screenHeight),

                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: screenHeight * .02,
                              ),
                              child: customCouponAlertTitle(
                                 AppLocalizations.of(context)!.transactionHistory,
                                screenWidth,
                                screenHeight,
                              ),
                            ),

                            // ----------------- FILTER ROW -----------------
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // FROM
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    customCouponAlertTitle(
                                       AppLocalizations.of(context)!.from,
                                      screenWidth,
                                      screenHeight,//j
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        final now = DateTime.now();

                                        final results =
                                        await showCalendarDatePicker2Dialog(
                                          context: context,
                                          value: [
                                            selectedFromDate ??
                                                DateTime(
                                                    now.year, now.month, now.day),
                                          ],
                                          dialogSize: Size(screenWidth * 0.9,
                                              screenHeight * 0.55),
                                          borderRadius:
                                          BorderRadius.circular(16),
                                          config:
                                          CalendarDatePicker2WithActionButtonsConfig(
                                            calendarType:
                                            CalendarDatePicker2Type.single,
                                            selectedDayHighlightColor:
                                            AppColors.primary,
                                          ),
                                        );

                                        if (results != null &&
                                            results.isNotEmpty &&
                                            results.first != null) {
                                          setState(() {
                                            selectedFromDate = results.first;

                                            if (selectedToDate != null &&
                                                selectedToDate!.isBefore(
                                                    selectedFromDate!)) {
                                              selectedToDate = null;
                                            }
                                          });

                                          await _applyFilterAndFetch();
                                        }
                                      },
                                      child: buildFilterDateWidget(
                                        screenHeight,
                                        screenWidth,
                                        selectedDate: selectedFromDate,
                                        onClear: () async {
                                          if (selectedFromDate == null) return;

                                          setState(() {
                                            selectedFromDate = null;
                                          });

                                          await _applyFilterAndFetch();
                                        },
                                      ),

                                    ),
                                  ],
                                ),

                                // TO
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    customCouponAlertTitle(
                                       AppLocalizations.of(context)!.to,
                                      screenWidth,
                                      screenHeight,
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        final now = DateTime.now();

                                        final results =
                                        await showCalendarDatePicker2Dialog(
                                          context: context,
                                          value: [
                                            selectedToDate ??
                                                selectedFromDate ??
                                                DateTime(
                                                    now.year, now.month, now.day),
                                          ],
                                          dialogSize: Size(screenWidth * 0.9,
                                              screenHeight * 0.55),
                                          borderRadius:
                                          BorderRadius.circular(16),
                                          config:
                                          CalendarDatePicker2WithActionButtonsConfig(
                                            calendarType:
                                            CalendarDatePicker2Type.single,
                                            selectedDayHighlightColor:
                                            AppColors.primary,
                                          ),
                                        );

                                        if (results != null &&
                                            results.isNotEmpty &&
                                            results.first != null) {
                                          final picked = results.first as DateTime;

                                          if (selectedFromDate != null &&
                                              picked.isBefore(selectedFromDate!)) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                     AppLocalizations.of(context)!.toDateCannotBeBeforeFrom),
                                                behavior:
                                                SnackBarBehavior.floating,
                                              ),
                                            );
                                            return;
                                          }

                                          setState(() {
                                            selectedToDate = picked;
                                          });

                                          await _applyFilterAndFetch();
                                        }
                                      },
                                      child: buildFilterDateWidget(
                                        screenHeight,
                                        screenWidth,
                                        selectedDate: selectedToDate,
                                        onClear: () async {
                                          if (selectedToDate == null) return;

                                          setState(() {
                                            selectedToDate = null;
                                          });

                                          await _applyFilterAndFetch();
                                        },
                                      ),

                                    ),
                                  ],
                                ),
                              ],
                            ),

                            SizedBox(height: screenHeight * .02),

                            // ----------------- STATES -----------------
                            if (_txController.isLoading && txs.isEmpty)
                              Padding(
                                padding: EdgeInsets.only(top: screenHeight * .12),
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.primary),
                                ),
                              ),

                            if (_txController.error != null && txs.isEmpty)
                              Padding(
                                padding: EdgeInsets.only(top: screenHeight * .12),
                                child: Text(
                                  _txController.error!,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),

                            if (!_txController.isLoading &&
                                _txController.error == null &&
                                txs.isEmpty)
                              Padding(
                                padding: EdgeInsets.only(top: screenHeight * .12),
                                child: Text(
                                   AppLocalizations.of(context)!.noTransactionsFound,
                                  style: TextStyle(
                                    fontSize: screenWidth * .04,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),

                            // ----------------- LIST -----------------
                            if (txs.isNotEmpty)
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: txs.length +
                                    (_txController.isLoadingMore ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index >= txs.length) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: screenHeight * .02,
                                      ),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          valueColor:
                                          AlwaysStoppedAnimation<Color>(
                                              AppColors.primary),
                                        ),
                                      ),
                                    );
                                  }

                                  final WalletTransaction tx = txs[index];

                                  // ✅ Option A: if TransactionCard accepts tx
                                  return TransactionCard(
                                    screenHeight,
                                    screenWidth,
                                    tx, // <-- add this param in your widget
                                  );

                                  // ✅ Option B: if your TransactionCard is fixed now, keep it:
                                  // return TransactionCard(screenHeight, screenWidth);
                                },
                              ),

                            SizedBox(height: screenHeight * .02),
                          ],
                        );
                      },
                    ),
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
