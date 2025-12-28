class ClientProfile {
  final int id;
  final String enName;
  final String arName;
  final String email;
  final String mobile;

  ClientProfile({
    required this.id,
    required this.enName,
    required this.arName,
    required this.email,
    required this.mobile,
  });

  factory ClientProfile.fromJson(Map<String, dynamic> json) {
    return ClientProfile(
      id: json['id'] as int,
      enName: json['enName'] as String? ?? '',
      arName: json['arName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      mobile: json['mobile'] as String? ?? '',
    );
  }
}
