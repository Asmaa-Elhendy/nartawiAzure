class WalletTransaction {
  final int id;
  final String type; // Transfer, TopUp, BundlePurchase, Refund...
  final num amount; // ممكن يبقى + أو -
  final String currency; // QAR
  final String description;
  final String? linkedAccountName;
  final DateTime issuedAt;
  final DateTime? completedAt;
  final String status; // Completed, Pending, Failed...

  const WalletTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.currency,
    required this.description,
    required this.linkedAccountName,
    required this.issuedAt,
    required this.completedAt,
    required this.status,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    DateTime _parseDate(dynamic v) {
      if (v == null) return DateTime.fromMillisecondsSinceEpoch(0);
      return DateTime.parse(v.toString());
    }

    DateTime? _parseNullableDate(dynamic v) {
      if (v == null) return null;
      return DateTime.parse(v.toString());
    }

    return WalletTransaction(
      id: (json['id'] ?? 0) as int,
      type: (json['type'] ?? '').toString(),
      amount: (json['amount'] ?? 0) as num,
      currency: (json['currency'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      linkedAccountName: json['linkedAccountName']?.toString(),
      issuedAt: _parseDate(json['issuedAt']),
      completedAt: _parseNullableDate(json['completedAt']),
      status: (json['status'] ?? '').toString(),
    );
  }
}
