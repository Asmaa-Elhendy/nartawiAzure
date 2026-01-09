class OrderConfirmation {
  final int orderId;
  final String photoUrl;
  final String deliveryPersonName;
  final DateTime confirmedAt;
  final double? latitude;
  final double? longitude;
  final bool? isGeofenceValid;
  final String? notes;

  OrderConfirmation({
    required this.orderId,
    required this.photoUrl,
    required this.deliveryPersonName,
    required this.confirmedAt,
    this.latitude,
    this.longitude,
    this.isGeofenceValid,
    this.notes,
  });

  factory OrderConfirmation.fromJson(Map<String, dynamic> json) {
    String photoUrl = '';
    
    if (json['document'] != null) {
      photoUrl = json['document']['filePath'] ?? '';
    } else if (json['photoUrl'] != null) {
      photoUrl = json['photoUrl'];
    }

    return OrderConfirmation(
      orderId: json['orderId'] ?? json['ORDER_ID'] ?? 0,
      photoUrl: photoUrl,
      deliveryPersonName: json['deliveryPersonName'] ?? 
                         json['confirmedByAccount']?['name'] ?? 
                         'Unknown',
      confirmedAt: json['confirmedAt'] != null 
          ? DateTime.parse(json['confirmedAt'])
          : DateTime.now(),
      latitude: json['geoLocation']?['latitude']?.toDouble(),
      longitude: json['geoLocation']?['longitude']?.toDouble(),
      isGeofenceValid: json['isGeofenceValid'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'photoUrl': photoUrl,
      'deliveryPersonName': deliveryPersonName,
      'confirmedAt': confirmedAt.toIso8601String(),
      'geoLocation': (latitude != null && longitude != null)
          ? {
              'latitude': latitude,
              'longitude': longitude,
            }
          : null,
      'isGeofenceValid': isGeofenceValid,
      'notes': notes,
    };
  }
}
