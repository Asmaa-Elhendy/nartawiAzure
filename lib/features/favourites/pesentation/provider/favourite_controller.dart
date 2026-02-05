import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../../core/services/auth_service.dart';
import 'package:newwwwwwww/features/auth/presentation/bloc/login_bloc.dart';

import '../../../home/domain/models/message_respons.dart';
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
      debugPrint('🔑 FavoritesController fetchFavoriteProducts token = $token');

      // Don't check for null token - let the API call happen to trigger 401
      // This will allow AuthInterceptor to handle the 401 and navigate to login

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
      debugPrint('🔑 FavoritesController fetchFavoriteVendors token = $token');

      // Don't check for null token - let the API call happen to trigger 401
      // This will allow AuthInterceptor to handle the 401 and navigate to login

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
  Future<void> refreshVendors() async {
    await fetchFavoriteVendors();
  }

  /// ✅ POST /api/v1/client/favorites/products/{productVsId}
  /// Adds product to favorites
  Future<ApiMessageResponse?> makeProductFavorite(int productVsId) async {
    // ✅ لو هو already favorite متعمليش call
    if (isFavoritedVsId(productVsId)) {
      return ApiMessageResponse(success: true, message: 'Already favorited');
    }

    error = null;
    notifyListeners();

    // ✅ Optimistic UI: نضيفه فورًا (لو model يسمح)
    // لو FavoriteProduct عندك محتاج fields كتير ومش هتعرفي تعملي dummy، سيبي الجزء ده.
    // ----------------------------
    // final optimistic = FavoriteProduct(
    //   productVsId: productVsId,
    //   createdAt: DateTime.now(),
    // );
    // favorites.insert(0, optimistic);
    // notifyListeners();
    // ----------------------------

    try {
      final token = await AuthService.getToken();
      debugPrint('🔑 FavoritesController token = $token');

      // Don't check for null token - let the API call happen to trigger 401
      // This will allow AuthInterceptor to handle the 401 and navigate to login

      final url = '$base_url/v1/client/favorites/products/$productVsId';

      final response = await dio.post(
        url,
        data: '', // swagger shows -d ''
        options: Options(
          headers: {
            'accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        final parsed = (data is Map<String, dynamic>)
            ? ApiMessageResponse.fromJson(data)
            : ApiMessageResponse(success: true, message: 'Success');

        // ✅ after success: refresh favorites list to get real object (best)
        await fetchFavoriteProducts();

        return parsed;
      } else {
        final msg = 'Failed to add favorite (status: ${response.statusCode})';
        error = msg;

        // ✅ لو كنتِ عاملة optimistic insert فوق، هنا لازم ترجعيه
        // favorites.removeWhere((x) => x.productVsId == productVsId);

        notifyListeners();
        return ApiMessageResponse(success: false, message: msg);
      }
    } on DioException catch (e) {
      final data = e.response?.data;
      String msg = 'Failed to add favorite';

      if (data is Map && data['title'] != null) {
        msg = data['title'].toString();
      } else if (data is Map && data['message'] != null) {
        msg = data['message'].toString();
      } else if (e.message != null) {
        msg = e.message!;
      }

      error = msg;

      // ✅ لو optimistic insert كان شغال
      // favorites.removeWhere((x) => x.productVsId == productVsId);

      notifyListeners();
      return ApiMessageResponse(success: false, message: msg);
    } catch (e) {
      final msg = 'An unexpected error occurred: $e';
      error = msg;

      // ✅ لو optimistic insert كان شغال
      // favorites.removeWhere((x) => x.productVsId == productVsId);

      notifyListeners();
      return ApiMessageResponse(success: false, message: msg);
    }
  }

  /// ✅ DELETE /api/v1/client/favorites/products/{productVsId}
  /// Removes product from favorites
  Future<ApiMessageResponse?> removeProductFavorite(int productVsId) async {
    // ✅ لو مش موجود في favorites أصلاً متعمليش call
    if (!isFavoritedVsId(productVsId)) {
      return ApiMessageResponse(success: true, message: 'Already not favorited');
    }

    error = null;
    notifyListeners();

    // ✅ Optimistic UI: شيله فوراً
    final backup = List<FavoriteProduct>.from(favorites);
    favorites.removeWhere((f) => f.product?.vsId == productVsId || f.productVsId == productVsId);
    notifyListeners();

    try {
      final token = await AuthService.getToken();
      debugPrint('🔑 FavoritesController removeFavoriteProduct token = $token');

      // Don't check for null token - let the API call happen to trigger 401
      // This will allow AuthInterceptor to handle the 401 and navigate to login

      final url = '$base_url/v1/client/favorites/products/$productVsId';

      final response = await dio.delete(
        url,
        options: Options(
          headers: {
            'accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final parsed = (data is Map<String, dynamic>)
            ? ApiMessageResponse.fromJson(data)
            : ApiMessageResponse(success: true, message: 'Success');

        // ✅ Sync with backend to be 100% correct
        await fetchFavoriteProducts();

        return parsed;
      } else {
        final msg =
            'Failed to remove favorite (status: ${response.statusCode})';
        error = msg;

        // rollback
        favorites
          ..clear()
          ..addAll(backup);
        notifyListeners();

        return ApiMessageResponse(success: false, message: msg);
      }
    } on DioException catch (e) {
      final data = e.response?.data;
      String msg = 'Failed to remove favorite';

      if (data is Map && data['title'] != null) {
        msg = data['title'].toString();
      } else if (data is Map && data['message'] != null) {
        msg = data['message'].toString();
      } else if (e.message != null) {
        msg = e.message!;
      }

      error = msg;

      // rollback
      favorites
        ..clear()
        ..addAll(backup);
      notifyListeners();

      return ApiMessageResponse(success: false, message: msg);
    } catch (e) {
      final msg = 'An unexpected error occurred: $e';
      error = msg;

      // rollback
      favorites
        ..clear()
        ..addAll(backup);
      notifyListeners();

      return ApiMessageResponse(success: false, message: msg);
    }
  }
  // for add/remove favorite vendors:
  /// ✅ POST /api/v1/client/favorites/vendors/{vendorId}
  /// Adds vendor to favorites
  Future<ApiMessageResponse?> makeVendorFavorite(int vendorId) async {
    // ✅ لو already favorite متعمليش call
    if (isVendorFavorited(vendorId)) {
      return ApiMessageResponse(success: true, message: 'Already favorited');
    }

    vendorsError = null;
    notifyListeners();

    // ✅ Optimistic UI (اختياري): ضيف vendorId فوراً (لو model يسمح)
    // لو FavoriteVendor محتاج fields كتير ومش هتعرفي تعملي dummy سيبي الجزء ده.
    // ----------------------------
    // favoriteVendors.insert(
    //   0,
    //   FavoriteVendor(
    //     supplierId: vendorId,
    //     createdAt: DateTime.now(),
    //   ),
    // );
    // notifyListeners();
    // ----------------------------

    try {
      final token = await AuthService.getToken();
      if (token == null) {
        vendorsError = 'Authentication required';
        notifyListeners();
        return ApiMessageResponse(success: false, message: vendorsError);
      }

      final url = '$base_url/v1/client/favorites/vendors/$vendorId';

      final response = await dio.post(
        url,
        data: '', // swagger shows -d ''
        options: Options(
          headers: {
            'accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        final parsed = (data is Map<String, dynamic>)
            ? ApiMessageResponse.fromJson(data)
            : ApiMessageResponse(success: true, message: 'Success');

        // ✅ refresh vendors list to sync with backend
        await fetchFavoriteVendors();

        return parsed;
      } else {
        final msg = 'Failed to add vendor favorite (status: ${response.statusCode})';
        vendorsError = msg;

        // ✅ rollback لو كنتِ عاملة optimistic insert فوق
        // favoriteVendors.removeWhere((v) => v.supplierId == vendorId || v.supplier?.id == vendorId);

        notifyListeners();
        return ApiMessageResponse(success: false, message: msg);
      }
    } on DioException catch (e) {
      final data = e.response?.data;
      String msg = 'Failed to add vendor favorite';

      if (data is Map && data['title'] != null) {
        msg = data['title'].toString();
      } else if (data is Map && data['message'] != null) {
        msg = data['message'].toString();
      } else if (e.message != null) {
        msg = e.message!;
      }

      vendorsError = msg;

      // ✅ rollback لو optimistic insert كان شغال
      // favoriteVendors.removeWhere((v) => v.supplierId == vendorId || v.supplier?.id == vendorId);

      notifyListeners();
      return ApiMessageResponse(success: false, message: msg);
    } catch (e) {
      final msg = 'An unexpected error occurred: $e';
      vendorsError = msg;

      // ✅ rollback لو optimistic insert كان شغال
      // favoriteVendors.removeWhere((v) => v.supplierId == vendorId || v.supplier?.id == vendorId);

      notifyListeners();
      return ApiMessageResponse(success: false, message: msg);
    }
  }

  /// ✅ DELETE /api/v1/client/favorites/vendors/{vendorId}
  /// Removes vendor from favorites
  Future<ApiMessageResponse?> removeVendorFavorite(int vendorId) async {
    // ✅ لو مش موجود أصلاً متعمليش call
    if (!isVendorFavorited(vendorId)) {
      return ApiMessageResponse(success: true, message: 'Already not favorited');
    }

    vendorsError = null;
    notifyListeners();

    // ✅ Optimistic UI: شيله فوراً + backup للـ rollback
    final backup = List<FavoriteVendor>.from(favoriteVendors);

    favoriteVendors.removeWhere(
          (v) => v.supplierId == vendorId || v.supplier?.id == vendorId,
    );
    notifyListeners();

    try {
      final token = await AuthService.getToken();
      if (token == null) {
        vendorsError = 'Authentication required';

        // rollback
        favoriteVendors
          ..clear()
          ..addAll(backup);

        notifyListeners();
        return ApiMessageResponse(success: false, message: vendorsError);
      }

      final url = '$base_url/v1/client/favorites/vendors/$vendorId';

      final response = await dio.delete(
        url,
        options: Options(
          headers: {
            'accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final parsed = (data is Map<String, dynamic>)
            ? ApiMessageResponse.fromJson(data)
            : ApiMessageResponse(success: true, message: 'Success');

        // ✅ Sync with backend
        await fetchFavoriteVendors();

        return parsed;
      } else {
        final msg =
            'Failed to remove vendor favorite (status: ${response.statusCode})';
        vendorsError = msg;

        // rollback
        favoriteVendors
          ..clear()
          ..addAll(backup);
        notifyListeners();

        return ApiMessageResponse(success: false, message: msg);
      }
    } on DioException catch (e) {
      final data = e.response?.data;
      String msg = 'Failed to remove vendor favorite';

      if (data is Map && data['title'] != null) {
        msg = data['title'].toString();
      } else if (data is Map && data['message'] != null) {
        msg = data['message'].toString();
      } else if (e.message != null) {
        msg = e.message!;
      }

      vendorsError = msg;

      // rollback
      favoriteVendors
        ..clear()
        ..addAll(backup);
      notifyListeners();

      return ApiMessageResponse(success: false, message: msg);
    } catch (e) {
      final msg = 'An unexpected error occurred: $e';
      vendorsError = msg;

      // rollback
      favoriteVendors
        ..clear()
        ..addAll(backup);
      notifyListeners();

      return ApiMessageResponse(success: false, message: msg);
    }
  }


}
