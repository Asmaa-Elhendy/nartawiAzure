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
  final double price;
  final int categoryId;
  final String categoryName;
  final List<String> images;
  final int? supplierId;
  final String? supplierName;
  final String? supplierLogo;
  final double? supplierRating;
  final bool? supplierIsVerified;
  final String? description;
  final String? brand;
  final bool? isPinned;
  final String? productType;
  final List<dynamic>? specifications;
  final int totalAvailableQuantity;
  final List<dynamic> inventory;

  FavoriteProductItem({
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
    this.supplierId,
    this.supplierName,
    this.supplierLogo,
    this.supplierRating,
    this.supplierIsVerified,
    this.description,
    this.brand,
    this.isPinned,
    this.productType,
    this.specifications,
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
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      categoryId: (json['categoryId'] ?? 0) as int,
      categoryName: (json['categoryName'] as String?) ?? '',
      images: (json['images'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      supplierId: json['supplierId'] as int?,
      supplierName: json['supplierName'] as String?,
      supplierLogo: json['supplierLogo'] as String?,
      supplierRating: (json['supplierRating'] as num?)?.toDouble(),
      supplierIsVerified: json['supplierIsVerified'] as bool?,
      description: json['description'] as String?,
      brand: json['brand'] as String?,
      isPinned: (json['isPinned'] as bool?) ?? false,
      productType: json['productType'] as String?,
      specifications: (json['specifications'] as List<dynamic>?)?.cast<dynamic>() ?? [],
      totalAvailableQuantity: (json['totalAvailableQuantity'] ?? 0) as int,
      inventory: (json['inventory'] as List<dynamic>?) ?? const [],
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
    supplierId,
    supplierName,
    supplierLogo,
    supplierRating,
    supplierIsVerified,
    description,
    brand,
    isPinned,
    productType,
    specifications,
    totalAvailableQuantity,
    inventory,
  ];
  
  // Helper method to get display name based on locale
  String getDisplayName(String locale) {
    return locale == 'ar' ? arName : enName;
  }
  
  // Helper method to check if product is a bundle
  bool get isBundle => productType == 'bundle';
}
