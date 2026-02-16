import 'package:dio/dio.dart';
import '../../../auth/presentation/bloc/login_bloc.dart';
import '../../domain/notification_model.dart';
import '../../../../core/services/auth_service.dart';

abstract class NotificationRemoteDataSource {
  Future<NotificationsPaginatedResponse> getNotifications({
    int pageNumber = 1,
    int pageSize = 20,
    bool? isRead,
  });
  Future<int> getUnreadCount();
  Future<void> markAsRead(int id);
  Future<int> markAllAsRead();
  Future<void> registerFCMToken({
    required String token,
    required String deviceType,
    required String deviceId,
  });
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final Dio dio;


  NotificationRemoteDataSourceImpl({required this.dio});

  @override
  Future<NotificationsPaginatedResponse> getNotifications({
    int pageNumber = 1,
    int pageSize = 20,
    bool? isRead,
  }) async {
    try {
      final token = await AuthService.getToken();
      
      final queryParams = <String, dynamic>{
        'pageNumber': pageNumber,
        'pageSize': pageSize,
      };
      if (isRead != null) queryParams['isRead'] = isRead;

      print('🔵 Fetching notifications: page=$pageNumber, isRead=$isRead');

      final response = await dio.get(
        '$base_url/v1/client/notifications',
        queryParameters: queryParams,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return NotificationsPaginatedResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw Exception('Failed to fetch notifications');
      }
    } on DioException catch (e) {
      print('❌ DioException: ${e.response?.data}');
      throw Exception(e.response?.data?['title'] ?? 'Network error');
    }
  }

  @override
  Future<int> getUnreadCount() async {
    try {
      final token = await AuthService.getToken();

      final response = await dio.get(
        '$base_url/v1/client/notifications/unread-count',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data['unreadCount'] as int? ?? 0;
      } else {
        throw Exception('Failed to fetch unread count');
      }
    } catch (e) {
      print('❌ Error fetching unread count: $e');
      return 0;
    }
  }

  @override
  Future<void> markAsRead(int id) async {
    try {
      final token = await AuthService.getToken();

      final response = await dio.post(
        '$base_url/v1/client/notifications/$id/read',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'accept': 'application/json',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to mark as read');
      }
    } catch (e) {
      print('❌ Error marking as read: $e');
      throw Exception('Failed to mark notification as read');
    }
  }

  @override
  Future<int> markAllAsRead() async {
    try {
      final token = await AuthService.getToken();

      final response = await dio.post(
        '$base_url/v1/client/notifications/read-all',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data['markedCount'] as int? ?? 0;
      } else {
        throw Exception('Failed to mark all as read');
      }
    } catch (e) {
      print('❌ Error marking all as read: $e');
      throw Exception('Failed to mark all as read');
    }
  }

  @override
  Future<void> registerFCMToken({
    required String token,
    required String deviceType,
    required String deviceId,
  }) async {
    try {
      final authToken = await AuthService.getToken();

      await dio.post(
        '$base_url/v1/client/notifications/push-tokens',
        data: {
          'token': token,
          'deviceType': deviceType,
          'deviceId': deviceId,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
            'Content-Type': 'application/json',
            'accept': 'application/json',
          },
        ),
      );

      print('✅ FCM token registered');
    } catch (e) {
      print('❌ Failed to register FCM token: $e');
    }
  }
}
