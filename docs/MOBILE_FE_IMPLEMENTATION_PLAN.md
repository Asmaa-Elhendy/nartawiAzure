# Mobile FE Implementation Plan - API Integration & Feature Completion

**Date:** January 8, 2026  
**Version:** M1.0.2 - M1.0.5  
**Objective:** Connect existing UI to backend APIs and complete missing integrations  
**Constraint:** DO NOT CHANGE EXISTING UI DESIGN - Wire functionality only

---

## 📋 PREREQUISITES

### ✅ Before Starting Implementation:

1. **Backend Team Responses Required:**
   - Complete answers to `BACKEND_INQUIRIES_SCHEDULED_ORDERS.md`
   - API endpoint documentation for scheduled orders
   - Example payloads and responses
   - Test account credentials

2. **Development Environment:**
   - ✅ Flutter SDK updated
   - ✅ Dio package (already installed)
   - ✅ API Base URL: `https://nartawi.smartvillageqatar.com/api`
   - ✅ Authentication: Bearer token via `AuthService.getToken()`

3. **Code Review Completed:**
   - ✅ Identified existing UI components
   - ✅ Mapped mock data locations
   - ✅ Verified API integration patterns from existing features

---

## 🎯 IMPLEMENTATION PHASES

### **PHASE 1: M1.0.2 - Connect Existing UI (Week 1)**
**Status:** Ready to start after backend responses  
**Effort:** 40 hours  
**Risk:** Low (APIs confirmed to exist)

### **PHASE 2: M1.0.3 - Scheduled Orders Full Integration (Week 2-3)**
**Status:** Blocked - waiting for endpoint confirmation  
**Effort:** 60 hours  
**Risk:** Medium (depends on backend API structure)

### **PHASE 3: M1.0.4 - Product Details & Specs (Week 4)**
**Status:** Blocked - endpoints may not exist  
**Effort:** 30 hours  
**Risk:** High (backend implementation needed)

### **PHASE 4: M1.0.5 - Disputes Full Feature (Week 5)**
**Status:** Ready - APIs exist  
**Effort:** 40 hours  
**Risk:** Low

---

## 🔧 PHASE 1: M1.0.2 - IMMEDIATE INTEGRATIONS

### 1.1 Address Update Integration

**Current State:**
- ✅ UI exists: Address edit screens
- ✅ Backend API: `PUT /api/v1/client/account/addresses/{id}` confirmed
- ❌ Mobile integration: Missing

**Files to Create:**
```
lib/features/profile/domain/models/update_address_req.dart
```

**Files to Modify:**
```
lib/features/profile/presentation/provider/address_controller.dart
lib/features/profile/presentation/pages/delivery_address.dart (if edit button exists)
```

**Implementation Steps:**

**Step 1.1.1:** Create update address request model
```dart
// lib/features/profile/domain/models/update_address_req.dart

class UpdateAddressRequest {
  final String? title;
  final String? address;
  final int? areaId;
  final double? latitude;
  final double? longitude;
  final String? building;
  final String? apartment;
  final String? floor;
  final String? notes;
  final bool? isDefault;
  
  UpdateAddressRequest({
    this.title,
    this.address,
    this.areaId,
    this.latitude,
    this.longitude,
    this.building,
    this.apartment,
    this.floor,
    this.notes,
    this.isDefault,
  });
  
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (title != null) map['title'] = title;
    if (address != null) map['address'] = address;
    if (areaId != null) map['areaId'] = areaId;
    if (latitude != null) map['latitude'] = latitude;
    if (longitude != null) map['longitude'] = longitude;
    if (building != null) map['building'] = building;
    if (apartment != null) map['apartment'] = apartment;
    if (floor != null) map['floor'] = floor;
    if (notes != null) map['notes'] = notes;
    if (isDefault != null) map['isDefault'] = isDefault;
    return map;
  }
}
```

**Step 1.1.2:** Add updateAddress method to controller
```dart
// lib/features/profile/presentation/provider/address_controller.dart
// Add this method to existing AddressController class

String base_url = 'https://nartawi.smartvillageqatar.com/api';

Future<bool> updateAddress(int id, UpdateAddressRequest request) async {
  try {
    final token = await AuthService.getToken();
    if (token == null) {
      error = 'Authentication required';
      notifyListeners();
      return false;
    }
    
    final url = '$base_url/v1/client/account/addresses/$id';
    
    final response = await dio.put(
      url,
      data: request.toJson(),
      options: Options(
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
    
    if (response.statusCode == 204) {
      // Refresh address list after update
      await fetchAddresses();
      return true;
    }
    
    return false;
  } catch (e) {
    error = 'Failed to update address: $e';
    notifyListeners();
    return false;
  }
}
```

