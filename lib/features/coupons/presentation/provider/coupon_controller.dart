import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../../core/services/auth_service.dart';
import 'package:newwwwwwww/features/auth/presentation/bloc/login_bloc.dart';

import '../../domain/models/bundle_purchase.dart';
import '../../domain/models/coupons_models.dart';

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

  CouponsController({required this.dio}) {
    debugPrint('🔥 CouponsController created');
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

  Future<void> refresh() async {
    debugPrint('🔄 Refresh coupons');
    pageNumber = 1;
    totalPages = 1;
    totalCount = 0;
    coupons.clear();
    error = null;
    notifyListeners();

    await fetchCoupons(isRefresh: true);
  }

  Future<void> fetchCoupons({bool isRefresh = false}) async {
    if (isLoading) return;

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final token = await AuthService.getToken();
      if (token == null) {
        error = 'Authentication required';
        return;
      }

      // ✅ FIX URL (use same correct endpoint everywhere)
      final url = '$base_url/v1/client/wallet/coupons';

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
        final data = response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : <String, dynamic>{};

        final parsed = WalletCouponsResponse.fromJson(data);

        totalCount = parsed.totalCount;
        totalPages = parsed.totalPages;
        pageNumber = parsed.pageNumber;
        pageSize = parsed.pageSize;

        coupons.addAll(parsed.coupons);
        coupons.sort((a, b) => a.productName.compareTo(b.productName));
      } else {
        error = 'Failed to load coupons (status: ${response.statusCode})';
      }
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

  Future<void> loadMore() async {
    if (isLoadingMore || isLoading) return;
    if (!hasMore) return;

    isLoadingMore = true;
    error = null;
    notifyListeners();

    try {
      final nextPage = pageNumber + 1;

      final token = await AuthService.getToken();
      if (token == null) {
        error = 'Authentication required';
        return;
      }

      final url = '$base_url/v1/client/wallet/coupons';

      final response = await dio.get(
        url,
        queryParameters: _query.toQueryParams(
          pageNumber: nextPage,
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
        pageNumber = parsed.pageNumber;
        pageSize = parsed.pageSize;

        coupons.addAll(parsed.coupons);
        coupons.sort((a, b) => a.productName.compareTo(b.productName));
      } else {
        error = 'Failed to load more coupons (status: ${response.statusCode})';
      }
    } on DioException catch (e) {
      error = 'Failed to load more coupons';
    } catch (e) {
      error = 'An unexpected error occurred: $e';
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }

  /// ✅ IMPORTANT: Get coupon related to bundlePurchaseId
  WalletCoupon? getCouponByBundleId(int bundleId) {
    for (final c in coupons) {
      if (c.productVsid == bundleId) return c;
    }
    return null;
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

      final url = '$base_url/api/v1/client/wallet/bundle-purchases';

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



}
