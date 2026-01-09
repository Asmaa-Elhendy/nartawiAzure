import 'order_confirmation_model.dart';
import 'dispute_model.dart';

class ClientOrder {
  final int id;
  final DateTime? issueTime;
  final String? statusName;
  final int? statusId;

  final num? subTotal;
  final num? discount;
  final num? deliveryCost;
  final num? total;

  final bool? isPaid;

  final String? paymentMethod;
  final String? transactionReference;

  // nullable fields from API (keep as dynamic or specific models later)
  final dynamic items;
  final dynamic eventLogs;
  final dynamic deliveryAddress;
  final String? customerName;
  final int? customerId;

  final String? terminalName;
  final int? terminalId;

  final dynamic confirmation;
  final dynamic vendors;
  
  final OrderConfirmation? orderConfirmation;
  final Dispute? dispute;

  ClientOrder({
    required this.id,
    this.issueTime,
    this.statusName,
    this.statusId,
    this.subTotal,
    this.discount,
    this.deliveryCost,
    this.total,
    this.isPaid,
    this.paymentMethod,
    this.transactionReference,
    this.items,
    this.eventLogs,
    this.deliveryAddress,
    this.customerName,
    this.customerId,
    this.terminalName,
    this.terminalId,
    this.confirmation,
    this.vendors,
    this.orderConfirmation,
    this.dispute,
  });

  factory ClientOrder.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic v) {
      if (v == null) return null;
      if (v is String) return DateTime.tryParse(v);
      if (v is DateTime) return v;
      return null;
    }

    num? parseNum(dynamic v) {
      if (v == null) return null;
      if (v is num) return v;
      return num.tryParse(v.toString());
    }

    OrderConfirmation? orderConfirmation;
    if (json['orderConfirmation'] != null) {
      try {
        orderConfirmation = OrderConfirmation.fromJson(json['orderConfirmation']);
      } catch (e) {
        orderConfirmation = null;
      }
    }
    
    Dispute? dispute;
    if (json['dispute'] != null) {
      try {
        dispute = Dispute.fromJson(json['dispute']);
      } catch (e) {
        dispute = null;
      }
    }

    return ClientOrder(
      id: (json['id'] ?? 0) as int,
      issueTime: parseDate(json['issueTime']),
      statusName: json['statusName'] as String?,
      statusId: json['statusId'] as int?,
      subTotal: parseNum(json['subTotal']),
      discount: parseNum(json['discount']),
      deliveryCost: parseNum(json['deliveryCost']),
      total: parseNum(json['total']),
      isPaid: json['isPaid'] as bool?,
      paymentMethod: json['paymentMethod'] as String?,
      transactionReference: json['transactionReference'] as String?,
      items: json['items'],
      eventLogs: json['eventLogs'],
      deliveryAddress: json['deliveryAddress'],
      customerName: json['customerName'] as String?,
      customerId: json['customerId'] as int?,
      terminalName: json['terminalName'] as String?,
      terminalId: json['terminalId'] as int?,
      confirmation: json['confirmation'],
      vendors: json['vendors'],
      orderConfirmation: orderConfirmation,
      dispute: dispute,
    );
  }
}

class ClientOrdersResponse {
  final int pageIndex;
  final int pageSize;
  final int totalCount;
  final int totalPages;
  final bool hasPreviousPage;
  final bool hasNextPage;
  final List<ClientOrder> items;

  ClientOrdersResponse({
    required this.pageIndex,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.hasPreviousPage,
    required this.hasNextPage,
    required this.items,
  });

  factory ClientOrdersResponse.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    final List<dynamic> list = rawItems is List ? rawItems : <dynamic>[];

    return ClientOrdersResponse(
      pageIndex: (json['pageIndex'] ?? 1) as int,
      pageSize: (json['pageSize'] ?? 10) as int,
      totalCount: (json['totalCount'] ?? 0) as int,
      totalPages: (json['totalPages'] ?? 1) as int,
      hasPreviousPage: (json['hasPreviousPage'] ?? false) as bool,
      hasNextPage: (json['hasNextPage'] ?? false) as bool,
      items: list
          .whereType<Map<String, dynamic>>()
          .map((e) => ClientOrder.fromJson(e))
          .toList(),
    );
  }
}