**Step 1.1.3:** Wire up edit address screen
- Find existing edit button in UI
- Call `updateAddress()` on submit
- Show success/error feedback

**Testing Checklist:**
- [ ] Update individual fields (partial update)
- [ ] Update all fields
- [ ] Handle 404 (address not found)
- [ ] Handle 401 (unauthorized)
- [ ] Verify list refreshes after update

---

### 1.2 Dispute Creation Integration

**Current State:**
- ✅ UI exists: `@dispute_alert.dart:1-78`
- ✅ Backend API: `POST /api/v1/client/disputes` confirmed
- ❌ Integration: Button at line 66 only closes dialog

**Files to Create:**
```
lib/features/disputes/domain/models/dispute_models.dart
lib/features/disputes/presentation/provider/dispute_controller.dart
```

**Files to Modify:**
```
lib/features/coupons/presentation/widgets/dispute_alert.dart (line 66)
lib/features/coupons/presentation/widgets/view_Consumption_history_alert.dart (lines 189, 194, 216)
```

**Implementation Steps:**

**Step 1.2.1:** Create dispute models
```dart
// lib/features/disputes/domain/models/dispute_models.dart

class CreateDisputeRequest {
  final String? title;
  final String claims;
  final List<DisputeItemRequest> items;
  final List<int>? documentIds;
  
  CreateDisputeRequest({
    this.title,
    required this.claims,
    required this.items,
    this.documentIds,
  });
  
  Map<String, dynamic> toJson() => {
    if (title != null) 'title': title,
    'claims': claims,
    'items': items.map((e) => e.toJson()).toList(),
    if (documentIds != null) 'documentIds': documentIds,
  };
}

class DisputeItemRequest {
  final int orderId;
  final int productId;
  
  DisputeItemRequest({required this.orderId, required this.productId});
  
  Map<String, dynamic> toJson() => {
    'orderId': orderId,
    'productId': productId,
  };
}

class Dispute {
  final int id;
  final String? title;
  final String claims;
  final int statusId;
  final String statusName;
  final DateTime issueTime;
  final DateTime? completedOn;
  final List<DisputeItem> items;
  final List<DisputeLog> logs;
  final int daysOpen;
  
  Dispute({
    required this.id,
    this.title,
    required this.claims,
    required this.statusId,
    required this.statusName,
    required this.issueTime,
    this.completedOn,
    required this.items,
    required this.logs,
    required this.daysOpen,
  });
  
  factory Dispute.fromJson(Map<String, dynamic> json) => Dispute(
    id: json['id'] as int,
    title: json['title'] as String?,
    claims: json['claims'] as String,
    statusId: json['statusId'] as int,
    statusName: json['statusName'] as String,
    issueTime: DateTime.parse(json['issueTime'] as String),
    completedOn: json['completedOn'] != null 
        ? DateTime.parse(json['completedOn'] as String) 
        : null,
    items: (json['items'] as List)
        .map((e) => DisputeItem.fromJson(e as Map<String, dynamic>))
        .toList(),
    logs: (json['logs'] as List)
        .map((e) => DisputeLog.fromJson(e as Map<String, dynamic>))
        .toList(),
    daysOpen: json['daysOpen'] as int,
  );
}

class DisputeItem {
  final int orderId;
  final int productId;
  final String productName;
  
  DisputeItem({
    required this.orderId,
    required this.productId,
    required this.productName,
  });
  
  factory DisputeItem.fromJson(Map<String, dynamic> json) => DisputeItem(
    orderId: json['orderId'] as int,
    productId: json['productId'] as int,
    productName: json['productName'] as String,
  );
}

class DisputeLog {
  final int id;
  final int actionId;
  final String actionName;
  final DateTime logTime;
  final String? notes;
  final bool isInternal;
  final String actionByName;
  
  DisputeLog({
    required this.id,
    required this.actionId,
    required this.actionName,
    required this.logTime,
    this.notes,
    required this.isInternal,
    required this.actionByName,
  });
  
  factory DisputeLog.fromJson(Map<String, dynamic> json) => DisputeLog(
    id: json['id'] as int,
    actionId: json['actionId'] as int,
    actionName: json['actionName'] as String,
    logTime: DateTime.parse(json['logTime'] as String),
    notes: json['notes'] as String?,
    isInternal: json['isInternal'] as bool,
    actionByName: json['actionByName'] as String,
  );
}
```

