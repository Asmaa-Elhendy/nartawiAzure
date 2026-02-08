import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/widgets.dart';
import 'dart:developer';

// Global navigator key for 401 handling
GlobalKey<NavigatorState>? appNavigatorKey;

// Simple navigation function that works without context
void navigateToLogin() {
  log('Attempting to navigate to login...');
  
  // Try multiple approaches with detailed debugging
  bool navigationSuccessful = false;
  
  // Method 1: Direct navigator state
  try {
    final currentState = appNavigatorKey?.currentState;
    log('Method 1: currentState = $currentState');
    if (currentState != null) {
      log('Method 1: currentState available, attempting navigation');
      currentState.pushNamedAndRemoveUntil(
        '/login',
        (route) => false,
      );
      log('Method 1: Navigation completed');
      navigationSuccessful = true;
    } else {
      log('Method 1: currentState is null');
    }
  } catch (e) {
    log('Method 1 error: $e');
  }
  
  // Method 2: WidgetsBinding fallback (only if first method fails)
  if (!navigationSuccessful) {
    log('Method 2: Trying WidgetsBinding fallback');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = WidgetsBinding.instance.focusManager.primaryFocus?.context;
      log('Method 2: context = $context');
      if (context != null) {
        try {
          material.Navigator.of(context).pushNamedAndRemoveUntil(
            '/login',
            (route) => false,
          );
          log('Method 2: Navigation completed');
          navigationSuccessful = true;
          return; // Exit callback after successful navigation
        } catch (e) {
          log('Method 2 error: $e');
        }
      } else {
        log('Method 2: context is null');
      }
    });
  }
  
  log('Final result: navigationSuccessful = $navigationSuccessful');
}

class AuthInterceptor extends Interceptor {
  static void setNavigatorKey(GlobalKey<NavigatorState> key) {
    appNavigatorKey = key;
  }
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await AuthService.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    log('AuthInterceptor.onError called: statusCode=${err.response?.statusCode}');
    
    if (err.response?.statusCode == 401) {
      // Clear the stored token
      await AuthService.deleteToken();
      
      // Navigate to login screen using a more direct approach
      log('401 detected - attempting direct navigation');
      
      // Try using the global navigator key first
      if (appNavigatorKey?.currentState != null) {
        try {
          log('Navigator state available, attempting navigation');
          appNavigatorKey!.currentState!.pushNamedAndRemoveUntil(
            '/login',
            (route) => false,
          );
          log('Direct navigation successful');
          return;
        } catch (e) {
          log('Direct navigation failed: $e');
        }
      } else {
        log('Navigator state is null');
      }
      
      // If that fails, try a completely different approach
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          final context = WidgetsBinding.instance.focusManager.primaryFocus?.context;
          if (context != null) {
            log('Fallback context available, attempting navigation');
            material.Navigator.of(context).pushNamedAndRemoveUntil(
              '/login',
                (route) => false,
            );
            log('Fallback navigation successful');
            return; // Exit callback after successful navigation
          } else {
            log('Fallback context is null');
          }
        } catch (e) {
          log('Fallback navigation failed: $e');
        }
      });
      
    }
    handler.next(err);
  }
}
