import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../../core/services/auth_service.dart';
import 'package:newwwwwwww/features/auth/presentation/bloc/login_bloc.dart';

import '../../domain/models/bundle_purchase.dart';
import '../../domain/models/coupons_models.dart';
import '../../data/models/scheduled_order_model.dart';
import '../../data/datasources/scheduled_order_remote_datasource.dart';

class CouponsQuery {
  final int? productVsid;
  final int? vendorId;
  final String? status;

  const CouponsQuery({this.productVsid, this.vendorId, this.status});

  Map<String, dynamic> toQueryParams({
    required int pageNumber,
    required int pageSize,
  }) {
    return {
      if (productVsid != null) 'productVsid': productVsid,
      if (vendorId != null) 'vendorId': vendorId,
      if (status != null && status!.trim().isNotEmpty) 'status': status,
      'pageNumber': pageNumber,
      'pageSize': pageSize,
    };
  }
}

class CouponsController extends ChangeNotifier {
  final Dio dio;
  late final ScheduledOrderRemoteDataSource _scheduledOrderDataSource;

  CouponsController({required this.dio}) {
    debugPrint('🔥 CouponsController created');
    _scheduledOrderDataSource = ScheduledOrderRemoteDataSourceImpl(dio: dio);
  }

  // ---------------- COUPONS ----------------
  final List<WalletCoupon> coupons = [];

  bool isLoading = false;
  bool isLoadingMore = false;
  String? error;

  int pageNumber = 1;
  int pageSize = 20;

  int totalPages = 1;
  int totalCount = 0;

  CouponsQuery _query = const CouponsQuery();

  bool get hasMore => pageNumber < totalPages;

