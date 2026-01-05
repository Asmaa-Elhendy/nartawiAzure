import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../../core/services/auth_service.dart';
import 'package:newwwwwwww/features/auth/presentation/bloc/login_bloc.dart';

import '../../domain/models/supplier_reviews_response.dart';

class SupplierReviewsController extends ChangeNotifier {
  final Dio dio;

  SupplierReviewsController({required this.dio});

  bool isLoading = false;
  String? error;

  SupplierReviewsResponse? data;

  Future<void> fetchSupplierReviews(int supplierId) async {
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

      final url = '$base_url/v1/client/suppliers/$supplierId/reviews';

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
        if (raw is Map) {
          data = SupplierReviewsResponse.fromJson(raw.cast<String, dynamic>());
        } else {
          error = 'Invalid response format';
        }
      } else {
        error = 'Failed to load reviews (status: ${response.statusCode})';
      }
    } on DioException catch (e) {
      final d = e.response?.data;
      String msg = 'Failed to load reviews';
      if (d is Map && d['title'] != null) msg = d['title'].toString();
      else if (d is Map && d['message'] != null) msg = d['message'].toString();
      else if (e.message != null) msg = e.message!;
      error = msg;
    } catch (e) {
      error = 'An unexpected error occurred: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh(int supplierId) async {
    await fetchSupplierReviews(supplierId);
  }
}
