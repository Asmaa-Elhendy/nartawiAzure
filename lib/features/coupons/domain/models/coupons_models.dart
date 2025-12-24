class CouponPOD {
  final int? podId;
  final String? photoUrl;
  final String? location;
  final double? latitude;
  final double? longitude;
  final DateTime? deliveredAt;
  final String? deliveryPersonName;
  final String? qrCodeScanned;
  final bool? geofenceValidated;
  final double? distanceMeters;

  CouponPOD({
    this.podId,
    this.photoUrl,
    this.location,
    this.latitude,
    this.longitude,
    this.deliveredAt,
    this.deliveryPersonName,
    this.qrCodeScanned,
    this.geofenceValidated,
    this.distanceMeters,
  });

  factory CouponPOD.fromJson(Map<String, dynamic> json) => CouponPOD(
    podId: json['podId'] as int?,
    photoUrl: json['photoUrl'] as String?,
    location: json['location'] as String?,
    latitude: (json['latitude'] as num?)?.toDouble(),
    longitude: (json['longitude'] as num?)?.toDouble(),
    deliveredAt: json['deliveredAt'] != null
        ? DateTime.tryParse(json['deliveredAt'].toString())
        : null,
    deliveryPersonName: json['deliveryPersonName'] as String?,
    qrCodeScanned: json['qrCodeScanned'] as String?,
    geofenceValidated: json['geofenceValidated'] as bool?,
    distanceMeters: (json['distanceMeters'] as num?)?.toDouble(),
  );
}

class WalletCoupon {
  final int id;
  final int productVsid;
  final String productName;
  final int vendorId;
  final String vendorName;
  final String vendorSku;
  final String status;
  final int? orderId;
  final int? bundlePurchaseId;
  final DateTime? issuedAt;
  final DateTime? heldAt;
  final DateTime? markedUsedAt;
  final String? markedUsedBy;
  final DateTime? expiryDate;
  final int? disputeId;
  final CouponPOD? proofOfDelivery;

  WalletCoupon({
    required this.id,
    required this.productVsid,
    required this.productName,
    required this.vendorId,
    required this.vendorName,
    required this.vendorSku,
    required this.status,
    this.orderId,
    this.bundlePurchaseId,
    this.issuedAt,
    this.heldAt,
    this.markedUsedAt,
    this.markedUsedBy,
    this.expiryDate,
    this.disputeId,
    this.proofOfDelivery,
  });

  factory WalletCoupon.fromJson(Map<String, dynamic> json) => WalletCoupon(
    id: json['id'] as int,
    productVsid: json['productVsid'] as int,
    productName: (json['productName'] ?? '').toString(),
    vendorId: json['vendorId'] as int,
    vendorName: (json['vendorName'] ?? '').toString(),
    vendorSku: (json['vendorSku'] ?? '').toString(),
    status: (json['status'] ?? '').toString(),
    orderId: json['orderId'] as int?,
    bundlePurchaseId: json['bundlePurchaseId'] as int?,
    issuedAt: json['issuedAt'] != null
        ? DateTime.tryParse(json['issuedAt'].toString())
        : null,
    heldAt: json['heldAt'] != null
        ? DateTime.tryParse(json['heldAt'].toString())
        : null,
    markedUsedAt: json['markedUsedAt'] != null
        ? DateTime.tryParse(json['markedUsedAt'].toString())
        : null,
    markedUsedBy: json['markedUsedBy']?.toString(),
    expiryDate: json['expiryDate'] != null
        ? DateTime.tryParse(json['expiryDate'].toString())
        : null,
    disputeId: json['disputeId'] as int?,
    proofOfDelivery: json['proofOfDelivery'] != null
        ? CouponPOD.fromJson(json['proofOfDelivery'] as Map<String, dynamic>)
        : null,
  );
}

class WalletCouponsResponse {
  final List<WalletCoupon> coupons;
  final int totalCount;
  final int pageNumber;
  final int pageSize;
  final int totalPages;

  WalletCouponsResponse({
    required this.coupons,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
  });

  factory WalletCouponsResponse.fromJson(Map<String, dynamic> json) {
    final raw = (json['coupons'] is List) ? json['coupons'] as List : <dynamic>[];
    return WalletCouponsResponse(
      coupons: raw
          .map((e) => WalletCoupon.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: (json['totalCount'] as num?)?.toInt() ?? 0,
      pageNumber: (json['pageNumber'] as num?)?.toInt() ?? 1,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 20,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 1,
    );
  }
}
