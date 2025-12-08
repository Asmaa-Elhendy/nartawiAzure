// lib/features/auth/presentation/bloc/login_bloc.dart
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'login_event.dart';
import 'login_state.dart';
// asmaa asmaa123   asmaa@gmail.com
//admai Admin@123
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Dio dio;

  AuthBloc({required this.dio}) : super(AuthInitial()) {
    on<PerformLogin>(_onPerformLogin);
    on<PerformRegister>(_onPerformRegister);
    on<SendOtp>(_onSendOtp);
  }

  /// 🔹 LOGIN
  Future<void> _onPerformLogin(
      PerformLogin event,
      Emitter<AuthState> emit,
      ) async
  {
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
      ) async
  {
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

  Future<void> _onSendOtp(
      SendOtp event,
      Emitter<AuthState> emit,
      ) async {
    emit(OtpSending());

    try {
      debugPrint("📤 Sending OTP to: ${event.email}");

      final response = await dio.post(
        "https://nartawi.smartvillageqatar.com/api/Auth/otp/send",
        data: {
          "email": event.email,
          "purpose": event.purpose,   // what purpose
        },
      );

      debugPrint("✅ OTP sent: ${response.data}");

      emit(OtpSentSuccess("OTP sent successfully to ${event.email}"));
    } on DioException catch (e) {
      final data = e.response?.data;
      final status = e.response?.statusCode;

      debugPrint("❌ OTP error ($status): $data");

      String message = "Failed to send OTP";

      if (data is Map && data["title"] != null) {
        message = data["title"];
      }

      emit(OtpSentFailure(message));
    } catch (e) {
      emit(OtpSentFailure("Unexpected error"));
    }
  }

}
// {
// "id": 1,
// "username": "admin",
// "fullName": "Administrator",
// "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwibmFtZSI6ImFkbWluIiwiZW1haWwiOiJhZG1pbkBleGFtcGxlLmNvbSIsImp0aSI6IjJhNzM5NTcxLTBhNTEtNDgxNy1iMTU4LTRmN2I3NTdiMzhjNCIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vd3MvMjAwOC8wNi9pZGVudGl0eS9jbGFpbXMvcm9sZSI6IkFkbWluIiwiZXhwIjoxNzY1MTA1OTA2LCJpc3MiOiJOYXJ0YXdpIiwiYXVkIjoiTmFydGF3aSJ9.KbbY5K3r5tJBNwLt1Hf1TfkbfkbUfH87qcsD8ZeIuQs",
// "refreshToken": "HshQf/X30tgyvJ1B/u3CbSztvIzqvCPy/2Ntm/GQF1s=",
// "roles": [
// "Admin"
// ],
// "tokenExpiration": "2025-12-07T11:11:46.797203Z"
// }
// Response headers
// access-control-allow-origin: *
// content-type: application/json; charset=utf-8
// date: Sun,07 Dec 2025 10:11:46 GMT
// server: Microsoft-IIS/10.0
// x-powered-by: ASP.NET
// x-powered-by-plesk: PleskWin