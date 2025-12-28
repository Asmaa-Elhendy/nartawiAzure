import 'package:equatable/equatable.dart';

class Supplier extends Equatable {
  final int id;
  final String arName;
  final String enName;
  final bool isActive;
  final String? logoUrl;
  final bool isVerified;
  final int? rating;

  const Supplier({
    required this.id,
    required this.arName,
    required this.enName,
    required this.isActive,
    this.logoUrl,
    required this.isVerified,
    this.rating,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    final dynamic r = json['rating']??0;
    final int? parsedRating =
    (r is int) ? r : (r is double) ? r.toInt() : null;

    return Supplier(
      id: json['id'] as int,
      arName: json['aR_NAME'] as String? ?? '',
      enName: json['eN_NAME'] as String? ?? '',
      isActive: json['iS_ACTIVE'] as bool? ?? false,
      logoUrl: json['logO_URL'] as String?,
      isVerified: json['iS_VERIFIED'] as bool? ?? false,
      rating: parsedRating,
    );
  }

  @override
  List<Object?> get props => [
    id,
    arName,
    enName,
    isActive,
    logoUrl,
    isVerified,
    rating,
  ];
}
