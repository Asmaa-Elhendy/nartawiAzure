import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../../core/services/auth_service.dart';
import 'package:newwwwwwww/features/auth/presentation/bloc/login_bloc.dart';
import '../../domain/models/order_model.dart';

class OrdersQuery {
  final int? statusId;
  final DateTime? fromDate;
  final DateTime? toDate;

  final int? issuedByAccountId;
  final int? terminalId;
  final bool? isPaid;

  final String? orderReference;
  final String? searchTerm;

  final String? sortBy; // date_asc | status | total | null(default newest)
  final bool? isDescending;

  const OrdersQuery({
    this.statusId,
    this.fromDate,
    this.toDate,
    this.issuedByAccountId,
    this.terminalId,
    this.isPaid,
    this.orderReference,
    this.searchTerm,
    this.sortBy,
    this.isDescending,
  });

  Map<String, dynamic> toQueryParams({
    required int pageIndex,
    required int pageSize,
  }) {
    String? dt(DateTime? d) => d?.toUtc().toIso8601String();

    return {
      if (statusId != null) 'statusId': statusId,
      if (fromDate != null) 'fromDate': dt(fromDate),
      if (toDate != null) 'toDate': dt(toDate),

      if (issuedByAccountId != null) 'issuedByAccountId': issuedByAccountId,
      if (terminalId != null) 'terminalId': terminalId,
      if (isPaid != null) 'isPaid': isPaid,

      if (orderReference != null && orderReference!.trim().isNotEmpty)
        'orderReference': orderReference,

      if (searchTerm != null && searchTerm!.trim().isNotEmpty)
        'searchTerm': searchTerm,

      if (sortBy != null && sortBy!.trim().isNotEmpty) 'sortBy': sortBy,
      if (isDescending != null) 'isDescending': isDescending,

      // pagination
      'pageIndex': pageIndex,
      'pageSize': pageSize,
    };
  }
}

class OrdersController extends ChangeNotifier {
  final Dio dio;

  OrdersController({required this.dio}) {
    debugPrint('🔥 OrdersController created');
  }

  // ---------------- ORDERS ----------------
  final List<ClientOrder> orders = [];

  bool isLoading = false;
  bool isLoadingMore = false;
  String? error;

  int pageIndex = 1;
  int pageSize = 10;

  int totalPages = 1;
  int totalCount = 0;

  OrdersQuery _query = const OrdersQuery();

  bool get hasMore => pageIndex < totalPages;

  void setQuery(OrdersQuery query) {
    _query = query;
  }

  Future<void> fetchOrders({OrdersQuery? query, bool executeClear = true}) async {
    if (isLoading) return;

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      if (query != null) _query = query;

      if (executeClear) {
        orders.clear();
        pageIndex = 1;
        totalPages = 1;
        totalCount = 0;
      }

      final token = await AuthService.getToken();
      if (token == null) {
        error = 'Authentication required';
        return;
      }

      final url = '$base_url/v1/client/orders';

      final response = await dio.get(
        url,
        queryParameters: _query.toQueryParams(
          pageIndex: pageIndex,
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
        final data = response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : <String, dynamic>{};

        final parsed = ClientOrdersResponse.fromJson(data);

        totalCount = parsed.totalCount;
        totalPages = parsed.totalPages;

        orders.addAll(parsed.items);
      } else {
        error = 'Failed to load orders (status: ${response.statusCode})';
      }
    } on DioException catch (e) {
      final data = e.response?.data;
      String msg = 'Failed to load orders';

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

  Future<void> refresh({OrdersQuery? query}) async {
    pageIndex = 1;
    await fetchOrders(query: query ?? _query, executeClear: true);
  }

  Future<void> loadMore() async {
    if (isLoadingMore || isLoading) return;
    if (!hasMore) return;

    isLoadingMore = true;
    error = null;
    notifyListeners();

    try {
      pageIndex += 1;

      final token = await AuthService.getToken();
      if (token == null) {
        error = 'Authentication required';
        return;
      }

      final url = '$base_url/v1/client/orders';

      final response = await dio.get(
        url,
        queryParameters: _query.toQueryParams(
          pageIndex: pageIndex,
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
        final data = response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : <String, dynamic>{};

        final parsed = ClientOrdersResponse.fromJson(data);

        totalCount = parsed.totalCount;
        totalPages = parsed.totalPages;

        orders.addAll(parsed.items);
      } else {
        error = 'Failed to load more orders (status: ${response.statusCode})';
      }
    } on DioException catch (e) {
      error = e.message ?? 'Failed to load more orders';
    } catch (e) {
      error = 'An unexpected error occurred: $e';
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }
}
