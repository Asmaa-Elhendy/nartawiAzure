import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';

import 'login_event.dart';
import 'login_state.dart';


class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final Dio dio;

  LoginBloc({required this.dio}) : super(LoginInitial()) {
    on<PerformLogin>(_onLogin);
  }

  Future<void> _onLogin(PerformLogin event, Emitter<LoginState> emit) async {
    emit(LoginLoading());

    try {
      final response = await dio.post(
        "https://nartawi.smartvillageqatar.com/api/Auth/login",
        data: {
          "username": event.username,
          "password": event.password,
        },
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "accept": "text/plain",
          },
        ),
      );

      emit(LoginSuccess(response.data));
    } on DioException catch (e) {
      emit(LoginFailure(e.response?.data?['message'].toString() ?? "Login failed."));
    } catch (e) {
      emit(LoginFailure("Unexpected error: $e"));
    }
  }
}
