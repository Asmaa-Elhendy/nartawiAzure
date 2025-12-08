// lib/features/auth/presentation/bloc/login_state.dart
import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

/// LOGIN
class LoginLoading extends AuthState {}

class LoginSuccess extends AuthState {}

class LoginFailure extends AuthState {
  final String error;

  LoginFailure(this.error);

  @override
  List<Object?> get props => [error];
}

/// REGISTER
class RegisterLoading extends AuthState {}

class RegisterSuccess extends AuthState {
  final String message;

  RegisterSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class RegisterFailure extends AuthState {
  final String error;

  RegisterFailure(this.error);

  @override
  List<Object?> get props => [error];
}
class OtpSending extends AuthState {}

class OtpSentSuccess extends AuthState {
  final String message;
  OtpSentSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class OtpSentFailure extends AuthState {
  final String error;
  OtpSentFailure(this.error);

  @override
  List<Object?> get props => [error];
}
