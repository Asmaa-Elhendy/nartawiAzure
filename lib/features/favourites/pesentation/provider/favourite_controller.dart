import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../../core/services/auth_service.dart';
import 'package:newwwwwwww/features/auth/presentation/bloc/login_bloc.dart';

import '../../domain/models/favorite_product.dart';
import '../../domain/models/favorite_vendor.dart'; // ✅ NEW

class FavoritesController extends ChangeNotifier {
  final Dio dio;

  FavoritesController({required this.dio}) {
    debugPrint('🔥 FavoritesController created');
  }

  // ---------------- PRODUCTS ----------------
  final List<FavoriteProduct> favorites = [];
  bool isLoading = false;
  String? error;

  // ---------------- VENDORS ----------------
  final List<FavoriteVendor> favoriteVendors = []; // ✅ NEW
  bool isLoadingVendors = false; // ✅ NEW
  String? vendorsError; // ✅ NEW

  /// ✅ GET /api/v1/client/favorites/products
  Future<void> fetchFavoriteProducts() async {
    if (isLoading) return;

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      favorites.clear();

      final token = await AuthService.getToken();
      if (token == null) {
        error = 'Authentication required';
        return;
      }

      final url = '$base_url/v1/client/favorites/products';

      final response = await dio.get(
        url,
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

        final parsed = list
            .whereType<Map<String, dynamic>>()
            .map((e) => FavoriteProduct.fromJson(e))
            .toList();

        favorites.addAll(parsed);

        // newest first
        favorites.sort((a, b) {
          final da = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          final db = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          return db.compareTo(da);
        });
      } else {
        error = 'Failed to load favorites (status: ${response.statusCode})';
      }
    } on DioException catch (e) {
      final data = e.response?.data;
      String msg = 'Failed to load favorites';

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

  /// ✅ NEW: GET /api/v1/client/favorites/vendors
  Future<void> fetchFavoriteVendors() async {
    if (isLoadingVendors) return;

    isLoadingVendors = true;
    vendorsError = null;
    notifyListeners();

    try {
      favoriteVendors.clear();

      final token = await AuthService.getToken();
      if (token == null) {
        vendorsError = 'Authentication required';
        return;
      }

      final url = '$base_url/v1/client/favorites/vendors';

      final response = await dio.get(
        url,
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

        final parsed = list
            .whereType<Map<String, dynamic>>()
            .map((e) => FavoriteVendor.fromJson(e))
            .toList();

        favoriteVendors.addAll(parsed);

        // newest first
        favoriteVendors.sort((a, b) {
          final da = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          final db = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          return db.compareTo(da);
        });
      } else {
        vendorsError =
        'Failed to load favorite vendors (status: ${response.statusCode})';
      }
    } on DioException catch (e) {
      final data = e.response?.data;
      String msg = 'Failed to load favorite vendors';

      if (data is Map && data['title'] != null) {
        msg = data['title'].toString();
      } else if (data is Map && data['message'] != null) {
        msg = data['message'].toString();
      } else if (e.message != null) {
        msg = e.message!;
      }

      vendorsError = msg;
    } catch (e) {
      vendorsError = 'An unexpected error occurred: $e';
    } finally {
      isLoadingVendors = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await Future.wait([
      fetchFavoriteProducts(),
      fetchFavoriteVendors(),
    ]);
  }

  bool isFavoritedVsId(int vsId) {
    return favorites.any((f) => f.product?.vsId == vsId || f.productVsId == vsId);
  }

  bool isVendorFavorited(int supplierId) {
    return favoriteVendors.any((v) => v.supplierId == supplierId || v.supplier?.id == supplierId);
  }
}
