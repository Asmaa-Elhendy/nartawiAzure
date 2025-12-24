// lib/features/home/presentation/bloc/products_bloc/products_bloc.dart

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:newwwwwwww/features/auth/presentation/bloc/login_bloc.dart';

import 'products_event.dart';
import 'products_state.dart';
import 'package:newwwwwwww/core/services/auth_service.dart';
import '../../../domain/models/product_model.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final Dio dio;

  static const int _defaultPageSize = 10;
  int _currentPage = 1;
  bool _hasReachedMax = false;
  ProductsResponse? _currentResponse;

  ProductsBloc({required this.dio}) : super(ProductsInitial()) {
    on<FetchProducts>(_onFetchProducts);
    print('🔥 ProductsBloc created');
  }

  Future<void> _onFetchProducts(
      FetchProducts event,
      Emitter<ProductsState> emit,
      ) async {
    final bool shouldClear = event.executeClear ?? false;

    // 👈 لو محتاجين نبدأ من الأول (مثلاً لما نغير الكاتيجوري)
    if (shouldClear) {
      _currentPage = 1;
      _hasReachedMax = false;
      _currentResponse = null;
    }

    // لو بالفعل في Loading ومش بنعمل clear → بلاش نعمل كول تاني
    if (state is ProductsLoading && !shouldClear) return;

    // لو وصلنا الحد الأقصى ومش clear → مفيش داعي نجيب تاني
    if (_hasReachedMax && !shouldClear) return;

    try {
      final token = await AuthService.getToken();
      print('🔑 token = $token');

      if (token == null) {
        emit(const ProductsError('Authentication required'));
        return;
      }

      // ⬅️ نحسب الصفحة الأول
      final int pageToFetch = event.pageIndex ?? _currentPage;
      final int pageSize = event.pageSize ?? _defaultPageSize;

      // ⬅️ تعريف أدق لأول تحميل
      final bool isFirstLoad =
          shouldClear || _currentResponse == null || pageToFetch == 1;

      if (isFirstLoad) {
        emit(const ProductsLoading(isFirstFetch: true));
      } else {
        emit(const ProductsLoading(isFirstFetch: false));
      }

      final params = <String, dynamic>{
        if (event.categoryId != null) 'CategoryId': event.categoryId,
        if (event.minPrice != null) 'MinPrice': event.minPrice,
        if (event.maxPrice != null) 'MaxPrice': event.maxPrice,
        if (event.isActive != null) 'IsActive': event.isActive,
        if (event.supplierId != null) 'SupplierId': event.supplierId,
        'PageSize': pageSize,
        'PageIndex': pageToFetch,
        if (event.searchTerm != null && event.searchTerm!.isNotEmpty)
          'SearchTerm': event.searchTerm,
        if (event.sortBy != null) 'SortBy': event.sortBy,
        if (event.isDescending != null) 'IsDescending': event.isDescending,
      };

      final url = '$base_url/v1/client/products';
      print('🌐 Calling: $url with params: $params');

      final response = await dio.get(
        url,
        queryParameters: params,
        options: Options(
          headers: {
            'accept': 'text/plain',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print('📡 statusCode = ${response.statusCode}');
      print('📦 data = ${response.data}');

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        final productsResponse = ProductsResponse.fromJson(responseData);

        // لو مفيش items في الـ page دي
        if (productsResponse.items.isEmpty) {
          _hasReachedMax = true;
          emit(ProductsLoaded(
            response: _currentResponse ?? productsResponse,
            hasReachedMax: true,
          ));
          return;
        }

        // أول مرة أو clear أو بداية فلتر جديد
        if (_currentResponse == null || shouldClear || isFirstLoad) {
          _currentResponse = productsResponse;
        } else {
          // ضيف على اللي فات
          _currentResponse = ProductsResponse(
            pageIndex: productsResponse.pageIndex,
            pageSize: productsResponse.pageSize,
            totalCount: productsResponse.totalCount,
            totalPages: productsResponse.totalPages,
            hasPreviousPage: productsResponse.hasPreviousPage,
            hasNextPage: productsResponse.hasNextPage,
            items: [
              ..._currentResponse!.items,
              ...productsResponse.items,
            ],
          );
        }

        _hasReachedMax = !productsResponse.hasNextPage;
        _currentPage = pageToFetch + 1;

        emit(ProductsLoaded(
          response: _currentResponse!,
          hasReachedMax: _hasReachedMax,
        ));
      } else {
        emit(ProductsError(
          'Failed to load products (status: ${response.statusCode})',
        ));
      }
    } on DioException catch (e) {
      print('❌ Dio error: ${e.response?.data}');
      final errorMessage =
          e.response?.data?['title']?.toString() ?? 'Failed to load products';
      emit(ProductsError(errorMessage));
    } catch (e) {
      print('🔥 Unexpected error: $e');
      emit(ProductsError('An unexpected error occurred: $e'));
    }
  }

  /// 🔄 تستخدمها لما تحبي تعملي refresh كامل (مثلاً pull to refresh أو بعد الرجوع للهوم)
  void refresh({
    int? categoryId,
    double? minPrice,
    double? maxPrice,
    bool? isActive,
    int? supplierId,
    String? searchTerm,
    String? sortBy,
    bool? isDescending,
  }) {
    _currentPage = 1;
    _hasReachedMax = false;
    _currentResponse = null;

    add(FetchProducts(
      executeClear: true,
      categoryId: categoryId,
      minPrice: minPrice,
      maxPrice: maxPrice,
      isActive: isActive,
      supplierId: supplierId,
      searchTerm: searchTerm,
      sortBy: sortBy,
      isDescending: isDescending,
    ));
  }

  /// ⬇ استدعائها من السكروول عشان تجيب الصفحة اللي بعدها
  void loadNextPage({
    int? categoryId,
    double? minPrice,
    double? maxPrice,
    bool? isActive,
    int? supplierId,
    String? searchTerm,
    String? sortBy,
    bool? isDescending,
  }) {
    if (!_hasReachedMax) {
      add(FetchProducts(
        pageIndex: _currentPage,
        pageSize: _currentResponse?.pageSize ?? _defaultPageSize,
        categoryId: categoryId,
        minPrice: minPrice,
        maxPrice: maxPrice,
        isActive: isActive,
        supplierId: supplierId,
        searchTerm: searchTerm,
        sortBy: sortBy,
        isDescending: isDescending,
      ));
    }
  }
}
