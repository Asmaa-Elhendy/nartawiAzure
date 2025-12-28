import 'package:equatable/equatable.dart';

class FavoriteProduct extends Equatable {
  final int id;
  final int productVsId;
  final DateTime? createdAt;
  final FavoriteProductItem? product;

  const FavoriteProduct({
    required this.id,
    required this.productVsId,
    required this.createdAt,
    required this.product,
  });

  factory FavoriteProduct.fromJson(Map<String, dynamic> json) {
    return FavoriteProduct(
      id: (json['id'] ?? 0) as int,
      productVsId: (json['productVsId'] ?? 0) as int,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      product: json['product'] is Map<String, dynamic>
          ? FavoriteProductItem.fromJson(json['product'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  List<Object?> get props => [id, productVsId, createdAt, product];
}

class FavoriteProductItem extends Equatable {
  final int id;
  final int vsId;
  final String enName;
  final String arName;
  final bool isActive;
  final bool isCurrent;
  final num price;
  final int categoryId;
  final String categoryName;
  final List<dynamic> images;
  final num totalAvailableQuantity;
  final List<dynamic> inventory;

  const FavoriteProductItem({
    required this.id,
    required this.vsId,
    required this.enName,
    required this.arName,
    required this.isActive,
    required this.isCurrent,
    required this.price,
    required this.categoryId,
    required this.categoryName,
    required this.images,
    required this.totalAvailableQuantity,
    required this.inventory,
  });

  factory FavoriteProductItem.fromJson(Map<String, dynamic> json) {
    return FavoriteProductItem(
      id: (json['id'] ?? 0) as int,
      vsId: (json['vsId'] ?? 0) as int,
      enName: (json['enName'] as String?) ?? '',
      arName: (json['arName'] as String?) ?? '',
      isActive: (json['isActive'] as bool?) ?? false,
      isCurrent: (json['isCurrent'] as bool?) ?? false,
      price: (json['price'] ?? 0) as num,
      categoryId: (json['categoryId'] ?? 0) as int,
      categoryName: (json['categoryName'] as String?) ?? '',
      images: (json['images'] as List?) ?? const [],
      totalAvailableQuantity: (json['totalAvailableQuantity'] ?? 0) as num,
      inventory: (json['inventory'] as List?) ?? const [],
    );
  }

  @override
  List<Object?> get props => [
    id,
    vsId,
    enName,
    arName,
    isActive,
    isCurrent,
    price,
    categoryId,
    categoryName,
    images,
    totalAvailableQuantity,
    inventory,
  ];
}
