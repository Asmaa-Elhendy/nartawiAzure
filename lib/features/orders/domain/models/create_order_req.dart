class CreateOrderItemRequest {
  final int productId;
  final int quantity;
  final String? notes;

  const CreateOrderItemRequest({
    required this.productId,
    required this.quantity,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'quantity': quantity,
    if (notes != null && notes!.trim().isNotEmpty) 'notes': notes,
  };
}

class CreateOrderRequest {
  final String paymentMethod; // Swagger shows: "Cache" (keep as String to match backend)
  final List<CreateOrderItemRequest> items;
  final int deliveryAddressId;
  final int? couponId;
  final String? notes;
  final int? terminalId;

  const CreateOrderRequest({
    this.paymentMethod = 'Cache',
    required this.items,
    required this.deliveryAddressId,
    this.couponId,
    this.notes,
    this.terminalId,
  });

  Map<String, dynamic> toJson() => {
    'paymentMethod': paymentMethod,
    'items': items.map((e) => e.toJson()).toList(),
    'deliveryAddressId': deliveryAddressId,
    if (couponId != null) 'couponId': couponId,
    if (notes != null && notes!.trim().isNotEmpty) 'notes': notes,
    if (terminalId != null) 'terminalId': terminalId,
  };
}