**Step 1.2.2:** Create dispute controller
```dart
// lib/features/disputes/presentation/provider/dispute_controller.dart

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/services/auth_service.dart';
import '../../domain/models/dispute_models.dart';

class DisputeController extends ChangeNotifier {
  final Dio dio;
  String base_url = 'https://nartawi.smartvillageqatar.com/api';
  
  bool isLoading = false;
  String? error;
  List<Dispute> disputes = [];
  
  DisputeController({required this.dio});
  
  Future<Dispute?> createDispute(CreateDisputeRequest request) async {
    isLoading = true;
    error = null;
    notifyListeners();
    
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        error = 'Authentication required';
        return null;
      }
      
      final url = '$base_url/v1/client/disputes';
      
      final response = await dio.post(
        url,
        data: request.toJson(),
        options: Options(
          headers: {
            'accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      
      if (response.statusCode == 201) {
        final dispute = Dispute.fromJson(response.data as Map<String, dynamic>);
        disputes.insert(0, dispute); // Add to top of list
        return dispute;
      }
      
      return null;
    } catch (e) {
      error = 'Failed to create dispute: $e';
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  
  Future<Dispute?> getDisputeById(int id) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) return null;
      
      final url = '$base_url/v1/client/disputes/$id';
      
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      
      if (response.statusCode == 200) {
        return Dispute.fromJson(response.data as Map<String, dynamic>);
      }
      
      return null;
    } catch (e) {
      debugPrint('Failed to fetch dispute: $e');
      return null;
    }
  }
}
```

**Step 1.2.3:** Modify dispute alert dialog
```dart
// lib/features/coupons/presentation/widgets/dispute_alert.dart
// Replace the existing _DisputeAlertDialogState class

class _DisputeAlertDialogState extends State<DisputeAlertDialog> {
  final TextEditingController _claimsController = TextEditingController();
  final DisputeController _disputeController = DisputeController(dio: Dio());
  List<String> _photoBase64 = [];
  bool _isSubmitting = false;
  
  @override
  void dispose() {
    _claimsController.dispose();
    _disputeController.dispose();
    super.dispose();
  }
  
  Future<void> _submitDispute() async {
    if (_claimsController.text.trim().isEmpty) {
      // Show error: Claims required
      return;
    }
    
    setState(() => _isSubmitting = true);
    
    // TODO: Upload photos first if any
    // List<int> documentIds = await _uploadPhotos(_photoBase64);
    
    final request = CreateDisputeRequest(
      claims: _claimsController.text.trim(),
      items: [
        // TODO: Get actual order and product IDs from context
        DisputeItemRequest(orderId: widget.orderId, productId: widget.productId),
      ],
      // documentIds: documentIds, // After photo upload implemented
    );
    
    final dispute = await _disputeController.createDispute(request);
    
    setState(() => _isSubmitting = false);
    
    if (dispute != null) {
      Navigator.pop(context, true); // Return success
      // Show success message
    } else {
      // Show error message
    }
  }
  
  @override
  Widget build(BuildContext context) {
    // ... existing UI code ...
    
    // Replace line 65-69 with:
    CancelOrderWidget(
      context, 
      screenWidth, 
      screenHeight,
      'Dispute',
      'Cancel',
      () async {
        if (!_isSubmitting) {
          await _submitDispute();
        }
      },
      () => Navigator.pop(context),
    )
  }
}
```

**Step 1.2.4:** Replace mock dispute data in consumption history
```dart
// lib/features/coupons/presentation/widgets/view_Consumption_history_alert.dart
// Lines 180-196 - Replace hardcoded data with API fetch

// Add to widget parameters:
final int? disputeId;

// In initState or whenever dispute flag is true:
if (widget.disbute && widget.disputeId != null) {
  _loadDisputeDetails();
}

Future<void> _loadDisputeDetails() async {
  final disputeController = DisputeController(dio: Dio());
  final dispute = await disputeController.getDisputeById(widget.disputeId!);
  
  if (dispute != null) {
    setState(() {
      _disputeClaims = dispute.claims; // Instead of 'Never Received Water'
      _disputeResolution = dispute.logs
          .where((log) => log.notes != null)
          .map((log) => log.notes!)
          .join(', '); // Instead of 'Returned'
    });
  }
}

// Then use _disputeClaims and _disputeResolution in UI
```

**Testing Checklist:**
- [ ] Submit dispute with text only
- [ ] Submit dispute with photos (after upload implemented)
- [ ] Handle validation errors
- [ ] Verify dispute appears in list
- [ ] Check real dispute data loads instead of mock text

---

### 1.3 Document Upload Support (for Disputes)

**Note:** Wait for backend answer to **Q20** about upload flow

**Two possible flows:**

