import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import '../../domain/models/dispute_model.dart';
import '../../../../core/services/auth_service.dart';

class DisputeDatasource {
  final Dio dio;
  final String baseUrl;

  DisputeDatasource({
    required this.dio,
    this.baseUrl = 'https://nartawi.smartvillageqatar.com/api',
  });

  Future<Dispute> createDispute({
    required int orderId,
    required String description,
    List<XFile>? photos,
  }) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('Authentication required');
    }

    FormData formData = FormData();
    formData.fields.add(MapEntry('orderId', orderId.toString()));
    formData.fields.add(MapEntry('description', description));

    if (photos != null && photos.isNotEmpty) {
      for (int i = 0; i < photos.length; i++) {
        final file = await MultipartFile.fromFile(
          photos[i].path,
          filename: 'dispute_photo_$i.jpg',
        );
        formData.files.add(MapEntry('photos', file));
      }
    }

    final response = await dio.post(
      '$baseUrl/v1/client/disputes',
      data: formData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Dispute.fromJson(response.data);
    } else {
      throw Exception('Failed to create dispute: ${response.statusMessage}');
    }
  }

  Future<Dispute> getDisputeByOrderId(int orderId) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('Authentication required');
    }

    final response = await dio.get(
      '$baseUrl/v1/client/disputes',
      queryParameters: {'orderId': orderId},
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'accept': 'application/json',
        },
      ),
    );

    if (response.statusCode == 200) {
      if (response.data is List && (response.data as List).isNotEmpty) {
        return Dispute.fromJson(response.data[0]);
      } else if (response.data is Map) {
        return Dispute.fromJson(response.data);
      } else {
        throw Exception('No dispute found for order');
      }
    } else {
      throw Exception('Failed to fetch dispute: ${response.statusMessage}');
    }
  }

  Future<Dispute> getDisputeById(int disputeId) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('Authentication required');
    }

    final response = await dio.get(
      '$baseUrl/v1/client/disputes/$disputeId',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'accept': 'application/json',
        },
      ),
    );

    if (response.statusCode == 200) {
      return Dispute.fromJson(response.data);
    } else {
      throw Exception('Failed to fetch dispute: ${response.statusMessage}');
    }
  }

  Future<List<Dispute>> getCustomerDisputes() async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('Authentication required');
    }

    final response = await dio.get(
      '$baseUrl/v1/client/disputes',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'accept': 'application/json',
        },
      ),
    );

    if (response.statusCode == 200) {
      if (response.data is List) {
        return (response.data as List)
            .map((json) => Dispute.fromJson(json))
            .toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to fetch disputes: ${response.statusMessage}');
    }
  }
}
