import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:io';
import '../../domain/models/order_confirmation_model.dart';
import '../../../../core/services/auth_service.dart';

class OrderConfirmationDatasource {
  final Dio dio;
  final String baseUrl;

  OrderConfirmationDatasource({
    required this.dio,
    this.baseUrl = 'https://nartawi.smartvillageqatar.com/api',
  });

  Future<OrderConfirmation> submitPOD({
    required int orderId,
    required String photoBase64,
    required double latitude,
    required double longitude,
    String? notes,
  }) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('Authentication required');
    }

    final response = await dio.post(
      '$baseUrl/v1/delivery/pod',
      data: {
        'orderId': orderId,
        'photoBase64': photoBase64,
        'geoLocation': {
          'latitude': latitude,
          'longitude': longitude,
        },
        'notes': notes,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return OrderConfirmation.fromJson(response.data);
    } else if (response.statusCode == 400) {
      throw Exception('Geofence validation failed: ${response.data['message'] ?? 'Location too far from delivery address'}');
    } else {
      throw Exception('Failed to submit POD: ${response.statusMessage}');
    }
  }

  Future<OrderConfirmation?> getPODByOrderId(int orderId) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('Authentication required');
    }

    try {
      final response = await dio.get(
        '$baseUrl/v1/client/orders/$orderId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final orderData = response.data;
        if (orderData['orderConfirmation'] != null) {
          return OrderConfirmation.fromJson(orderData['orderConfirmation']);
        }
        return null;
      } else {
        throw Exception('Failed to fetch POD: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to fetch POD: $e');
    }
  }
}
