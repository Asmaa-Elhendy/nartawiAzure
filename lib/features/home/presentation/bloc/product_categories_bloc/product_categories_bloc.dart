// lib/features/home/presentation/bloc/product_categories_bloc/product_categories_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:newwwwwwww/features/auth/presentation/bloc/login_bloc.dart';
import '../../../../../core/services/auth_service.dart';
import '../../../domain/models/product_categories_models/product_category_model.dart';
import 'product_categories_event.dart';
import 'product_categories_state.dart';

// 👇 خدي بالك من ده

class ProductCategoriesBloc
    extends Bloc<ProductCategoriesEvent, ProductCategoriesState> {
  final Dio dio;

  ProductCategoriesBloc({required this.dio})
      : super(ProductCategoriesInitial()) {
    on<FetchProductCategories>(_onFetchProductCategories);
    print('🔥 ProductCategoriesBloc created');
  }

  Future<void> _onFetchProductCategories(
      FetchProductCategories event,
      Emitter<ProductCategoriesState> emit,
      ) async {
    print('📥 FetchProductCategories event received');
    emit(ProductCategoriesLoading());
    try {
      final token = await AuthService.getToken();
      print('🔑 token = $token');

      if (token == null) {
        emit(const ProductCategoriesError('Authentication required'));
        return;
      }

      final url = '$base_url/v1/categories';
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
        final List<dynamic> data = response.data;
        final categories = data
            .map((json) => ProductCategory.fromJson(json))
            .toList()
          ..sort((a, b) => a.uiOrderId.compareTo(b.uiOrderId));

        print('✅ loaded ${categories.length} categories');
        emit(ProductCategoriesLoaded(categories));
      } else {
        emit(ProductCategoriesError(
            'Failed to load product categories (status: ${response.statusCode})'));
      }
    } on DioException catch (e) {
      print('❌ Dio error: ${e.response?.data}');
      final errorMessage = e.response?.data?['title']?.toString() ??
          'Failed to load product categories';
      emit(ProductCategoriesError(errorMessage));
    } catch (e) {
      print('🔥 Unexpected error: $e');
      emit(ProductCategoriesError('An unexpected error occurred: $e'));
    }
  }
}
