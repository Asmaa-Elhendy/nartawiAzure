// lib/features/home/presentation/bloc/product_categories/product_categories_event.dart
import 'package:equatable/equatable.dart';

abstract class ProductCategoriesEvent extends Equatable {
  const ProductCategoriesEvent();

  @override
  List<Object> get props => [];
}

class FetchProductCategories extends ProductCategoriesEvent {


  const FetchProductCategories();

  @override
  List<Object> get props => [];
}