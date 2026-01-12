class ScheduleEntry {
  final int dayOfWeek;
  final String? dayName;
  final int timeSlotId;
  final String? timeSlotName;
  final String? startTime;
  final String? endTime;

  ScheduleEntry({
    required this.dayOfWeek,
    this.dayName,
    required this.timeSlotId,
    this.timeSlotName,
    this.startTime,
    this.endTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'dayOfWeek': dayOfWeek,
      'timeSlotId': timeSlotId,
    };
  }

  factory ScheduleEntry.fromJson(Map<String, dynamic> json) {
    return ScheduleEntry(
      dayOfWeek: json['dayOfWeek'] as int,
      dayName: json['dayName'] as String?,
      timeSlotId: json['timeSlotId'] as int,
      timeSlotName: json['timeSlotName'] as String?,
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
    );
  }
}

class ScheduledOrderAnalytics {
  final double avgConsumptionRate;
  final DateTime? nextPredictedRefill;
  final DateTime? estCompletionDate;
  final String? consumptionHabit;

  ScheduledOrderAnalytics({
    required this.avgConsumptionRate,
    this.nextPredictedRefill,
    this.estCompletionDate,
    this.consumptionHabit,
  });

  factory ScheduledOrderAnalytics.fromJson(Map<String, dynamic> json) {
    return ScheduledOrderAnalytics(
      avgConsumptionRate: (json['avgConsumptionRate'] as num).toDouble(),
      nextPredictedRefill: json['nextPredictedRefill'] != null
          ? DateTime.parse(json['nextPredictedRefill'] as String)
          : null,
      estCompletionDate: json['estCompletionDate'] != null
          ? DateTime.parse(json['estCompletionDate'] as String)
          : null,
      consumptionHabit: json['consumptionHabit'] as String?,
    );
  }
}

class ScheduledOrderModel {
  final int id;
  final int customerId;
  final String? customerName;
  final int bundlePurchaseId;
  final int productVsid;
  final String? productName;
  final int? vendorId;
  final String? vendorName;
  final String? approvalStatus;
  final int? approvedBy;
  final DateTime? approvedAt;
  final String? rejectionReason;
  final int weeklyFrequency;
  final int bottlesPerDelivery;
  final List<ScheduleEntry> schedule;
  final int? deliveryAddressId;
  final String? deliveryAddress;
  final int? autoAssignDeliveryManId;
  final String? autoAssignDeliveryManName;
  final String? vendorNotes;
  final ScheduledOrderAnalytics? analytics;
  final bool autoRenewEnabled;
  final int? lowBalanceThreshold;
  final bool isActive;
  final bool isPaused;
  final DateTime? nextScheduledDelivery;
  final DateTime createdAt;

  ScheduledOrderModel({
    required this.id,
    required this.customerId,
    this.customerName,
    required this.bundlePurchaseId,
    required this.productVsid,
    this.productName,
    this.vendorId,
    this.vendorName,
    this.approvalStatus,
    this.approvedBy,
    this.approvedAt,
    this.rejectionReason,
    required this.weeklyFrequency,
    required this.bottlesPerDelivery,
    required this.schedule,
    this.deliveryAddressId,
    this.deliveryAddress,
    this.autoAssignDeliveryManId,
    this.autoAssignDeliveryManName,
    this.vendorNotes,
    this.analytics,
    required this.autoRenewEnabled,
    this.lowBalanceThreshold,
    required this.isActive,
    required this.isPaused,
    this.nextScheduledDelivery,
    required this.createdAt,
  });

