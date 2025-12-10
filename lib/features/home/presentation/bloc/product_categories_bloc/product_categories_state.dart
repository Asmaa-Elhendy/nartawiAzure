// lib/features/home/presentation/bloc/product_categories/product_categories_state.dart
import 'package:equatable/equatable.dart';
import '../../../domain/models/product_categories_models/product_category_model.dart';

abstract class ProductCategoriesState extends Equatable {
  const ProductCategoriesState();

  @override
  List<Object> get props => [];
}

class ProductCategoriesInitial extends ProductCategoriesState {}

class ProductCategoriesLoading extends ProductCategoriesState {}

class ProductCategoriesLoaded extends ProductCategoriesState {
  final List<ProductCategory> categories;

  const ProductCategoriesLoaded(this.categories);

  @override
  List<Object> get props => [categories];
}

class ProductCategoriesError extends ProductCategoriesState {
  final String message;

  const ProductCategoriesError(this.message);

  @override
  List<Object> get props => [message];
}