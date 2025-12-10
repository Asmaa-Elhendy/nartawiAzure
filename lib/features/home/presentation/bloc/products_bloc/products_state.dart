import 'package:equatable/equatable.dart';
import '../../../domain/models/product_model.dart';

abstract class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object> get props => [];
}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {
  final bool isFirstFetch;

  const ProductsLoading({this.isFirstFetch = false});

  @override
  List<Object> get props => [isFirstFetch];
}

class ProductsLoaded extends ProductsState {
  final ProductsResponse response;
  final bool hasReachedMax;

  const ProductsLoaded({
    required this.response,
    this.hasReachedMax = false,
  });

  @override
  List<Object> get props => [response, hasReachedMax];
}

class ProductsError extends ProductsState {
  final String message;

  const ProductsError(this.message);

  @override
  List<Object> get props => [message];
}