**Option A: Separate upload then reference**
```dart
Future<List<int>> _uploadPhotos(List<String> base64Photos) async {
  final documentIds = <int>[];
  
  for (final photo in base64Photos) {
    final response = await dio.post(
      '$base_url/v1/documents',
      data: {
        'fileBase64': photo,
        'fileName': 'dispute_${DateTime.now().millisecondsSinceEpoch}.jpg',
        'documentType': 'DisputeEvidence',
      },
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    
    if (response.statusCode == 201) {
      documentIds.add(response.data['id'] as int);
    }
  }
  
  return documentIds;
}
```

**Option B: Direct base64 in dispute payload**
```dart
// Add to CreateDisputeRequest
final List<String>? photoBase64;

Map<String, dynamic> toJson() => {
  // ...
  if (photoBase64 != null) 'photos': photoBase64,
};
```

**Decision:** Wait for backend team response

---

## 🔧 PHASE 2: M1.0.3 - SCHEDULED ORDERS INTEGRATION

### 2.1 Prerequisites

**Blocked until backend team confirms:**
- [ ] All CRUD endpoints exist and are documented
- [ ] Time slots API endpoint (`GET /v1/time-slots`)
- [ ] Payload structures validated
- [ ] Coupon assignment logic clarified
- [ ] Auto-renewal implementation confirmed

**Estimated Unblock Date:** After backend responses received

---

### 2.2 Data Models

**Files to Create:**
```
lib/features/subscriptions/domain/models/scheduled_order.dart
lib/features/subscriptions/domain/models/time_slot.dart
lib/features/subscriptions/domain/models/create_scheduled_order_req.dart
```

**Step 2.2.1:** Create models (DRAFT - adjust based on backend response)
```dart
// lib/features/subscriptions/domain/models/scheduled_order.dart

class ScheduledOrder {
  final int id;
  final String title;
  final String cronExpression;
  final DateTime? lastRun;
  final DateTime nextRun;
  final bool isActive;
  final int? bundlePurchaseId;
  final List<ScheduledOrderItem> items;
  final List<ScheduledOrderDayTime> dayTimes;
  final int? remainingCoupons; // If backend provides this
  
  ScheduledOrder({
    required this.id,
    required this.title,
    required this.cronExpression,
    this.lastRun,
    required this.nextRun,
    required this.isActive,
    this.bundlePurchaseId,
    required this.items,
    required this.dayTimes,
    this.remainingCoupons,
  });
  
  factory ScheduledOrder.fromJson(Map<String, dynamic> json) {
    return ScheduledOrder(
      id: json['id'] as int,
      title: json['title'] as String,
      cronExpression: json['cronExpression'] as String,
      lastRun: json['lastRun'] != null 
          ? DateTime.parse(json['lastRun'] as String) 
          : null,
      nextRun: DateTime.parse(json['nextRun'] as String),
      isActive: json['isActive'] as bool,
      bundlePurchaseId: json['bundlePurchaseId'] as int?,
      items: (json['items'] as List)
          .map((e) => ScheduledOrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      dayTimes: (json['dayTimes'] as List)
          .map((e) => ScheduledOrderDayTime.fromJson(e as Map<String, dynamic>))
          .toList(),
      remainingCoupons: json['remainingCoupons'] as int?,
    );
  }
}

class ScheduledOrderItem {
  final int productVsid;
  final String productName;
  final double quantity;
  final String? notes;
  
  ScheduledOrderItem({
    required this.productVsid,
    required this.productName,
    required this.quantity,
    this.notes,
  });
  
  factory ScheduledOrderItem.fromJson(Map<String, dynamic> json) {
    return ScheduledOrderItem(
      productVsid: json['productVsid'] as int,
      productName: json['productName'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      notes: json['notes'] as String?,
    );
  }
  
  Map<String, dynamic> toJson() => {
    'productVsid': productVsid,
    'quantity': quantity,
    if (notes != null) 'notes': notes,
  };
}

class ScheduledOrderDayTime {
  final int dayOfWeek; // 0=Sunday, 1=Monday, etc.
  final int timeSlotId;
  final String? timeSlotName; // If backend provides
  
  ScheduledOrderDayTime({
    required this.dayOfWeek,
    required this.timeSlotId,
    this.timeSlotName,
  });
  
  factory ScheduledOrderDayTime.fromJson(Map<String, dynamic> json) {
    return ScheduledOrderDayTime(
      dayOfWeek: json['dayOfWeek'] as int,
      timeSlotId: json['timeSlotId'] as int,
      timeSlotName: json['timeSlotName'] as String?,
    );
  }
  
  Map<String, dynamic> toJson() => {
    'dayOfWeek': dayOfWeek,
    'timeSlotId': timeSlotId,
  };
}

// lib/features/subscriptions/domain/models/time_slot.dart

class TimeSlot {
  final int id;
  final String name; // "8AM-10AM"
  final int displayOrder;
  
  TimeSlot({
    required this.id,
    required this.name,
    required this.displayOrder,
  });
  
  factory TimeSlot.fromJson(Map<String, dynamic> json) => TimeSlot(
    id: json['id'] as int,
    name: json['name'] as String,
    displayOrder: json['displayOrder'] as int? ?? 0,
  );
}

// lib/features/subscriptions/domain/models/create_scheduled_order_req.dart

class CreateScheduledOrderRequest {
  final String title;
  final List<ScheduledOrderItem> items;
  final List<ScheduledOrderDayTime> dayTimes;
  final int? bundlePurchaseId; // If linking to bundle
  
  CreateScheduledOrderRequest({
    required this.title,
    required this.items,
    required this.dayTimes,
    this.bundlePurchaseId,
  });
  
  Map<String, dynamic> toJson() => {
    'title': title,
    'items': items.map((e) => e.toJson()).toList(),
    'dayTimes': dayTimes.map((e) => e.toJson()).toList(),
    if (bundlePurchaseId != null) 'bundlePurchaseId': bundlePurchaseId,
  };
}

class RescheduleRequest {
  final DateTime newDate;
  final String reason;
  
  RescheduleRequest({required this.newDate, required this.reason});
  
  Map<String, dynamic> toJson() => {
    'newDate': newDate.toIso8601String(),
    'reason': reason,
  };
}
```

