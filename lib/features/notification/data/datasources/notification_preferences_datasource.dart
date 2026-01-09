import 'package:dio/dio.dart';
import '../../../../core/services/auth_service.dart';

class NotificationPreferences {
  final bool orderUpdates;
  final bool scheduledOrderReminders;
  final bool disputeUpdates;
  final bool marketing;
  final bool systemNotifications;

  NotificationPreferences({
    required this.orderUpdates,
    required this.scheduledOrderReminders,
    required this.disputeUpdates,
    required this.marketing,
    required this.systemNotifications,
  });

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    return NotificationPreferences(
      orderUpdates: json['orderUpdates'] as bool? ?? true,
      scheduledOrderReminders: json['scheduledOrderReminders'] as bool? ?? true,
      disputeUpdates: json['disputeUpdates'] as bool? ?? true,
      marketing: json['marketing'] as bool? ?? false,
      systemNotifications: json['systemNotifications'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderUpdates': orderUpdates,
      'scheduledOrderReminders': scheduledOrderReminders,
      'disputeUpdates': disputeUpdates,
      'marketing': marketing,
      'systemNotifications': systemNotifications,
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
  static const String baseUrl = 'https://nartawi.smartvillageqatar.com/api';

  NotificationPreferencesDataSourceImpl({required this.dio});

  @override
  Future<NotificationPreferences> getPreferences() async {
    try {
      final token = await AuthService.getToken();

      final response = await dio.get(
        '$baseUrl/v1/client/notifications/preferences',
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
        '$baseUrl/v1/client/notifications/preferences',
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
