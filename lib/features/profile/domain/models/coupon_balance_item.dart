class CouponBalanceItem {
  final int productVsid;
  final String productName;
  final int vendorId;
  final String vendorName;
  final int totalCoupons;
  final int usedCoupons;
  final int availableCoupons;
  final DateTime? lastUsed;
  final DateTime? expiryDate;

  CouponBalanceItem({
    required this.productVsid,
    required this.productName,
    required this.vendorId,
    required this.vendorName,
    required this.totalCoupons,
    required this.usedCoupons,
    required this.availableCoupons,
    required this.lastUsed,
    required this.expiryDate,
  });

  factory CouponBalanceItem.fromJson(Map<String, dynamic> json) {
    int toInt(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      return int.tryParse(v.toString()) ?? 0;
    }

    String toStr(dynamic v) => v?.toString() ?? '';

    DateTime? toDt(dynamic v) {
      if (v == null) return null;
      return DateTime.tryParse(v.toString());
    }

    return CouponBalanceItem(
      productVsid: toInt(json['productVsid']),
      productName: toStr(json['productName']),
      vendorId: toInt(json['vendorId']),
      vendorName: toStr(json['vendorName']),
      totalCoupons: toInt(json['totalCoupons']),
      usedCoupons: toInt(json['usedCoupons']),
      availableCoupons: toInt(json['availableCoupons']),
      lastUsed: toDt(json['lastUsed']),
      expiryDate: toDt(json['expiryDate']),
    );
  }
}