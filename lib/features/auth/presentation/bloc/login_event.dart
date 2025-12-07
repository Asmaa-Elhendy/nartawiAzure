

import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PerformLogin extends LoginEvent {
  final String username;
  final String password;

  PerformLogin(this.username, this.password);

  @override
  List<Object?> get props => [username, password];
}
