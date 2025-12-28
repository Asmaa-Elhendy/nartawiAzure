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

  // factory Supplier.fromJson(Map<String, dynamic> json) {
  //   final dynamic r = json['rating']??0;
  //   final int? parsedRating =
  //   (r is int) ? r : (r is double) ? r.toInt() : null;
  //
  //   return Supplier(
  //     id: json['id'] as int,
  //     arName: json['aR_NAME'] as String? ?? '',
  //     enName: json['eN_NAME'] as String? ?? '',
  //     isActive: json['iS_ACTIVE'] as bool? ?? false,
  //     logoUrl: json['logO_URL'] as String?,
  //     isVerified: json['iS_VERIFIED'] as bool? ?? false,
  //     rating: parsedRating,
  //   );
  // }
  factory Supplier.fromJson(Map<String, dynamic> json) {
    // ✅ helper يجيب أول key موجود (case-insensitive تقريبًا)
    T? pick<T>(List<String> keys) {
      for (final k in keys) {
        if (json.containsKey(k) && json[k] != null) return json[k] as T?;
      }
      return null;
    }

    // ✅ rating ممكن ييجي int/double/string أو مش ييجي أصلاً
    int? parseRating(dynamic r) {
      if (r == null) return null;
      if (r is int) return r;
      if (r is double) return r.toInt();
      return int.tryParse(r.toString());
    }

    return Supplier(
      id: pick<int>(['id']) ?? 0,

      // ✅ دعم الشكلين: aR_NAME / arName
      arName: (pick<String>(['aR_NAME', 'arName', 'AR_NAME', 'ArName']) ?? '').toString(),
      enName: (pick<String>(['eN_NAME', 'enName', 'EN_NAME', 'EnName']) ?? '').toString(),

      // ✅ دعم الشكلين: iS_ACTIVE / isActive
      isActive: pick<bool>(['iS_ACTIVE', 'isActive', 'IS_ACTIVE']) ?? false,

      // ✅ دعم الشكلين: logO_URL / logoUrl
      logoUrl: pick<String>(['logO_URL', 'logoUrl', 'LOGO_URL']),

      // ✅ دعم الشكلين: iS_VERIFIED / isVerified
      isVerified: pick<bool>(['iS_VERIFIED', 'isVerified', 'IS_VERIFIED']) ?? false,

      // ✅ rating (لو مش موجود في favorites/vendors هتبقى null/0 حسب ما تحبي)
      rating: parseRating(pick<dynamic>(['rating', 'RATING'])) ?? 0,
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
