import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../../core/services/auth_service.dart';
import 'package:newwwwwwww/features/auth/presentation/bloc/login_bloc.dart';

import '../../domain/models/address_req.dart';
import '../../domain/models/client_address.dart';

class AddressController extends ChangeNotifier {
  final Dio dio;

  AddressController({required this.dio}) {
    debugPrint('🔥 AddressController created');
  }

  final List<ClientAddress> addresses = [];

  bool isLoading = false;
  String? error;

  // ✅ Create Address flags
  bool isCreating = false;
  String? createError;

  // ✅ Delete Address flags
  bool isDeleting = false;
  String? deleteError;

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

  /// ✅ POST /api/v1/client/account/addresses
  /// - بيرجع true لو نجح
  /// - refreshAfter: لو true هيرجع يعمل fetchAddresses تاني بعد الاضافة
  Future<bool> addNewAddress(
      AddAddressRequest request, {
        bool refreshAfter = true,
      }) async {
    if (isCreating) return false;

    isCreating = true;
    createError = null;
    notifyListeners();

    try {
      final token = await AuthService.getToken();
      if (token == null) {
        createError = 'Authentication required';
        return false;
      }

      final url = '$base_url/v1/client/account/addresses';

      final response = await dio.post(
        url,
        data: request.toJson(),
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        // ✅ لو الـ API رجّع address object
        final data = response.data;

        if (data is Map<String, dynamic>) {
          final created = ClientAddress.fromJson(data);

          // add on top
          addresses.insert(0, created);

          // keep default first
          addresses.sort((a, b) {
            final ad = (a.isDefault ?? false) ? 1 : 0;
            final bd = (b.isDefault ?? false) ? 1 : 0;
            return bd.compareTo(ad);
          });
        }

        if (refreshAfter) {
          await fetchAddresses(executeClear: true);
        }

        return true;
      } else {
        createError = 'Failed to create address (status: ${response.statusCode})';
        return false;
      }
    } on DioException catch (e) {
      final data = e.response?.data;
      String msg = 'Failed to create address';

      if (data is Map && data['title'] != null) {
        msg = data['title'].toString();
      } else if (data is Map && data['message'] != null) {
        msg = data['message'].toString();
      } else if (e.message != null) {
        msg = e.message!;
      }

      createError = msg;
      return false;
    } catch (e) {
      createError = 'An unexpected error occurred: $e';
      return false;
    } finally {
      isCreating = false;
      notifyListeners();
    }
  }

  /// ✅ DELETE /api/v1/client/account/addresses/{id}
  /// - بيرجع true لو نجح
  /// - refreshAfter: لو true هيرجع يعمل fetchAddresses تاني بعد الحذف
  Future<bool> deleteAddress(
      int id, {
        bool refreshAfter = false,
      }) async {
    if (isDeleting) return false;

    isDeleting = true;
    deleteError = null;
    notifyListeners();

    try {
      final token = await AuthService.getToken();
      if (token == null) {
        deleteError = 'Authentication required';
        return false;
      }

      final url = '$base_url/v1/client/account/addresses/$id';

      final response = await dio.delete(
        url,
        options: Options(
          headers: {
            'accept': '*/*',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 204 || response.statusCode == 200) {
        // ✅ remove locally
        addresses.removeWhere((a) => (a.id ?? 0) == id);

        if (refreshAfter) {
          await fetchAddresses(executeClear: true);
        }

        return true;
      } else {
        deleteError = 'Failed to delete address (status: ${response.statusCode})';
        return false;
      }
    } on DioException catch (e) {
      final data = e.response?.data;
      String msg = 'Failed to delete address';

      if (data is Map && data['title'] != null) {
        msg = data['title'].toString();
      } else if (data is Map && data['message'] != null) {
        msg = data['message'].toString();
      } else if (e.message != null) {
        msg = e.message!;
      }

      deleteError = msg;
      return false;
    } catch (e) {
      deleteError = 'An unexpected error occurred: $e';
      return false;
    } finally {
      isDeleting = false;
      notifyListeners();
    }
  }
}