---

### 2.3 Subscription Controller

**File to Create:**
```
lib/features/subscriptions/presentation/provider/subscription_controller.dart
```

```dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/services/auth_service.dart';
import '../../domain/models/scheduled_order.dart';
import '../../domain/models/time_slot.dart';
import '../../domain/models/create_scheduled_order_req.dart';

class SubscriptionController extends ChangeNotifier {
  final Dio dio;
  String base_url = 'https://nartawi.smartvillageqatar.com/api';
  
  List<ScheduledOrder> subscriptions = [];
  List<TimeSlot> timeSlots = [];
  
  bool isLoading = false;
  String? error;
  
  SubscriptionController({required this.dio});
  
  // Fetch available time slots
  Future<void> fetchTimeSlots() async {
    try {
      final token = await AuthService.getToken();
      if (token == null) return;
      
      final url = '$base_url/v1/time-slots'; // TODO: Confirm endpoint
      
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      
      if (response.statusCode == 200) {
        timeSlots = (response.data as List)
            .map((e) => TimeSlot.fromJson(e as Map<String, dynamic>))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Failed to fetch time slots: $e');
    }
  }
  
  // Fetch customer's scheduled orders
  Future<void> fetchScheduledOrders() async {
    isLoading = true;
    error = null;
    notifyListeners();
    
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        error = 'Authentication required';
        return;
      }
      
      final url = '$base_url/v1/client/scheduled-orders';
      
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      
      if (response.statusCode == 200) {
        final data = response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : {'data': response.data};
        
        subscriptions = (data['data'] as List)
            .map((e) => ScheduledOrder.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      error = 'Failed to fetch scheduled orders: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  
  // Create new scheduled order
  Future<ScheduledOrder?> createScheduledOrder(
    CreateScheduledOrderRequest request
  ) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) return null;
      
      final url = '$base_url/v1/client/scheduled-orders';
      
      final response = await dio.post(
        url,
        data: request.toJson(),
        options: Options(
          headers: {
            'accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      
      if (response.statusCode == 201) {
        final scheduledOrder = ScheduledOrder.fromJson(
          response.data as Map<String, dynamic>
        );
        subscriptions.insert(0, scheduledOrder);
        notifyListeners();
        return scheduledOrder;
      }
      
      return null;
    } catch (e) {
      error = 'Failed to create scheduled order: $e';
      notifyListeners();
      return null;
    }
  }
  
  // Update scheduled order preferences
  Future<bool> updateScheduledOrder(
    int id,
    CreateScheduledOrderRequest request
  ) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) return false;
      
      final url = '$base_url/v1/client/scheduled-orders/$id';
      
      final response = await dio.put(
        url,
        data: request.toJson(),
        options: Options(
          headers: {
            'accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      
      if (response.statusCode == 204 || response.statusCode == 200) {
        await fetchScheduledOrders(); // Refresh list
        return true;
      }
      
      return false;
    } catch (e) {
      error = 'Failed to update scheduled order: $e';
      notifyListeners();
      return false;
    }
  }
  
  // Request reschedule
  Future<bool> requestReschedule(int id, RescheduleRequest request) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) return false;
      
      final url = '$base_url/v1/client/scheduled-orders/$id/reschedule';
      
      final response = await dio.post(
        url,
        data: request.toJson(),
        options: Options(
          headers: {
            'accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      error = 'Failed to request reschedule: $e';
      notifyListeners();
      return false;
    }
  }
  
  // Cancel/deactivate scheduled order
  Future<bool> cancelScheduledOrder(int id) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) return false;
      
      final url = '$base_url/v1/client/scheduled-orders/$id';
      
      final response = await dio.delete(
        url,
        options: Options(
          headers: {
            'accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      
      if (response.statusCode == 204) {
        subscriptions.removeWhere((s) => s.id == id);
        notifyListeners();
        return true;
      }
      
      return false;
    } catch (e) {
      error = 'Failed to cancel scheduled order: $e';
      notifyListeners();
      return false;
    }
  }
}
```

