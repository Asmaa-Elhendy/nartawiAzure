class CancelOrderRequest {
  final String reason;

  const CancelOrderRequest({required this.reason});

  Map<String, dynamic> toJson() => {
    'reason': reason,
  };
}
