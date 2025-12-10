import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:newwwwwwww/features/auth/presentation/bloc/login_bloc.dart';
import '../../../../../core/services/auth_service.dart';
import '../../../domain/models/supplier_model.dart';
import 'suppliers_event.dart';
import 'suppliers_state.dart';

class SuppliersBloc extends Bloc<SuppliersEvent, SuppliersState> {
  final Dio dio;

  SuppliersBloc({required this.dio}) : super(SuppliersInitial()) {
    on<FetchSuppliers>(_onFetchSuppliers);
    print('🔥 SuppliersBloc created');
  }

  Future<void> _onFetchSuppliers(
    FetchSuppliers event,
    Emitter<SuppliersState> emit,
  ) async {
    print('📥 FetchSuppliers event received');
    emit(SuppliersLoading());
    
    try {
      final token = await AuthService.getToken();
      print('🔑 token = $token');

      if (token == null) {
        emit(const SuppliersError('Authentication required'));
        return;
      }

      final url = '$base_url/Suppliers';
      print('🌐 Calling: $url');

      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'accept': 'text/plain',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print('📡 statusCode = ${response.statusCode}');
      print('📦 response.data = ${response.data}');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data is List ? response.data : [];
        final suppliers = data
            .map((json) => Supplier.fromJson(json))
            .toList()
          ..sort((a, b) => a.enName.compareTo(b.enName));

        print('✅ loaded ${suppliers.length} suppliers');
        emit(SuppliersLoaded(suppliers));
      } else {
        emit(SuppliersError(
            'Failed to load suppliers (status: ${response.statusCode})'));
      }
    } on DioException catch (e) {
      print('❌ Dio error: ${e.response?.data}');
      final errorMessage = e.response?.data?['title']?.toString() ??
          'Failed to load suppliers';
      emit(SuppliersError(errorMessage));
    } catch (e) {
      print('🔥 Unexpected error: $e');
      emit(SuppliersError('An unexpected error occurred: $e'));
    }
  }
}
