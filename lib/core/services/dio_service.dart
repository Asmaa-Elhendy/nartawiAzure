import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../interceptors/auth_interceptor.dart';
import 'auth_service.dart';
import 'dart:developer';

class DioService {
  static Dio? _instance;

  static Dio get dio {
    _instance ??= Dio(
      BaseOptions(
        baseUrl: 'https://nartawi.smartvillageqatar.com/api/v1',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );
    
    // Add auth interceptor
    log('Adding AuthInterceptor to Dio instance');
    _instance!.interceptors.add(AuthInterceptor());
    log('AuthInterceptor added. Total interceptors: ${_instance!.interceptors.length}');
    
    return _instance!;
  }

  /// Create a Dio instance with context for 401 handling
  static Dio dioWithContext(BuildContext context) {
    final dioWith = Dio(dio.options);
    dioWith.interceptors.addAll(dio.interceptors);
    
    // Override the onError to include context
    dioWith.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            // Clear token and navigate to login
            await AuthService.deleteToken();
            if (context.mounted) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/login',
                (route) => false,
              );
            }
          }
          handler.next(error);
        },
      ),
    );
    
    return dioWith;
  }
}
