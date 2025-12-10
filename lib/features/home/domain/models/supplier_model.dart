import 'package:equatable/equatable.dart';

class SupplierAccount extends Equatable {
  final int id;
  final String arName;
  final String enName;
  final String mobile;
  final String email;
  final bool isActive;

  const SupplierAccount({
    required this.id,
    required this.arName,
    required this.enName,
    required this.mobile,
    required this.email,
    required this.isActive,
  });

  factory SupplierAccount.fromJson(Map<String, dynamic> json) {
    return SupplierAccount(
      id: json['id'] as int,
      arName: json['aR_NAME'] as String? ?? '',
      enName: json['eN_NAME'] as String? ?? '',
      mobile: json['mobile'] as String? ?? '',
      email: json['email'] as String? ?? '',
      isActive: json['iS_ACTIVE'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [id, arName, enName, mobile, email, isActive];
}

class Supplier extends Equatable {
  final int id;
  final String arName;
  final String enName;
  final bool isActive;
  final List<SupplierAccount> accounts;

  const Supplier({
    required this.id,
    required this.arName,
    required this.enName,
    required this.isActive,
    required this.accounts,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      id: json['id'] as int,
      arName: json['aR_NAME'] as String? ?? '',
      enName: json['eN_NAME'] as String? ?? '',
      isActive: json['iS_ACTIVE'] as bool? ?? false,
      accounts: (json['accounTs'] as List<dynamic>?)
              ?.map((e) => SupplierAccount.fromJson(e))
              .toList() ??
          [],
    );
  }

  @override
  List<Object?> get props => [id, arName, enName, isActive, accounts];
}
