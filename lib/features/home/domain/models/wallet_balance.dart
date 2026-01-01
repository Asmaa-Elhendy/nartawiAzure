class WalletBalanceResponse {
  final int walletId;
  final int ownerId;
  final List<CashBalance> cashBalances;
  final List<CouponBalance> couponBalances;
  final WalletSummary summary;

  WalletBalanceResponse({
    required this.walletId,
    required this.ownerId,
    required this.cashBalances,
    required this.couponBalances,
    required this.summary,
  });

  factory WalletBalanceResponse.fromJson(Map<String, dynamic> json) {
    return WalletBalanceResponse(
      walletId: (json['walletId'] ?? 0) as int,
      ownerId: (json['ownerId'] ?? 0) as int,
      cashBalances: (json['cashBalances'] as List? ?? [])
          .map((e) => CashBalance.fromJson(e as Map<String, dynamic>))
          .toList(),
      couponBalances: (json['couponBalances'] as List? ?? [])
          .map((e) => CouponBalance.fromJson(e as Map<String, dynamic>))
          .toList(),
      summary: WalletSummary.fromJson((json['summary'] ?? {}) as Map<String, dynamic>),
    );
  }
}

class CashBalance {
  final String currency;
  final num totalBalance;
  final num reservedBalance;
  final num availableBalance;
  final DateTime? lastUpdated;

  CashBalance({
    required this.currency,
    required this.totalBalance,
    required this.reservedBalance,
    required this.availableBalance,
    required this.lastUpdated,
  });

  factory CashBalance.fromJson(Map<String, dynamic> json) {
    return CashBalance(
      currency: (json['currency'] ?? '') as String,
      totalBalance: (json['totalBalance'] ?? 0) as num,
      reservedBalance: (json['reservedBalance'] ?? 0) as num,
      availableBalance: (json['availableBalance'] ?? 0) as num,
      lastUpdated: _tryParseDate(json['lastUpdated']),
    );
  }
}

class CouponBalance {
  final int productVsid;
  final String productName;
  final int vendorId;
  final String vendorName;

  final int totalCoupons;
  final int usedCoupons;
  final int pendingCoupons;
  final int availableCoupons;

  final DateTime? expiryDate;
  final num consumptionRate;
  final DateTime? lastUsed;

  CouponBalance({
    required this.productVsid,
    required this.productName,
    required this.vendorId,
    required this.vendorName,
    required this.totalCoupons,
    required this.usedCoupons,
    required this.pendingCoupons,
    required this.availableCoupons,
    required this.expiryDate,
    required this.consumptionRate,
    required this.lastUsed,
  });

  int get remaining => totalCoupons - usedCoupons; // زي UI بتاعك

  factory CouponBalance.fromJson(Map<String, dynamic> json) {
    return CouponBalance(
      productVsid: (json['productVsid'] ?? 0) as int,
      productName: (json['productName'] ?? '') as String,
      vendorId: (json['vendorId'] ?? 0) as int,
      vendorName: (json['vendorName'] ?? '') as String,
      totalCoupons: (json['totalCoupons'] ?? 0) as int,
      usedCoupons: (json['usedCoupons'] ?? 0) as int,
      pendingCoupons: (json['pendingCoupons'] ?? 0) as int,
      availableCoupons: (json['availableCoupons'] ?? 0) as int,
      expiryDate: _tryParseDate(json['expiryDate']),
      consumptionRate: (json['consumptionRate'] ?? 0) as num,
      lastUsed: _tryParseDate(json['lastUsed']),
    );
  }
}

class WalletSummary {
  final num totalCashBalance;
  final int totalCouponsAvailable;
  final int totalCouponsPending;
  final int totalCouponsUsed;
  final bool lowBalanceWarning;
  final int lowBalanceThreshold;

  WalletSummary({
    required this.totalCashBalance,
    required this.totalCouponsAvailable,
    required this.totalCouponsPending,
    required this.totalCouponsUsed,
    required this.lowBalanceWarning,
    required this.lowBalanceThreshold,
  });

  factory WalletSummary.fromJson(Map<String, dynamic> json) {
    return WalletSummary(
      totalCashBalance: (json['totalCashBalance'] ?? 0) as num,
      totalCouponsAvailable: (json['totalCouponsAvailable'] ?? 0) as int,
      totalCouponsPending: (json['totalCouponsPending'] ?? 0) as int,
      totalCouponsUsed: (json['totalCouponsUsed'] ?? 0) as int,
      lowBalanceWarning: (json['lowBalanceWarning'] ?? false) as bool,
      lowBalanceThreshold: (json['lowBalanceThreshold'] ?? 0) as int,
    );
  }
}

DateTime? _tryParseDate(dynamic v) {
  if (v == null) return null;
  if (v is DateTime) return v;
  if (v is String && v.trim().isNotEmpty) return DateTime.tryParse(v);
  return null;
}