---

### 2.4 Wire Up Existing UI

**Files to Modify:**
```
lib/features/coupons/presentation/widgets/coupon_card.dart
lib/features/coupons/presentation/widgets/refill_outline_button.dart
lib/features/coupons/presentation/widgets/calender_dialog.dart
```

**Step 2.4.1:** Connect Auto-Renewal toggle
```dart
// lib/features/coupons/presentation/widgets/coupon_card.dart
// Line 209-220

// Add to _CouponeCardState:
late final SubscriptionController _subscriptionController;
int? _scheduledOrderId; // If bundle has active schedule

@override
void initState() {
  super.initState();
  _subscriptionController = SubscriptionController(dio: Dio());
  
  // Check if bundle has active scheduled order
  _loadScheduledOrder();
}

Future<void> _loadScheduledOrder() async {
  await _subscriptionController.fetchScheduledOrders();
  
  // Find schedule linked to this bundle
  final schedule = _subscriptionController.subscriptions.firstWhere(
    (s) => s.bundlePurchaseId == widget.bundle.id,
    orElse: () => null,
  );
  
  if (schedule != null) {
    setState(() {
      _scheduledOrderId = schedule.id;
      _isSwitched = schedule.isActive;
    });
  }
}

// Update toggle onChanged:
onChanged: (value) async {
  if (_scheduledOrderId != null) {
    // Update existing schedule
    final success = await _subscriptionController.updateScheduledOrder(
      _scheduledOrderId!,
      CreateScheduledOrderRequest(
        title: widget.bundle.productName,
        items: [/* ... */],
        dayTimes: _selectedPreferredDays.map((day) => 
          ScheduledOrderDayTime(dayOfWeek: day, timeSlotId: _selectedTimeSlot)
        ).toList(),
      ),
    );
    
    if (success) {
      setState(() => _isSwitched = value);
    }
  } else {
    // Create new schedule
    setState(() => _isSwitched = value);
    // Trigger save on preferences submit
  }
}
```

**Step 2.4.2:** Save preferences on submit
```dart
// Add "Save Preferences" button at end of card (after NextRefillButton)
// When clicked, collect all state and call createScheduledOrder()

ElevatedButton(
  onPressed: () async {
    final request = CreateScheduledOrderRequest(
      title: '${widget.bundle.productName} - Weekly Delivery',
      items: [
        ScheduledOrderItem(
          productVsid: widget.bundle.productVsid, // TODO: Get from bundle
          quantity: double.parse(_quantityTwoController.text), // Bottles per delivery
          productName: widget.bundle.productName,
        ),
      ],
      dayTimes: _selectedPreferredDays.map((day) => 
        ScheduledOrderDayTime(
          dayOfWeek: day,
          timeSlotId: _selectedTimeSlot,
        )
      ).toList(),
      bundlePurchaseId: widget.bundle.id,
    );
    
    if (_scheduledOrderId != null) {
      // Update
      await _subscriptionController.updateScheduledOrder(_scheduledOrderId!, request);
    } else {
      // Create
      final schedule = await _subscriptionController.createScheduledOrder(request);
      if (schedule != null) {
        setState(() => _scheduledOrderId = schedule.id);
      }
    }
  },
  child: Text('Save Schedule'),
)
```

