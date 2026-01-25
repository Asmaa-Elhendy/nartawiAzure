import 'package:equatable/equatable.dart';

class ProductInventory extends Equatable {
  final int id;
  final int quantity;
  final String? location;

  const ProductInventory({
    required this.id,
    required this.quantity,
    this.location,
  });

  factory ProductInventory.fromJson(Map<String, dynamic> json) {
    return ProductInventory(
      id: json['id'] as int? ?? 0,
      quantity: json['quantity'] as int? ?? 0,
      location: json['location'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, quantity, location];
}

class ClientProduct extends Equatable {
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
  final int supplierId;
  final String supplierName;
  final String? supplierLogo;
  final double? supplierRating;
  final bool supplierIsVerified;
  final String? description;
  final String? brand;
  final bool isPinned;
  final String productType;
  final List<dynamic> specifications;
  final int totalAvailableQuantity;
  final List<ProductInventory> inventory;

  const ClientProduct({
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
    required this.supplierId,
    required this.supplierName,
    this.supplierLogo,
    this.supplierRating,
    required this.supplierIsVerified,
    this.description,
    this.brand,
    required this.isPinned,
    required this.productType,
    required this.specifications,
    required this.totalAvailableQuantity,
    required this.inventory,
  });

  factory ClientProduct.fromJson(Map<String, dynamic> json) {
    return ClientProduct(
      id: json['id'] as int? ?? 0,
      vsId: json['vsId'] as int? ?? 0,
      enName: json['enName'] as String? ?? '',
      arName: json['arName'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? false,
      isCurrent: json['isCurrent'] as bool? ?? false,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      categoryId: json['categoryId'] as int? ?? 0,
      categoryName: json['categoryName'] as String? ?? '',
      images: (json['images'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      supplierId: json['supplierId'] as int? ?? 0,
      supplierName: json['supplierName'] as String? ?? '',
      supplierLogo: json['supplierLogo'] as String?,
      supplierRating: (json['supplierRating'] as num?)?.toDouble(),
      supplierIsVerified: json['supplierIsVerified'] as bool? ?? false,
      description: json['description'] as String?,
      brand: json['brand'] as String?,
      isPinned: json['isPinned'] as bool? ?? false,
      productType: json['productType'] as String? ?? 'one-time',
      specifications: (json['specifications'] as List<dynamic>?)?.cast<dynamic>() ?? [],
      totalAvailableQuantity: json['totalAvailableQuantity'] as int? ?? 0,
      inventory: (json['inventory'] as List<dynamic>?)
              ?.map((e) => ProductInventory.fromJson(e as Map<String, dynamic>))
              .toList() ?? [],
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
      
  // Helper method to check if product is a bundle
  bool get isBundle => productType == 'bundle';
  
  // Helper method to get display name based on locale
  String getDisplayName(String locale) {
    return locale == 'ar' ? arName : enName;
  }
}

class ProductsResponse extends Equatable {
  final int pageIndex;
  final int pageSize;
  final int totalCount;
  final int totalPages;
  final bool hasPreviousPage;
  final bool hasNextPage;
  final List<ClientProduct> items;

  const ProductsResponse({
    required this.pageIndex,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.hasPreviousPage,
    required this.hasNextPage,
    required this.items,
  });

  factory ProductsResponse.fromJson(Map<String, dynamic> json) {
    return ProductsResponse(
      pageIndex: json['pageIndex'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? 10,
      totalCount: json['totalCount'] as int? ?? 0,
      totalPages: json['totalPages'] as int? ?? 1,
      hasPreviousPage: json['hasPreviousPage'] as bool? ?? false,
      hasNextPage: json['hasNextPage'] as bool? ?? false,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => ClientProduct.fromJson(e as Map<String, dynamic>))
              .toList() ?? [],
    );
  }

  @override
  List<Object?> get props => [
        pageIndex,
        pageSize,
        totalCount,
        totalPages,
        hasPreviousPage,
        hasNextPage,
        items,
      ];
}
