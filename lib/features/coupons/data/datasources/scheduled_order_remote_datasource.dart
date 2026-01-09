import 'package:dio/dio.dart';
import '../models/scheduled_order_model.dart';
import '../../../../core/services/auth_service.dart';

abstract class ScheduledOrderRemoteDataSource {
  Future<ScheduledOrderModel> createScheduledOrder(CreateScheduledOrderRequest request);
  Future<List<ScheduledOrderModel>> getScheduledOrders();
  Future<ScheduledOrderModel> getScheduledOrderById(int id);
  Future<ScheduledOrderModel> updateScheduledOrder(int id, UpdateScheduledOrderRequest request);
  Future<void> deleteScheduledOrder(int id);
}

class ScheduledOrderRemoteDataSourceImpl implements ScheduledOrderRemoteDataSource {
  final Dio dio;
  static const String baseUrl = 'https://nartawi.smartvillageqatar.com/api';

  ScheduledOrderRemoteDataSourceImpl({required this.dio});

  @override
  Future<ScheduledOrderModel> createScheduledOrder(
    CreateScheduledOrderRequest request,
  ) async {
    try {
      final token = await AuthService.getToken();
      
      print('🔵 Creating scheduled order: ${request.toJson()}');
      
      final response = await dio.post(
        '$baseUrl/v1/client/scheduled-orders',
        data: request.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'accept': 'application/json',
          },
        ),
      );

      print('✅ Create response: ${response.statusCode}');
      
      if (response.statusCode == 201) {
        return ScheduledOrderModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to create scheduled order');
      }
    } on DioException catch (e) {
      print('❌ DioException: ${e.response?.data}');
      final errorMessage = e.response?.data?['title']?.toString() 
          ?? e.response?.data?['detail']?.toString()
          ?? 'Failed to create schedule';
      throw Exception(errorMessage);
    } catch (e) {
      print('❌ Exception: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<List<ScheduledOrderModel>> getScheduledOrders() async {
    try {
      final token = await AuthService.getToken();
      
      print('🔵 Fetching all scheduled orders');
      
      final response = await dio.get(
        '$baseUrl/v1/client/scheduled-orders',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'accept': 'application/json',
          },
        ),
      );

      print('✅ Fetch response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data
            .map((item) => ScheduledOrderModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to fetch scheduled orders');
      }
    } on DioException catch (e) {
      print('❌ DioException: ${e.response?.data}');
      final errorMessage = e.response?.data?['title']?.toString() 
          ?? e.response?.data?['detail']?.toString()
          ?? 'Network error';
      throw Exception(errorMessage);
    } catch (e) {
      print('❌ Exception: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<ScheduledOrderModel> getScheduledOrderById(int id) async {
    try {
      final token = await AuthService.getToken();
      
      print('🔵 Fetching scheduled order #$id');
      
      final response = await dio.get(
        '$baseUrl/v1/client/scheduled-orders/$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'accept': 'application/json',
          },
        ),
      );

      print('✅ Fetch by ID response: ${response.statusCode}');

      if (response.statusCode == 200) {
        return ScheduledOrderModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to fetch scheduled order');
      }
    } on DioException catch (e) {
      print('❌ DioException: ${e.response?.data}');
      if (e.response?.statusCode == 404) {
        throw Exception('Scheduled order not found');
      }
      final errorMessage = e.response?.data?['title']?.toString() 
          ?? e.response?.data?['detail']?.toString()
          ?? 'Network error';
      throw Exception(errorMessage);
    } catch (e) {
      print('❌ Exception: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<ScheduledOrderModel> updateScheduledOrder(
    int id,
    UpdateScheduledOrderRequest request,
  ) async {
    try {
      final token = await AuthService.getToken();
      
      print('🔵 Updating scheduled order #$id: ${request.toJson()}');
      
      final response = await dio.put(
        '$baseUrl/v1/client/scheduled-orders/$id',
        data: request.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'accept': 'application/json',
          },
        ),
      );

      print('✅ Update response: ${response.statusCode}');

      if (response.statusCode == 200) {
        return ScheduledOrderModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to update scheduled order');
      }
    } on DioException catch (e) {
      print('❌ DioException: ${e.response?.data}');
      if (e.response?.statusCode == 404) {
        throw Exception('Scheduled order not found');
      }
      final errorMessage = e.response?.data?['title']?.toString() 
          ?? e.response?.data?['detail']?.toString()
          ?? 'Failed to update schedule';
      throw Exception(errorMessage);
    } catch (e) {
      print('❌ Exception: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<void> deleteScheduledOrder(int id) async {
    try {
      final token = await AuthService.getToken();
      
      print('🔵 Deleting scheduled order #$id');
      
      final response = await dio.delete(
        '$baseUrl/v1/client/scheduled-orders/$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'accept': 'application/json',
          },
        ),
      );

      print('✅ Delete response: ${response.statusCode}');

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Failed to delete scheduled order');
      }
    } on DioException catch (e) {
      print('❌ DioException: ${e.response?.data}');
      if (e.response?.statusCode == 404) {
        throw Exception('Scheduled order not found');
      }
      final errorMessage = e.response?.data?['title']?.toString() 
          ?? e.response?.data?['detail']?.toString()
          ?? 'Failed to delete schedule';
      throw Exception(errorMessage);
    } catch (e) {
      print('❌ Exception: $e');
      throw Exception('Unexpected error: $e');
    }
  }
}
