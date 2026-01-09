import 'package:equatable/equatable.dart';

class ProductsEvent extends Equatable {
  final int? categoryId;
  final double? minPrice;
  final double? maxPrice;
  final bool? isActive;
  final int? supplierId;
  final int? pageSize;
  final int? pageIndex;
  final String? searchTerm;
  final String? sortBy;
  final bool? isDescending;
  final bool? executeClear;
  final bool? isBundle;

  const ProductsEvent({
    this.categoryId,
    this.minPrice,
    this.maxPrice,
    this.isActive,
    this.supplierId,
    this.pageSize,
    this.pageIndex,
    this.searchTerm,
    this.sortBy,
    this.isDescending,
    this.executeClear,
    this.isBundle,
  });

  @override
  List<Object?> get props => [
        categoryId,
        minPrice,
        maxPrice,
        isActive,
        supplierId,
        pageSize,
        pageIndex,
        searchTerm,
        sortBy,
        isDescending,
        executeClear,
        isBundle,
      ];
}

class FetchProducts extends ProductsEvent {
  const FetchProducts({
    super.categoryId,
    super.minPrice,
    super.maxPrice,
    super.isActive,
    super.supplierId,
    super.pageSize = 10,
    super.pageIndex = 1,
    super.searchTerm,
    super.sortBy,
    super.isDescending,
    super.executeClear = false,
    super.isBundle,
  });
}
