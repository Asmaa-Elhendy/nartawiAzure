import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:newwwwwwww/core/services/auth_service.dart';
import '../../../domain/models/product_model.dart';
import 'products_event.dart';
import 'products_state.dart';

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
    if (event.executeClear == true) {
      _currentPage = 1;
      _hasReachedMax = false;
      _currentResponse = null;
      emit(ProductsInitial());
      return;
    }

    if (state is ProductsLoading) return;

    if (_hasReachedMax && !event.executeClear!) return;

    try {
      final token = await AuthService.getToken();
      print('🔑 token = $token');

      if (token == null) {
        emit(const ProductsError('Authentication required'));
        return;
      }

      final isFirstLoad = _currentPage == 1;
      if (isFirstLoad) {
        emit(ProductsLoading(isFirstFetch: true));
      }

      final pageToFetch = event.pageIndex ?? _currentPage;
      final pageSize = event.pageSize ?? _defaultPageSize;

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

      final url = 'https://nartawi.smartvillageqatar.com/api/v1/client/products';
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

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        final productsResponse = ProductsResponse.fromJson(responseData);
        
        if (productsResponse.items.isEmpty) {
          _hasReachedMax = true;
          emit(ProductsLoaded(
            response: _currentResponse ?? productsResponse,
            hasReachedMax: true,
          ));
          return;
        }

        if (_currentResponse == null || isFirstLoad) {
          _currentResponse = productsResponse;
        } else {
          _currentResponse = ProductsResponse(
            pageIndex: productsResponse.pageIndex,
            pageSize: productsResponse.pageSize,
            totalCount: productsResponse.totalCount,
            totalPages: productsResponse.totalPages,
            hasPreviousPage: productsResponse.hasPreviousPage,
            hasNextPage: productsResponse.hasNextPage,
            items: [..._currentResponse!.items, ...productsResponse.items],
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
            'Failed to load products (status: ${response.statusCode})'));
      }
    } on DioException catch (e) {
      print('❌ Dio error: ${e.response?.data}');
      final errorMessage = e.response?.data?['title']?.toString() ??
          'Failed to load products';
      emit(ProductsError(errorMessage));
    } catch (e) {
      print('🔥 Unexpected error: $e');
      emit(ProductsError('An unexpected error occurred: $e'));
    }
  }

  void refresh() {
    _currentPage = 1;
    _hasReachedMax = false;
    _currentResponse = null;
    add(const FetchProducts(executeClear: true));
  }

  void loadNextPage() {
    if (!_hasReachedMax) {
      add(FetchProducts(
        pageIndex: _currentPage,
        pageSize: _currentResponse?.pageSize ?? _defaultPageSize,
      ));
    }
  }
}
