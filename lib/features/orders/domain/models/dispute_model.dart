class Dispute {
  final int id;
  final int orderId;
  final int customerId;
  final String description;
  final DisputeStatus status;
  final DateTime createdAt;
  final DateTime? resolvedAt;
  final String? resolution;
  final List<String> photoUrls;

  Dispute({
    required this.id,
    required this.orderId,
    required this.customerId,
    required this.description,
    required this.status,
    required this.createdAt,
    this.resolvedAt,
    this.resolution,
    this.photoUrls = const [],
  });

  factory Dispute.fromJson(Map<String, dynamic> json) {
    List<String> photos = [];
    
    if (json['disputeFiles'] != null && json['disputeFiles'] is List) {
      photos = (json['disputeFiles'] as List)
          .map((file) => file['document']?['filePath'] ?? '')
          .where((path) => path.isNotEmpty)
          .toList()
          .cast<String>();
    } else if (json['photos'] != null && json['photos'] is List) {
      photos = (json['photos'] as List).cast<String>();
    }

    return Dispute(
      id: json['id'] ?? json['ID'] ?? 0,
      orderId: json['orderId'] ?? json['ORDER_ID'] ?? 0,
      customerId: json['customerId'] ?? json['CUSTOMER_ID'] ?? 0,
      description: json['description'] ?? json['DESCRIPTION'] ?? '',
      status: DisputeStatus.fromId(json['statusId'] ?? json['STATUS_ID'] ?? 1),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      resolvedAt: json['resolvedAt'] != null
          ? DateTime.parse(json['resolvedAt'])
          : null,
      resolution: json['resolution'],
      photoUrls: photos,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'customerId': customerId,
      'description': description,
      'statusId': status.id,
      'createdAt': createdAt.toIso8601String(),
      'resolvedAt': resolvedAt?.toIso8601String(),
      'resolution': resolution,
      'photos': photoUrls,
    };
  }

  String get statusText => status.name;
  
  bool get isResolved => status == DisputeStatus.resolved;
  bool get isRejected => status == DisputeStatus.rejected;
  bool get isOpen => status == DisputeStatus.open || status == DisputeStatus.responded;
}

enum DisputeStatus {
  open(1, 'Open'),
  responded(2, 'Responded'),
  resolved(3, 'Resolved'),
  rejected(4, 'Rejected');

  final int id;
  final String name;

  const DisputeStatus(this.id, this.name);

  static DisputeStatus fromId(int id) {
    return DisputeStatus.values.firstWhere(
      (status) => status.id == id,
      orElse: () => DisputeStatus.open,
    );
  }

  static DisputeStatus fromName(String name) {
    return DisputeStatus.values.firstWhere(
      (status) => status.name.toLowerCase() == name.toLowerCase(),
      orElse: () => DisputeStatus.open,
    );
  }
}
