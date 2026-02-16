import 'package:equatable/equatable.dart';

String? _asNullableString(dynamic v) {
  if (v == null) return null;
  if (v is String) return v;
  // لو Map أو رقم أو bool... رجّعه كنص بدل ما يكسر
  return v.toString();
}

String _asString(dynamic v, {String fallback = ''}) {
  final s = _asNullableString(v);
  return s ?? fallback;
}

int _asInt(dynamic v, {int fallback = 0}) {
  if (v is int) return v;
  if (v is num) return v.toInt();
  if (v is String) return int.tryParse(v) ?? fallback;
  return fallback;
}

double _asDouble(dynamic v, {double fallback = 0.0}) {
  if (v is double) return v;
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v) ?? fallback;
  return fallback;
}

bool _asBool(dynamic v, {bool fallback = false}) {
  if (v is bool) return v;
  if (v is String) {
    final lower = v.toLowerCase();
    if (lower == 'true') return true;
    if (lower == 'false') return false;
  }
  if (v is num) return v != 0;
  return fallback;
}

List<String> _asStringList(dynamic v) {
  if (v == null) return [];
  if (v is List) {
    return v.map((e) => _asString(e)).toList();
  }
  return [];
}

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
      id: _asInt(json['id']),
      quantity: _asInt(json['quantity']),
      location: _asNullableString(json['location']),
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
      id: _asInt(json['id']),
      vsId: _asInt(json['vsId']),
      enName: _asString(json['enName']),
      arName: _asString(json['arName']),
      isActive: _asBool(json['isActive']),
      isCurrent: _asBool(json['isCurrent']),
      price: _asDouble(json['price']),
      categoryId: _asInt(json['categoryId']),
      categoryName: _asString(json['categoryName']),
      images: _asStringList(json['images']),
      supplierId: _asInt(json['supplierId']),
      supplierName: _asString(json['supplierName']),
      // ✅ هنا كان بيكسر لما ييجي Map
      supplierLogo: _asNullableString(json['supplierLogo']),
      // خليها nullable بس لو مش موجودة ترجع null أو 0.0 حسب ما تحبي
      supplierRating: json['supplierRating'] == null
          ? null
          : _asDouble(json['supplierRating']),
      supplierIsVerified: _asBool(json['supplierIsVerified']),
      description: _asNullableString(json['description']),
      brand: _asNullableString(json['brand']),
      isPinned: _asBool(json['isPinned']),
      productType: _asString(json['productType'], fallback: 'one-time'),
      specifications: (json['specifications'] is List)
          ? (json['specifications'] as List).cast<dynamic>()
          : const <dynamic>[],
      totalAvailableQuantity: _asInt(json['totalAvailableQuantity']),
      inventory: (json['inventory'] is List)
          ? (json['inventory'] as List)
          .whereType<Map<String, dynamic>>()
          .map(ProductInventory.fromJson)
          .toList()
          : const <ProductInventory>[],
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

  bool get isBundle => productType == 'bundle';

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
      pageIndex: _asInt(json['pageIndex'], fallback: 1),
      pageSize: _asInt(json['pageSize'], fallback: 10),
      totalCount: _asInt(json['totalCount']),
      totalPages: _asInt(json['totalPages'], fallback: 1),
      hasPreviousPage: _asBool(json['hasPreviousPage']),
      hasNextPage: _asBool(json['hasNextPage']),
      items: (json['items'] is List)
          ? (json['items'] as List)
          .whereType<Map<String, dynamic>>()
          .map(ClientProduct.fromJson)
          .toList()
          : const <ClientProduct>[],
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
