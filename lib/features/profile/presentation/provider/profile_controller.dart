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

  /// ✅ GET /api/v1/client/account
  Future<void> fetchProfile() async {
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

  /// 🔄 Refresh helper
  Future<void> refresh() async {
    await fetchProfile();
  }
}
