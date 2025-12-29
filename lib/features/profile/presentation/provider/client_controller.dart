import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../../core/services/auth_service.dart';
import 'package:newwwwwwww/features/auth/presentation/bloc/login_bloc.dart';

import '../../domain/models/client_address.dart';

class AddressController extends ChangeNotifier {
  final Dio dio;

  AddressController({required this.dio}) {
    debugPrint('🔥 AddressController created');
  }

  final List<ClientAddress> addresses = [];

  bool isLoading = false;
  String? error;

  /// ✅ GET /api/v1/client/account/addresses
  Future<void> fetchAddresses({bool executeClear = true}) async {
    if (isLoading) return;

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      if (executeClear) {
        addresses.clear();
      }

      final token = await AuthService.getToken();
      if (token == null) {
        error = 'Authentication required';
        return;
      }

      final url = '$base_url/v1/client/account/addresses';

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
            .map((e) => ClientAddress.fromJson(e))
            .toList();

        addresses.addAll(parsed);

        // Optional: default addresses first
        addresses.sort((a, b) {
          final ad = (a.isDefault ?? false) ? 1 : 0;
          final bd = (b.isDefault ?? false) ? 1 : 0;
          return bd.compareTo(ad);
        });
      } else {
        error = 'Failed to load addresses (status: ${response.statusCode})';
      }
    } on DioException catch (e) {
      final data = e.response?.data;
      String msg = 'Failed to load addresses';

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

  Future<void> refresh() async {
    await fetchAddresses(executeClear: true);
  }

  ClientAddress? get defaultAddress {
    try {
      return addresses.firstWhere((a) => a.isDefault == true);
    } catch (_) {
      return null;
    }
  }
}
