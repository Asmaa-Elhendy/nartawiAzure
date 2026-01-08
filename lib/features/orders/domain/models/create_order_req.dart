class CreateOrderItemRequest {
  final int productId;
  final int quantity;
  final String notes;

  const CreateOrderItemRequest({
    required this.productId,
    required this.quantity,
    this.notes = 'string',
  });

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'quantity': quantity,
    'notes': notes.trim().isEmpty ? 'string' : notes,
  };
}


class CreateOrderRequest {
  final List<CreateOrderItemRequest> items;
  final int deliveryAddressId;
  final int couponId;
  final String notes;
  final int terminalId;

  const CreateOrderRequest({
    required this.items,
    required this.deliveryAddressId,
    this.couponId = 0,
    this.notes = 'string',
    this.terminalId = 0,
  });

  Map<String, dynamic> toJson() => {
        'items': items.map((e) => e.toJson()).toList(),
        'deliveryAddressId': deliveryAddressId,
        'couponId': couponId,
        'notes': notes,
        'terminalId': terminalId,
      };
}
