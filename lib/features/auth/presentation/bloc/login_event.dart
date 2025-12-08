// lib/features/auth/presentation/bloc/login_event.dart
import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PerformLogin extends AuthEvent {
  final String username;
  final String password;

  PerformLogin(this.username, this.password);

  @override
  List<Object?> get props => [username, password];
}

class PerformRegister extends AuthEvent {
  final String username;
  final String email;
  final String password;
  final String confirmPassword;
  final String fullName;
  final String phoneNumber;
  final String role;

  PerformRegister({
    required this.username,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.fullName,
    required this.phoneNumber,
    this.role = 'Client',
  });

  @override
  List<Object?> get props =>
      [username, email, password, confirmPassword, fullName, phoneNumber, role];
}
class SendOtp extends AuthEvent {
  final String email;
  final String purpose;

  SendOtp({
    required this.email,
    this.purpose = "Auth",
  });

  @override
  List<Object?> get props => [email, purpose];
}