  factory ScheduledOrderModel.fromJson(Map<String, dynamic> json) {
    return ScheduledOrderModel(
      id: json['id'] as int,
      customerId: json['customerId'] as int,
      customerName: json['customerName'] as String?,
      bundlePurchaseId: json['bundlePurchaseId'] as int,
      productVsid: json['productVsid'] as int,
      productName: json['productName'] as String?,
      vendorId: json['vendorId'] as int?,
      vendorName: json['vendorName'] as String?,
      approvalStatus: json['approvalStatus'] as String?,
      approvedBy: json['approvedBy'] as int?,
      approvedAt: json['approvedAt'] != null
          ? DateTime.parse(json['approvedAt'] as String)
          : null,
      rejectionReason: json['rejectionReason'] as String?,
      weeklyFrequency: json['weeklyFrequency'] as int,
      bottlesPerDelivery: json['bottlesPerDelivery'] as int,
      schedule: (json['schedule'] as List<dynamic>)
          .map((e) => ScheduleEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      deliveryAddressId: json['deliveryAddressId'] as int?,
      deliveryAddress: json['deliveryAddress'] as String?,
      autoAssignDeliveryManId: json['autoAssignDeliveryManId'] as int?,
      autoAssignDeliveryManName: json['autoAssignDeliveryManName'] as String?,
      vendorNotes: json['vendorNotes'] as String?,
      analytics: json['analytics'] != null
          ? ScheduledOrderAnalytics.fromJson(
              json['analytics'] as Map<String, dynamic>)
          : null,
      autoRenewEnabled: json['autoRenewEnabled'] as bool? ?? false,
      lowBalanceThreshold: json['lowBalanceThreshold'] as int?,
      isActive: json['isActive'] as bool? ?? false,
      isPaused: json['isPaused'] as bool? ?? false,
      nextScheduledDelivery: json['nextScheduledDelivery'] != null
          ? DateTime.parse(json['nextScheduledDelivery'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

class CreateScheduledOrderRequest {
  final int bundlePurchaseId;
  final int weeklyFrequency;
  final int bottlesPerDelivery;
  final List<ScheduleEntry> schedule;
  final int deliveryAddressId;
  final bool autoRenewEnabled;
  final int? lowBalanceThreshold;

  CreateScheduledOrderRequest({
    required this.bundlePurchaseId,
    required this.weeklyFrequency,
    required this.bottlesPerDelivery,
    required this.schedule,
    required this.deliveryAddressId,
    required this.autoRenewEnabled,
    this.lowBalanceThreshold,
  });

  Map<String, dynamic> toJson() {
    return {
      'bundlePurchaseId': bundlePurchaseId,
      'weeklyFrequency': weeklyFrequency,
      'bottlesPerDelivery': bottlesPerDelivery,
      'schedule': schedule.map((s) => s.toJson()).toList(),
      'deliveryAddressId': deliveryAddressId,
      'autoRenewEnabled': autoRenewEnabled,
      if (lowBalanceThreshold != null) 'lowBalanceThreshold': lowBalanceThreshold,
    };
  }
}

class UpdateScheduledOrderRequest {
  final int? weeklyFrequency;
  final int? bottlesPerDelivery;
  final List<ScheduleEntry>? schedule;
  final int? deliveryAddressId;
  final bool? autoRenewEnabled;
  final int? lowBalanceThreshold;

  UpdateScheduledOrderRequest({
    this.weeklyFrequency,
    this.bottlesPerDelivery,
    this.schedule,
    this.deliveryAddressId,
    this.autoRenewEnabled,
    this.lowBalanceThreshold,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (weeklyFrequency != null) map['weeklyFrequency'] = weeklyFrequency;
    if (bottlesPerDelivery != null) map['bottlesPerDelivery'] = bottlesPerDelivery;
    if (schedule != null) map['schedule'] = schedule!.map((s) => s.toJson()).toList();
    if (deliveryAddressId != null) map['deliveryAddressId'] = deliveryAddressId;
    if (autoRenewEnabled != null) map['autoRenewEnabled'] = autoRenewEnabled;
    if (lowBalanceThreshold != null) map['lowBalanceThreshold'] = lowBalanceThreshold;
    return map;
  }
}