**Step 2.4.3:** Connect calendar reschedule
```dart
// lib/features/coupons/presentation/widgets/calender_dialog.dart
// Line 375 - Replace "Submit" button action

// Add parameters to widget:
final int? scheduledOrderId;
final SubscriptionController subscriptionController;

// In Submit button onTap (line 375):
onTap: () async {
  if (widget.scheduledOrderId != null && _requestDate != null) {
    final request = RescheduleRequest(
      newDate: _requestDate!,
      reason: 'Customer requested date change',
    );
    
    final success = await widget.subscriptionController.requestReschedule(
      widget.scheduledOrderId!,
      request,
    );
    
    if (success) {
      Navigator.pop(context, true); // Success
      // Show confirmation message
    } else {
      // Show error
    }
  }
}
```

**Testing Checklist:**
- [ ] Create new scheduled order from bundle
- [ ] Update preferences (days, frequency, bottles)
- [ ] Toggle auto-renewal on/off
- [ ] Request reschedule (one-time date change)
- [ ] Cancel scheduled order
- [ ] Verify coupons are consumed on delivery
- [ ] Check next delivery date updates correctly

---

### 2.5 My Subscriptions List Screen (NEW)

**File to Create:**
```
lib/features/subscriptions/presentation/screens/subscriptions_screen.dart
```

```dart
class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({Key? key}) : super(key: key);
  
  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  late final SubscriptionController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = SubscriptionController(dio: Dio());
    _controller.fetchScheduledOrders();
  }
  
  @override
  Widget build(BuildContext context) {
    // Similar layout to coupons_screen.dart
    // List of subscription cards showing:
    // - Title
    // - Next delivery date
    // - Status (Active/Paused)
    // - Actions: View details, Edit, Cancel
  }
}
```

**Add to Profile Menu:**
```dart
// lib/features/profile/presentation/pages/profile.dart
// Add "My Subscriptions" menu item
```

---

## 🔧 PHASE 3: M1.0.4 - PRODUCT DETAILS & SPECIFICATIONS

**Status:** ⚠️ HIGH RISK - Endpoints may not exist

**Blocked Until:** Backend team confirms **Q17** - Do endpoints exist?

---

### 3.1 If Endpoints Exist

**Files to Create:**
```
lib/features/home/domain/models/product_details.dart
lib/features/home/domain/models/product_specification.dart
```

**Files to Modify:**
```
lib/features/home/presentation/pages/suppliers/product_details.dart
lib/features/home/presentation/provider/product_details_controller.dart (NEW)
```

**Implementation:**
```dart
// Fetch and display in "Product Details" tab
// Currently shows empty tab at line 301
```

---

### 3.2 If Endpoints Don't Exist

**Action Required:** Backend team must implement:
1. `GET /api/v1/client/products/{vsId}/details`
2. `GET /api/v1/client/products/{vsId}/specifications`

**Mobile Work:** On hold until backend ready

---

## 🔧 PHASE 4: M1.0.5 - DISPUTES FULL FEATURE

**Status:** ✅ Ready - Backend APIs confirmed

### 4.1 Disputes List Screen

**File to Create:**
```
lib/features/disputes/presentation/screens/disputes_screen.dart
```

```dart
class DisputesScreen extends StatefulWidget {
  const DisputesScreen({Key? key}) : super(key: key);
  
  @override
  State<DisputesScreen> createState() => _DisputesScreenState();
}

class _DisputesScreenState extends State<DisputesScreen> {
  late final DisputeController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = DisputeController(dio: Dio());
    _fetchDisputes();
  }
  
  Future<void> _fetchDisputes() async {
    final token = await AuthService.getToken();
    if (token == null) return;
    
    final url = '$base_url/v1/client/disputes';
    
    final response = await _controller.dio.get(
      url,
      options: Options(
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
    
    if (response.statusCode == 200) {
      // Parse and display disputes
      setState(() {
        _controller.disputes = (response.data['data'] as List)
            .map((e) => Dispute.fromJson(e as Map<String, dynamic>))
            .toList();
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    // Similar to orders_screen.dart layout
    // Cards showing: Title, Status badge, Days open, Order number
    // Tap to view details
  }
}
```

### 4.2 Dispute Details Screen

**File to Create:**
```
lib/features/disputes/presentation/screens/dispute_details_screen.dart
```

```dart
class DisputeDetailsScreen extends StatelessWidget {
  final int disputeId;
  
  const DisputeDetailsScreen({required this.disputeId, Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // Header: Title, Status, Days open
    // Timeline: DISPUTE_LOG entries (filter isInternal=false)
    // Attachments section
    // Add evidence button (if not resolved)
  }
}
```

### 4.3 Add Entry Points

**1. Profile Menu:**
```dart
// lib/features/profile/presentation/pages/profile.dart
// Add "Disputes" menu item
ListTile(
  title: Text('My Disputes'),
  onTap: () => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => DisputesScreen()),
  ),
)
```

