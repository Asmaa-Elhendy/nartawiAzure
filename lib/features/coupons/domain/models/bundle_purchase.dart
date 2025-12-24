class BundlePurchase {
  final int id;
  final String productName;
  final String vendorName;
  final int quantity;
  final int couponsPerBundle;
  final int totalCoupons;
  final num pricePerBundle;
  final num totalPrice;
  final num platformCommission;
  final num vendorPayout;
  final String vendorSkuPrefix;
  final DateTime purchasedAt;
  final String status;

  BundlePurchase({
    required this.id,
    required this.productName,
    required this.vendorName,
    required this.quantity,
    required this.couponsPerBundle,
    required this.totalCoupons,
    required this.pricePerBundle,
    required this.totalPrice,
    required this.platformCommission,
    required this.vendorPayout,
    required this.vendorSkuPrefix,
    required this.purchasedAt,
    required this.status,
  });

  factory BundlePurchase.fromJson(Map<String, dynamic> json) {
    return BundlePurchase(
      id: json['id'] as int,
      productName: (json['productName'] ?? '').toString(),
      vendorName: (json['vendorName'] ?? '').toString(),
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      couponsPerBundle: (json['couponsPerBundle'] as num?)?.toInt() ?? 0,
      totalCoupons: (json['totalCoupons'] as num?)?.toInt() ?? 0,
      pricePerBundle: (json['pricePerBundle'] as num?) ?? 0,
      totalPrice: (json['totalPrice'] as num?) ?? 0,
      platformCommission: (json['platformCommission'] as num?) ?? 0,
      vendorPayout: (json['vendorPayout'] as num?) ?? 0,
      vendorSkuPrefix: (json['vendorSkuPrefix'] ?? '').toString(),
      purchasedAt: DateTime.parse(json['purchasedAt'].toString()),
      status: (json['status'] ?? '').toString(),
    );
  }
}
