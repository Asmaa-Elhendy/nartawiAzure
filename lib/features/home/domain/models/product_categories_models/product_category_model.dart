// lib/features/home/domain/models/product_category_model.dart
import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int id;
  final int vsid;
  final String arName;
  final String enName;
  final bool isCurrent;
  final bool isActive;
  final double price;
  final int categoryId;

  const Product({
    required this.id,
    required this.vsid,
    required this.arName,
    required this.enName,
    required this.isCurrent,
    required this.isActive,
    required this.price,
    required this.categoryId,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'],
        vsid: json['vsid'],
        arName: json['aR_NAME'],
        enName: json['eN_NAME'],
        isCurrent: json['iS_CURRENT'],
        isActive: json['iS_ACTIVE'],
        price: json['price']?.toDouble() ?? 0.0,
        categoryId: json['categorY_ID'],
      );

  @override
  List<Object?> get props => [id, vsid, arName, enName, isCurrent, isActive, price, categoryId];
}

class ProductCategory extends Equatable {
  final int id;
  final String arName;
  final String enName;
  final int? parentId;
  final int uiOrderId;
  final List<Product> products;

  const ProductCategory({
    required this.id,
    required this.arName,
    required this.enName,
    this.parentId,
    required this.uiOrderId,
    required this.products,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) => ProductCategory(
        id: json['id'],
        arName: json['aR_NAME'],
        enName: json['eN_NAME'],
        parentId: json['parenT_ID'],
        uiOrderId: json['uI_ORDER_ID'] ?? 0,
        products: (json['producTs'] as List<dynamic>?)
                ?.map((x) => Product.fromJson(x))
                .toList() ??
            [],
      );

  @override
  List<Object?> get props => [id, arName, enName, parentId, uiOrderId, products];
}