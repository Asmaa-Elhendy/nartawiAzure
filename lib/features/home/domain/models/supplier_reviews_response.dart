class SupplierReviewsResponse {
  final double overallRating;
  final int totalReviews;
  final double onlineExperienceAvg;
  final double orderExperienceAvg;
  final double sellerExperienceAvg;
  final double deliveryExperienceAvg;
  final List<SupplierReview> reviews;

  SupplierReviewsResponse({
    required this.overallRating,
    required this.totalReviews,
    required this.onlineExperienceAvg,
    required this.orderExperienceAvg,
    required this.sellerExperienceAvg,
    required this.deliveryExperienceAvg,
    required this.reviews,
  });

  factory SupplierReviewsResponse.fromJson(Map<String, dynamic> json) {
    double _d(dynamic v) => (v is num) ? v.toDouble() : double.tryParse('$v') ?? 0.0;
    int _i(dynamic v) => (v is num) ? v.toInt() : int.tryParse('$v') ?? 0;

    final raw = json['reviews'];
    final list = raw is List ? raw : <dynamic>[];

    return SupplierReviewsResponse(
      overallRating: _d(json['overallRating']),
      totalReviews: _i(json['totalReviews']),
      onlineExperienceAvg: _d(json['onlineExperienceAvg']),
      orderExperienceAvg: _d(json['orderExperienceAvg']),
      sellerExperienceAvg: _d(json['sellerExperienceAvg']),
      deliveryExperienceAvg: _d(json['deliveryExperienceAvg']),
      reviews: list
          .whereType<Map>()
          .map((e) => SupplierReview.fromJson(e.cast<String, dynamic>()))
          .toList(),
    );
  }
}

class SupplierReview {
  // ✳️ الحقول دي ممكن تتغير حسب API الحقيقي عندكم
  final int? id;
  final String? customerName;
  final String? comment;
  final double rating;
  final DateTime? createdAt;

  SupplierReview({
    this.id,
    this.customerName,
    this.comment,
    required this.rating,
    this.createdAt,
  });

  factory SupplierReview.fromJson(Map<String, dynamic> json) {
    double _d(dynamic v) => (v is num) ? v.toDouble() : double.tryParse('$v') ?? 0.0;
    DateTime? _dt(dynamic v) => v == null ? null : DateTime.tryParse(v.toString());

    return SupplierReview(
      id: (json['id'] is num) ? (json['id'] as num).toInt() : int.tryParse('${json['id']}'),
      customerName: json['customerName']?.toString(),
      comment: json['comment']?.toString(),
      rating: _d(json['rating']),
      createdAt: _dt(json['createdAt']),
    );
  }
}
