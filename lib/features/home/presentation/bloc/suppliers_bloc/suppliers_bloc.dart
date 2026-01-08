import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import '../../../../../core/services/auth_service.dart';
import 'package:newwwwwwww/features/auth/presentation/bloc/login_bloc.dart';

import '../../../domain/models/supplier_model.dart';
import 'suppliers_event.dart';
import 'suppliers_state.dart';

class SuppliersBloc extends Bloc<SuppliersEvent, SuppliersState> {
  final Dio dio;

  SuppliersBloc({required this.dio}) : super(SuppliersInitial()) {
    on<FetchSuppliers>(_onFetchSuppliers);
    on<FetchFeaturedSuppliers>(_onFetchFeaturedSuppliers);
  }

  Future<void> _onFetchSuppliers(
      FetchSuppliers event,
      Emitter<SuppliersState> emit,
      ) async {
    emit(SuppliersLoading());

    try {
      final token = await AuthService.getToken();
      if (token == null) {
        emit(const SuppliersError('Authentication required'));
        return;
      }

      final url = '$base_url/v1/admin/suppliers/public';

      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is! List) {
          emit(const SuppliersError('Invalid response format (expected list)'));
          return;
        }

        final suppliers = data
            .whereType<Map<String, dynamic>>()
            .map((json) => Supplier.fromJson(json))
            .toList()
          ..sort((a, b) => a.enName.compareTo(b.enName));

        emit(SuppliersLoaded(suppliers));
      } else {
        emit(SuppliersError(
            'Failed to load suppliers (status: ${response.statusCode})'));
      }
    } on DioException catch (e) {
      String msg = 'Failed to load suppliers';

      final data = e.response?.data;
      final code = e.response?.statusCode;

      if (data is Map && data['title'] != null) {
        msg = data['title'].toString();
      } else if (data is Map && data['message'] != null) {
        msg = data['message'].toString();
      } else if (data is String && data.isNotEmpty) {
        msg = data;
      } else if (e.message != null) {
        msg = e.message!;
      }

      // 👇 دي هتوضحلك لو السبب 403 / 401 / الخ
      emit(SuppliersError('${code ?? ''} $msg'.trim()));
    } catch (e) {
      emit(SuppliersError('An unexpected error occurred: $e'));
    }
  }

  Future<void> _onFetchFeaturedSuppliers(
      FetchFeaturedSuppliers event,
      Emitter<SuppliersState> emit,
      ) async {
    emit(FeaturedSuppliersLoading());

    try {
      final token = await AuthService.getToken();
      if (token == null) {
        emit(const FeaturedSuppliersError('Authentication required'));
        return;
      }

      final url = '$base_url/v1/admin/suppliers/featured';

      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is! List) {
          emit(const FeaturedSuppliersError('Invalid response format (expected list)'));
          return;
        }

        final featuredSuppliers = data
            .whereType<Map<String, dynamic>>()
            .map((json) => Supplier.fromJson(json))
            .toList()
          ..sort((a, b) => a.enName.compareTo(b.enName));

        emit(FeaturedSuppliersLoaded(featuredSuppliers));
      } else {
        emit(FeaturedSuppliersError(
            'Failed to load featured suppliers (status: ${response.statusCode})'));
      }
    } on DioException catch (e) {
      String msg = 'Failed to load featured suppliers';

      final data = e.response?.data;
      final code = e.response?.statusCode;

      if (data is Map && data['title'] != null) {
        msg = data['title'].toString();
      } else if (data is Map && data['message'] != null) {
        msg = data['message'].toString();
      } else if (data is String && data.isNotEmpty) {
        msg = data;
      } else if (e.message != null) {
        msg = e.message!;
      }

      emit(FeaturedSuppliersError('${code ?? ''} $msg'.trim()));
    } catch (e) {
      emit(FeaturedSuppliersError('An unexpected error occurred: $e'));
    }
  }
}