**2. Order Details:**
```dart
// lib/features/orders/presentation/pages/order_details.dart
// Add "Report Issue" button
ElevatedButton(
  child: Text('Report Issue'),
  onTap: () => showDialog(
    context: context,
    builder: (_) => DisputeAlertDialog(
      orderId: widget.order.id,
      productIds: widget.order.items.map((i) => i.productId).toList(),
    ),
  ),
)
```

---

## 🧪 TESTING STRATEGY

### Unit Tests
```
test/features/disputes/dispute_controller_test.dart
test/features/subscriptions/subscription_controller_test.dart
test/features/profile/address_controller_test.dart
```

### Integration Tests
```
integration_test/disputes_flow_test.dart
integration_test/scheduled_orders_flow_test.dart
```

### Manual Testing Checklist

**M1.0.2:**
- [ ] Update address (all fields)
- [ ] Update address (partial)
- [ ] Create dispute with text
- [ ] Create dispute with photos
- [ ] View dispute details (real data)

**M1.0.3:**
- [ ] Create scheduled order
- [ ] Update schedule preferences
- [ ] Request reschedule
- [ ] Toggle auto-renewal
- [ ] Cancel schedule
- [ ] Verify order auto-generation

**M1.0.4:**
- [ ] View product details tab
- [ ] View specifications list
- [ ] Check brand, description, barcode

**M1.0.5:**
- [ ] View disputes list
- [ ] View dispute timeline
- [ ] Add evidence to dispute
- [ ] Report issue from order

---

## 📊 PROGRESS TRACKING

### M1.0.2 Checklist
- [ ] UpdateAddressRequest model created
- [ ] updateAddress() method added
- [ ] Dispute models created
- [ ] DisputeController created
- [ ] Dispute alert wired up
- [ ] Mock data replaced with API data
- [ ] Unit tests written
- [ ] QA tested

### M1.0.3 Checklist
- [ ] Backend endpoints confirmed
- [ ] ScheduledOrder models created
- [ ] SubscriptionController created
- [ ] Auto-renewal toggle connected
- [ ] Preferences save implemented
- [ ] Calendar reschedule connected
- [ ] Subscriptions list screen created
- [ ] Unit tests written
- [ ] QA tested

### M1.0.4 Checklist
- [ ] Backend endpoints confirmed
- [ ] Product details fetched
- [ ] Specifications displayed
- [ ] Tab populated
- [ ] QA tested

### M1.0.5 Checklist
- [ ] Disputes list screen created
- [ ] Dispute details screen created
- [ ] Entry points added
- [ ] Unit tests written
- [ ] QA tested

---

## 🚨 RISKS & MITIGATION

| Risk | Impact | Mitigation |
|------|--------|------------|
| Backend scheduled orders endpoints don't match expectations | HIGH | Document exact structure in inquiry doc |
| Auto-renewal not implemented in backend | MEDIUM | Make it UI-only toggle, implement later |
| Product details endpoints don't exist | HIGH | Phase 3 becomes backend work first |
| Document upload flow unclear | LOW | Support both flows (separate/inline) |
| Time slots not exposed via API | MEDIUM | Use hardcoded slots temporarily |

---

## 📅 TIMELINE

| Phase | Duration | Dependencies | Start Date |
|-------|----------|--------------|------------|
| M1.0.2 | 1 week (40h) | Backend responses for Q16, Q20 | TBD |
| M1.0.3 | 2 weeks (60h) | Backend responses for Q1-Q15 | After M1.0.2 |
| M1.0.4 | 1 week (30h) | Backend implements endpoints | TBD |
| M1.0.5 | 1 week (40h) | None (APIs exist) | After M1.0.2 |

**Total:** 5 weeks (170 hours)

**Critical Path:** M1.0.3 (blocked on backend responses)

---

## ✅ DEFINITION OF DONE

Each phase is complete when:
1. ✅ All code committed and peer reviewed
2. ✅ Unit tests pass (>80% coverage)
3. ✅ Integration tests pass
4. ✅ QA testing complete (no critical bugs)
5. ✅ Design review approved (UI unchanged from mockups)
6. ✅ Documentation updated
7. ✅ Deployed to staging environment
8. ✅ Product owner acceptance

---

## 📞 NEXT STEPS

1. **Share inquiry doc with backend team**
2. **Wait for responses** (target: 2 business days)
3. **Schedule alignment meeting** if any conflicts
4. **Begin M1.0.2 implementation** (address + disputes)
5. **Parallel:** Backend team works on M1.0.3 endpoints
6. **Update this plan** based on backend responses

---

**Document Maintained By:** Mobile FE Team  
**Last Updated:** January 8, 2026  
**Version:** 1.0