  /// ✅ جلب كل الصفحات مرة واحدة (عشان آخر delivery_man يبقى صح)
  Future<void> fetchAllCoupons() async {
    if (isLoading) return;

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      coupons.clear();
      pageNumber = 1;
      totalPages = 1;
      totalCount = 0;

      final token = await AuthService.getToken();
      if (token == null) {
        error = 'Authentication required';
        return;
      }

      final url = '$base_url/v1/client/wallet/coupons';

      int currentPage = 1;
      int pages = 1;

      while (currentPage <= pages) {
        final response = await dio.get(
          url,
          queryParameters: _query.toQueryParams(
            pageNumber: currentPage,
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

          final parsed = WalletCouponsResponse.fromJson(data);

          totalCount = parsed.totalCount;
          totalPages = parsed.totalPages;
          pages = parsed.totalPages;

          coupons.addAll(parsed.coupons);

          currentPage += 1;
        } else {
          error = 'Failed to load coupons (status: ${response.statusCode})';
          break;
        }
      }

      // Optional sort
      coupons.sort((a, b) => a.productName.compareTo(b.productName));
    } on DioException catch (e) {
      final data = e.response?.data;
      String msg = 'Failed to load coupons';

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

  Future<void> refreshAll() async {
    await Future.wait([
      fetchAllCoupons(),
      refreshBundlePurchases(),
    ]);
  }

  // ---------------- LAST DELIVERY (DAY + HOUR) ----------------

  DateTime? _parseDeliveredAtLocal(WalletCoupon c) {
    final deliveredAtRaw = c.proofOfDelivery?.deliveredAt;

    if (deliveredAtRaw == null) return null;

    // لو موديلك DateTime? بدل String؟ (لو كده عدل الجزء ده)
    if (deliveredAtRaw is DateTime) {
      return deliveredAtRaw.toLocal();
    }

    if (deliveredAtRaw is String) {
      final dt = deliveredAtRaw;
      return dt?.toLocal();
    }

    return null;
  }

  DateTime _dayHourKey(DateTime dt) => DateTime(dt.year, dt.month, dt.day, dt.hour);

  /// ✅ ترجع كل الكوبونات اللي اتسلمت في "آخر day+hour" لنفس bundleId
  /// - لو مفيش deliveredAt لأي كوبون → ترجع []
  List<WalletCoupon> getCouponsInLastDeliveryDayHour(int bundleId) {
    final related = coupons.where((c) => c.bundlePurchaseId == bundleId).toList();
    if (related.isEmpty) return [];

    DateTime? maxKey;

    for (final c in related) {
      final deliveredLocal = _parseDeliveredAtLocal(c);
      if (deliveredLocal == null) continue;

      final key = _dayHourKey(deliveredLocal);
      if (maxKey == null || key.isAfter(maxKey!)) {
        maxKey = key;
      }
    }

    if (maxKey == null) return [];

    final result = related.where((c) {
      final deliveredLocal = _parseDeliveredAtLocal(c);
      if (deliveredLocal == null) return false;
      return _dayHourKey(deliveredLocal) == maxKey;
    }).toList();

    // optional: sort by vendorSku or id
    result.sort((a, b) => a.id.compareTo(b.id));
    return result;
  }

  // ---------------- BUNDLE PURCHASES ----------------
  final List<BundlePurchase> bundlePurchases = [];

  bool isLoadingBundles = false;
  bool isLoadingMoreBundles = false;

  String? bundlesError;

  int bundlesPageNumber = 1;
  int bundlesPageSize = 20;

  bool bundlesHasMore = true;

  Future<void> refreshBundlePurchases() async {
    bundlesPageNumber = 1;
    bundlesHasMore = true;
    bundlePurchases.clear();
    bundlesError = null;
    notifyListeners();

    await fetchBundlePurchases();
  }

  Future<void> fetchBundlePurchases() async {
    if (isLoadingBundles) return;

    isLoadingBundles = true;
    bundlesError = null;
    notifyListeners();

    try {
      final token = await AuthService.getToken();
      if (token == null) {
        bundlesError = 'Authentication required';
        return;
      }

      final url = '$base_url/v1/client/wallet/bundle-purchases';

      final response = await dio.get(
        url,
        queryParameters: {
          'pageNumber': bundlesPageNumber,
          'pageSize': bundlesPageSize,
        },
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
            .map((e) => BundlePurchase.fromJson(e as Map<String, dynamic>))
            .toList();

        bundlePurchases.addAll(items);

        if (items.length < bundlesPageSize) bundlesHasMore = false;
      } else {
        bundlesError =
        'Failed to load bundle purchases (status: ${response.statusCode})';
      }
    } on DioException catch (e) {
      bundlesError = e.message ?? 'Failed to load bundle purchases';
    } catch (e) {
      bundlesError = 'An unexpected error occurred: $e';
    } finally {
      isLoadingBundles = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreBundlePurchases() async {
    if (isLoadingMoreBundles || isLoadingBundles) return;
    if (!bundlesHasMore) return;

    isLoadingMoreBundles = true;
    bundlesError = null;
    notifyListeners();

    try {
      bundlesPageNumber += 1;

      final token = await AuthService.getToken();
      if (token == null) {
        bundlesError = 'Authentication required';
        return;
      }

      // ✅ خليها نفس شكل endpoint الأساسي لو ده الصحيح عندك
      final url = '$base_url/v1/client/wallet/bundle-purchases';

      final response = await dio.get(
        url,
        queryParameters: {
          'pageNumber': bundlesPageNumber,
          'pageSize': bundlesPageSize,
        },
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
            .map((e) => BundlePurchase.fromJson(e as Map<String, dynamic>))
            .toList();

        bundlePurchases.addAll(items);
        if (items.length < bundlesPageSize) bundlesHasMore = false;
      } else {
        bundlesError =
        'Failed to load more bundle purchases (status: ${response.statusCode})';
      }
    } on DioException catch (e) {
      bundlesError = e.message ?? 'Failed to load more bundle purchases';
    } catch (e) {
      bundlesError = 'An unexpected error occurred: $e';
    } finally {
      isLoadingMoreBundles = false;
      notifyListeners();
    }
  }

  // ---------------- SCHEDULED ORDERS ----------------
  final List<ScheduledOrderModel> _scheduledOrders = [];
  bool _isLoadingSchedules = false;
  String? _schedulesError;

  List<ScheduledOrderModel> get scheduledOrders => _scheduledOrders;
  bool get isLoadingSchedules => _isLoadingSchedules;
  String? get schedulesError => _schedulesError;

  Future<void> fetchScheduledOrders() async {
    _isLoadingSchedules = true;
    _schedulesError = null;
    notifyListeners();

    try {
      _scheduledOrders.clear();
      final orders = await _scheduledOrderDataSource.getScheduledOrders();
      _scheduledOrders.addAll(orders);
      debugPrint('✅ Fetched ${orders.length} scheduled orders');
    } catch (e) {
      _schedulesError = e.toString();
      debugPrint('❌ Error fetching scheduled orders: $e');
    } finally {
      _isLoadingSchedules = false;
      notifyListeners();
    }
  }

  Future<ScheduledOrderModel?> createScheduledOrder({
    required int bundlePurchaseId,
    required int weeklyFrequency,
    required int bottlesPerDelivery,
    required List<ScheduleEntry> schedule,
    required int deliveryAddressId,
    required bool autoRenewEnabled,
    int? lowBalanceThreshold,
  }) async {
    try {
      final request = CreateScheduledOrderRequest(
        bundlePurchaseId: bundlePurchaseId,
        weeklyFrequency: weeklyFrequency,
        bottlesPerDelivery: bottlesPerDelivery,
        schedule: schedule,
        deliveryAddressId: deliveryAddressId,
        autoRenewEnabled: autoRenewEnabled,
        lowBalanceThreshold: lowBalanceThreshold,
      );

      final created = await _scheduledOrderDataSource.createScheduledOrder(request);
      
      await fetchScheduledOrders();
      
      debugPrint('✅ Created scheduled order #${created.id}');
      return created;
    } catch (e) {
      _schedulesError = e.toString();
      debugPrint('❌ Error creating scheduled order: $e');
      notifyListeners();
      return null;
    }
  }

  Future<ScheduledOrderModel?> updateScheduledOrder({
    required int id,
    int? weeklyFrequency,
    int? bottlesPerDelivery,
    List<ScheduleEntry>? schedule,
    int? deliveryAddressId,
    bool? autoRenewEnabled,
    int? lowBalanceThreshold,
  }) async {
    try {
      final request = UpdateScheduledOrderRequest(
        weeklyFrequency: weeklyFrequency,
        bottlesPerDelivery: bottlesPerDelivery,
        schedule: schedule,
        deliveryAddressId: deliveryAddressId,
        autoRenewEnabled: autoRenewEnabled,
        lowBalanceThreshold: lowBalanceThreshold,
      );

      final updated = await _scheduledOrderDataSource.updateScheduledOrder(id, request);
      
      await fetchScheduledOrders();
      
      debugPrint('✅ Updated scheduled order #$id');
      return updated;
    } catch (e) {
      _schedulesError = e.toString();
      debugPrint('❌ Error updating scheduled order: $e');
      notifyListeners();
      return null;
    }
  }

  Future<bool> deleteScheduledOrder(int id) async {
    try {
      await _scheduledOrderDataSource.deleteScheduledOrder(id);
      
      await fetchScheduledOrders();
      
      debugPrint('✅ Deleted scheduled order #$id');
      return true;
    } catch (e) {
      _schedulesError = e.toString();
      debugPrint('❌ Error deleting scheduled order: $e');
      notifyListeners();
      return false;
    }
  }

  ScheduledOrderModel? getScheduleForBundle(int bundlePurchaseId) {
    try {
      return _scheduledOrders.firstWhere(
        (s) => s.bundlePurchaseId == bundlePurchaseId && s.isActive,
      );
    } catch (e) {
      return null;
    }
  }

  List<ScheduledOrderModel> getSchedulesForBundle(int bundlePurchaseId) {
    return _scheduledOrders.where((s) => s.bundlePurchaseId == bundlePurchaseId).toList();
  }

  // Deprecated methods for backward compatibility
  @Deprecated('Use getScheduleForBundle instead')
  ScheduledOrderModel? getScheduleForProduct(int productVsid) {
    try {
      return _scheduledOrders.firstWhere(
        (s) => s.productVsid == productVsid && s.isActive,
      );
    } catch (e) {
      return null;
    }
  }

  @Deprecated('Use getSchedulesForBundle instead')
  List<ScheduledOrderModel> getSchedulesForProduct(int productVsid) {
    return _scheduledOrders.where((s) => s.productVsid == productVsid).toList();
  }
}
