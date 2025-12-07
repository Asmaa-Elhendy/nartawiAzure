// lib/features/auth/presentation/bloc/login_bloc.dart
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'login_event.dart';
import 'login_state.dart';
// asmaa asmaa123
//admai Admin@123
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Dio dio;

  AuthBloc({required this.dio}) : super(AuthInitial()) {
    on<PerformLogin>(_onPerformLogin);
    on<PerformRegister>(_onPerformRegister);
  }

  /// 🔹 LOGIN
  Future<void> _onPerformLogin(
      PerformLogin event,
      Emitter<AuthState> emit,
      ) async {
    emit(LoginLoading());

    try {
      debugPrint('📤 Login payload:');
      debugPrint('username: ${event.username}');
      debugPrint('password: ${event.password}');

      final response = await dio.post(
        'https://nartawi.smartvillageqatar.com/api/Auth/login',
        data: {
          'username': event.username,
          'password': event.password,
        },
      );

      // ممكن هنا تحفظي الـ token في SharedPreferences لو حابة
      debugPrint('✅ Login success: ${response.data}');

      emit(LoginSuccess());
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final data = e.response?.data;

      log('Login error status: $status');
      log('Login error body: $data');

      String message = 'Login failed. Please check your credentials.';

      if (data is Map && data['title'] is String) {
        message = data['title'];
      }

      emit(LoginFailure(message));
    } catch (e) {
      log('Login error: $e');
      emit(LoginFailure('Unexpected error, please try again.'));
    }
  }

  /// 🔹 REGISTER
  Future<void> _onPerformRegister(
      PerformRegister event,
      Emitter<AuthState> emit,
      ) async {
    emit(RegisterLoading());

    try {
      // Logs عشان نتأكد ايه اللي رايح للسيرفر
      debugPrint('📤 Register payload:');
      debugPrint('username: ${event.username}');
      debugPrint('email: ${event.email}');
      debugPrint('fullName: ${event.fullName}');
      debugPrint('phone: ${event.phoneNumber}');

      final response = await dio.post(
        'https://nartawi.smartvillageqatar.com/api/Auth/register',
        data: {
          "username": event.username,
          "email": event.email,
          "password": event.password,
          "confirmPassword": event.confirmPassword,
          "fullName": event.fullName,
          "arFullName": event.fullName, // Using the same as fullName for now
          "mobile": event.phoneNumber,
          "isVendor": false, // Default to false unless you have a way to specify this
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      debugPrint('✅ Register success: ${response.data}');

      emit(RegisterSuccess('Account created successfully'));
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final data = e.response?.data;

      log('Register error status: $status');
      log('Register error body: $data');

      String message = 'Registration failed';

      if (data is Map && data['title'] is String) {
        message = data['title'];
      }

      // لو فيه validation errors من السيرفر
      if (data is Map && data['errors'] is Map) {
        final errors = data['errors'] as Map;
        // نحاول نطلع أول error نصي واضح
        for (final entry in errors.entries) {
          if (entry.value is List && entry.value.isNotEmpty) {
            message = entry.value.first.toString();
            break;
          }
        }
      }

      emit(RegisterFailure(message));
    } catch (e) {
      log('Register error: $e');
      emit(RegisterFailure('Unexpected error, please try again.'));
    }
  }
}
