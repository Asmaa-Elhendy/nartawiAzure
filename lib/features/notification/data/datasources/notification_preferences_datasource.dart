import 'package:dio/dio.dart';
import '../../../../core/services/auth_service.dart';
import '../../../auth/presentation/bloc/login_bloc.dart';

class NotificationPreferences {
  // Only 4 dynamic fields that user can control via UI
  final bool lowCouponsAlerts;
  final int lowCouponsThreshold;
  final bool walletBalanceAlerts;
  final double walletBalanceThreshold;

  NotificationPreferences({
    required this.lowCouponsAlerts,
    required this.lowCouponsThreshold,
    required this.walletBalanceAlerts,
    required this.walletBalanceThreshold,
  });

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    return NotificationPreferences(
      lowCouponsAlerts: json['lowCouponsAlerts'] as bool? ?? true,
      lowCouponsThreshold: json['lowCouponsThreshold'] as int? ?? 100,
      walletBalanceAlerts: json['walletBalanceAlerts'] as bool? ?? true,
      walletBalanceThreshold: (json['walletBalanceThreshold'] as num?)?.toDouble() ?? 100.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // Dynamic alert preferences (controlled by UI)
      'lowCouponsAlerts': lowCouponsAlerts,
      'lowCouponsThreshold': lowCouponsThreshold,
      'walletBalanceAlerts': walletBalanceAlerts,
      'walletBalanceThreshold': walletBalanceThreshold,
      
      // Static hardcoded values (always sent as specified)
      'disputes': true,
      'orderUpdates': true,
      'system': true,
      'promotions': true,
      'pushEnabled': true,
      'emailEnabled': false,
    };
  }
}

abstract class NotificationPreferencesDataSource {
  Future<NotificationPreferences> getPreferences();
  Future<NotificationPreferences> updatePreferences(NotificationPreferences prefs);
}

class NotificationPreferencesDataSourceImpl 
    implements NotificationPreferencesDataSource {
  final Dio dio;


  NotificationPreferencesDataSourceImpl({required this.dio});

  @override
  Future<NotificationPreferences> getPreferences() async {
    try {
      final token = await AuthService.getToken();

      final response = await dio.get(
        '$base_url/v1/client/notifications/preferences',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return NotificationPreferences.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw Exception('Failed to fetch preferences');
      }
    } catch (e) {
      print('❌ Error fetching preferences: $e');
      rethrow;
    }
  }

  @override
  Future<NotificationPreferences> updatePreferences(
    NotificationPreferences prefs,
  ) async {
    try {
      final token = await AuthService.getToken();

      final response = await dio.put(
        '$base_url/v1/client/notifications/preferences',
        data: prefs.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return NotificationPreferences.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw Exception('Failed to update preferences');
      }
    } catch (e) {
      print('❌ Error updating preferences: $e');
      rethrow;
    }
  }
}
