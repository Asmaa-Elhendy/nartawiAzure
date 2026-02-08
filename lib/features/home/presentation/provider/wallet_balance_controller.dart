import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../../core/services/auth_service.dart';
import 'package:newwwwwwww/features/auth/presentation/bloc/login_bloc.dart';

import '../../domain/models/wallet_balance.dart';

class WalletBalanceController extends ChangeNotifier {
  final Dio dio;

  WalletBalanceController({required this.dio});

  bool isLoading = false;
  String? error;

  WalletBalanceResponse? balance;

  CouponBalance? get lastCouponBalance {
    final list = balance?.couponBalances ?? [];
    if (list.isEmpty) return null;

    // ✅ آخر واحد = أكبر lastUsed
    list.sort((a, b) {
      final ad = a.lastUsed ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bd = b.lastUsed ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bd.compareTo(ad);
    });

    return list.first;
  }

  Future<void> fetchBalance() async {
    if (isLoading) return;

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final token = await AuthService.getToken();
      debugPrint('🔑 WalletBalanceController fetchBalance token = $token');

      // Don't check for null token - let the API call happen to trigger 401
      // This will allow AuthInterceptor to handle the 401 and navigate to login

      final url = '$base_url/v1/client/wallet/balance';

      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        balance = WalletBalanceResponse.fromJson(response.data as Map<String, dynamic>);
      } else {
        error = 'Failed to load balance (status: ${response.statusCode})';
      }
    } on DioException catch (e) {
      error = e.message ?? 'Failed to load balance';
    } catch (e) {
      error = 'Unexpected error: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
