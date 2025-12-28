import 'package:newwwwwwww/features/home/domain/models/supplier_model.dart';

class FavoriteVendor {
  final int? id;
  final int? supplierId;
  final DateTime? createdAt;
  final Supplier? supplier;

  FavoriteVendor({
    this.id,
    this.supplierId,
    this.createdAt,
    this.supplier,
  });

  factory FavoriteVendor.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic v) {
      if (v == null) return null;
      if (v is DateTime) return v;
      if (v is String) return DateTime.tryParse(v);
      return null;
    }

    return FavoriteVendor(
      id: json['id'] as int?,
      supplierId: json['supplierId'] as int?,
      createdAt: parseDate(json['createdAt']),
      supplier: json['supplier'] is Map<String, dynamic>
          ? Supplier.fromJson(json['supplier'] as Map<String, dynamic>)
          : null,
    );
  }
}
