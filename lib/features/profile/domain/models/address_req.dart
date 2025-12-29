class AddAddressRequest {
  final String title;
  final String address;
  final int areaId;
  final double latitude;
  final double longitude;

  final int? streetNum;
  final int? buildingNum;
  final int? floorNum;
  final int? doorNumber;
  final String? notes;

  const AddAddressRequest({
    required this.title,
    required this.address,
    required this.areaId,
    required this.latitude,
    required this.longitude,
    this.streetNum,
    this.buildingNum,
    this.floorNum,
    this.doorNumber,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "address": address,
      "areaId": areaId,
      "latitude": latitude,
      "longitude": longitude,
      if (streetNum != null) "streetNum": streetNum,
      if (buildingNum != null) "buildingNum": buildingNum,
      if (floorNum != null) "floorNum": floorNum,
      if (doorNumber != null) "doorNumber": doorNumber,
      if (notes != null && notes!.trim().isNotEmpty) "notes": notes,
    };
  }
}
