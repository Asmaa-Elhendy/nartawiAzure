class ClientAddress {
  final int? id;
  final String? title;
  final String? areaName;
  final String? address;
  final String? notes;
  final int? areaId;
  final bool? isDefault;
  final bool? isActive;
  final String? building;
  final String? apartment;
  final String? floor;
  final double? latitude;
  final double? longitude;

  const ClientAddress({
    this.id,
    this.title,
    this.areaName,
    this.address,
    this.notes,
    this.areaId,
    this.isDefault,
    this.isActive,
    this.building,
    this.apartment,
    this.floor,
    this.latitude,
    this.longitude,
  });

  factory ClientAddress.fromJson(Map<String, dynamic> json) {
    double? toDouble(dynamic v) {
      if (v == null) return null;
      if (v is double) return v;
      if (v is int) return v.toDouble();
      if (v is String) return double.tryParse(v);
      return null;
    }

    return ClientAddress(
      id: json['id'] as int?,
      title: json['title'] as String?,
      areaName: json['areaName'] as String?,
      address: json['address'] as String?,
      notes: json['notes'] as String?,
      areaId: json['areaId'] as int?,
      isDefault: json['isDefault'] as bool?,
      isActive: json['isActive'] as bool?,
      building: json['building'] as String?,
      apartment: json['apartment'] as String?,
      floor: json['floor'] as String?,
      latitude: toDouble(json['latitude']),
      longitude: toDouble(json['longitude']),
    );
  }
}
