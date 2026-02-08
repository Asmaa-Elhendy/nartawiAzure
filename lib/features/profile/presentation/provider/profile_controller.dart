import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../../core/services/auth_service.dart';
import 'package:newwwwwwww/features/auth/presentation/bloc/login_bloc.dart';

import '../../domain/models/client_profile.dart';

class ProfileController extends ChangeNotifier {
  final Dio dio;

  ProfileController({required this.dio}) {
    debugPrint('🔥 ProfileController created');
  }

  ClientProfile? profile;

  bool isLoading = false;
  String? error;

  // ✅ Update flags
  bool isUpdating = false;
  String? updateError;

  /// ✅ GET /api/v1/client/account
  Future<void> fetchProfile() async {
    if (isLoading) return;

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final token = await AuthService.getToken();
      debugPrint('🔑 ProfileController fetchProfile token = $token');

      // Don't check for null token - let the API call happen to trigger 401
      // This will allow AuthInterceptor to handle the 401 and navigate to login

      final url = '$base_url/v1/client/account';

      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'accept': '*/*',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map<String, dynamic>) {
          profile = ClientProfile.fromJson(data);
        } else {
          error = 'Invalid profile response';
        }
      } else {
        error = 'Failed to load profile (status: ${response.statusCode})';
      }
    } on DioException catch (e) {
      final data = e.response?.data;
      String msg = 'Failed to load profile';

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

  /// ✅ PUT /api/v1/client/account
  /// Updates profile fields (partial update). Returns true if success.
  /// If refreshAfter = true -> re-fetch profile after update.
  Future<bool> updateProfile({
    String? enName,
    String? arName,
    String? email,
    String? mobile,
    bool refreshAfter = true,
  }) async {
    if (isUpdating) return false;

    isUpdating = true;
    updateError = null;
    notifyListeners();

    try {
      final token = await AuthService.getToken();
      debugPrint('🔑 ProfileController updateProfile token = $token');

      // Don't check for null token - let the API call happen to trigger 401
      // This will allow AuthInterceptor to handle the 401 and navigate to login

      final url = '$base_url/v1/client/account';

      // ✅ send only provided (non-empty) fields
      final Map<String, dynamic> body = {};
      if (enName != null && enName.trim().isNotEmpty) body['enName'] = enName.trim();
      if (arName != null && arName.trim().isNotEmpty) body['arName'] = arName.trim();
      if (email != null && email.trim().isNotEmpty) body['email'] = email.trim();
      if (mobile != null && mobile.trim().isNotEmpty) body['mobile'] = mobile.trim();

      // If nothing to update, treat as no-op success (or you can return false if you prefer)
      if (body.isEmpty) {
        return true;
      }

      final response = await dio.put(
        url,
        data: body,
        options: Options(
          headers: {
            'accept': '*/*',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      // ✅ API returns 204 on success
      if (response.statusCode == 204) {
        if (refreshAfter) {
          await fetchProfile();
        }
        return true;
      }

      // Sometimes APIs return 200/201; keep it tolerant
      if (response.statusCode == 200) {
        if (refreshAfter) {
          await fetchProfile();
        }
        return true;
      }

      updateError = 'Failed to update profile (status: ${response.statusCode})';
      return false;
    } on DioException catch (e) {
      final data = e.response?.data;
      String msg = 'Failed to update profile';

      if (data is Map && data['title'] != null) {
        msg = data['title'].toString();
      } else if (data is Map && data['message'] != null) {
        msg = data['message'].toString();
      } else if (e.message != null) {
        msg = e.message!;
      }

      updateError = msg;
      return false;
    } catch (e) {
      updateError = 'An unexpected error occurred: $e';
      return false;
    } finally {
      isUpdating = false;
      notifyListeners();
    }
  }

  /// 🔄 Refresh helper
  Future<void> refresh() async {
    await fetchProfile();
  }
}
