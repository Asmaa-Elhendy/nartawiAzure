import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../../core/services/auth_service.dart';
import 'package:newwwwwwww/features/auth/presentation/bloc/login_bloc.dart';
import '../../domain/models/wallet_transaction7.dart';

class WalletTransactionsQuery {
  final DateTime? fromDate;
  final DateTime? toDate;

  const WalletTransactionsQuery({this.fromDate, this.toDate});

  // ✅ helpers: start/end of day (LOCAL) then convert to UTC ISO
  static String _toIsoStartOfDayUtc(DateTime d) {
    final local = DateTime(d.year, d.month, d.day, 0, 0, 0);
    return local.toUtc().toIso8601String();
  }

  static String _toIsoEndOfDayUtc(DateTime d) {
    final local = DateTime(d.year, d.month, d.day, 23, 59, 59, 999);
    return local.toUtc().toIso8601String();
  }

  Map<String, dynamic> toQueryParams({
    required int pageNumber,
    required int pageSize,
  }) {
    return {
      if (fromDate != null) 'fromDate': _toIsoStartOfDayUtc(fromDate!),
      if (toDate != null) 'toDate': _toIsoEndOfDayUtc(toDate!),
      'pageNumber': pageNumber,
      'pageSize': pageSize,
    };
  }

  WalletTransactionsQuery copyWith({
    DateTime? fromDate,
    DateTime? toDate,
    bool clearFromDate = false,
    bool clearToDate = false,
  }) {
    return WalletTransactionsQuery(
      fromDate: clearFromDate ? null : (fromDate ?? this.fromDate),
      toDate: clearToDate ? null : (toDate ?? this.toDate),
    );
  }
}

class WalletTransactionsController extends ChangeNotifier {
  final Dio dio;

  WalletTransactionsController({required this.dio}) {
    debugPrint('🔥 WalletTransactionsController created');
  }

  final List<WalletTransaction> transactions = [];

  bool isLoading = false;
  bool isLoadingMore = false;
  String? error;

  int pageNumber = 1;
  int pageSize = 20;

  bool hasMore = true;

  WalletTransactionsQuery _query = const WalletTransactionsQuery();

  void setDateFilter({DateTime? fromDate, DateTime? toDate}) {
    _query = WalletTransactionsQuery(fromDate: fromDate, toDate: toDate);

    pageNumber = 1;
    hasMore = true;
    transactions.clear();
    notifyListeners();
  }


  Future<void> fetchTransactions({bool reset = false}) async {
    if (isLoading) return;

    if (reset) {
      pageNumber = 1;
      hasMore = true;
      transactions.clear();
    }

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final token = await AuthService.getToken();
      if (token == null) {
        error = 'Authentication required';
        return;
      }

      final url = '$base_url/v1/client/wallet/transactions';

      final response = await dio.get(
        url,
        queryParameters: _query.toQueryParams(
          pageNumber: pageNumber,
          pageSize: pageSize,
        ),
        options: Options(
          headers: {
            'accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final raw = response.data;
        final List<dynamic> list = raw is List ? raw : <dynamic>[];

        final items = list
            .map((e) => WalletTransaction.fromJson(e as Map<String, dynamic>))
            .toList();

        transactions.addAll(items);

        // ✅ pagination rule
        if (items.length < pageSize) hasMore = false;
      } else {
        error = 'Failed to load transactions (status: ${response.statusCode})';
      }
    } on DioException catch (e) {
      final data = e.response?.data;
      String msg = 'Failed to load transactions';

      if (data is Map && data['title'] != null) {
        msg = data['title'].toString();
      } else if (data is Map && data['message'] != null) {
        msg = data['message'].toString();
      } else if (e.message != null) {
        msg = e.message!;
      }

      error = msg;
    } catch (e) {
      error = 'An unexpected error occurred: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (isLoadingMore || isLoading) return;
    if (!hasMore) return;

    isLoadingMore = true;
    error = null;
    notifyListeners();

    try {
      pageNumber += 1;

      final token = await AuthService.getToken();
      if (token == null) {
        error = 'Authentication required';
        return;
      }

      final url = '$base_url/v1/client/wallet/transactions';

      final response = await dio.get(
        url,
        queryParameters: _query.toQueryParams(
          pageNumber: pageNumber,
          pageSize: pageSize,
        ),
        options: Options(
          headers: {
            'accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final raw = response.data;
        final List<dynamic> list = raw is List ? raw : <dynamic>[];

        final items = list
            .map((e) => WalletTransaction.fromJson(e as Map<String, dynamic>))
            .toList();

        transactions.addAll(items);

        if (items.length < pageSize) hasMore = false;
      } else {
        error =
        'Failed to load more transactions (status: ${response.statusCode})';
      }
    } on DioException catch (e) {
      error = e.message ?? 'Failed to load more transactions';
    } catch (e) {
      error = 'An unexpected error occurred: $e';
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> refreshAll() async {
    await fetchTransactions(reset: true);
  }
}
