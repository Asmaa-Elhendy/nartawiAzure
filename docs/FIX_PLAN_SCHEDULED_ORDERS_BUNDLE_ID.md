# 🔧 FIX PLAN: Scheduled Orders - Use BundlePurchase.id instead of productVsid

**Issue:** Scheduled order functions currently use `BundlePurchase.productVsid` but should use `BundlePurchase.id`  
**Severity:** HIGH - Data Integrity Issue  
**Discovered:** Code review of M1.0.3 commit  
**Status:** Investigation Complete - Ready for Implementation

---

## 🎯 EXECUTIVE SUMMARY

### **The Problem**
The scheduled orders system incorrectly links scheduled deliveries to `productVsid` (product variant ID) instead of `bundlePurchaseId` (the specific bundle purchase ID). This creates a critical issue:

**Current Behavior (WRONG):**
- Customer buys Product A on Jan 1 → Creates Schedule 1 for `productVsid: 123`
- Customer buys Product A again on Jan 15 → Creates Schedule 2 for `productVsid: 123`
- System retrieves schedules by `productVsid` → Returns BOTH schedules
- **Result:** Cannot distinguish which schedule belongs to which purchase

**Expected Behavior (CORRECT):**
- Customer buys Product A on Jan 1 (bundleId: 456) → Creates Schedule 1 for `bundlePurchaseId: 456`
- Customer buys Product A again on Jan 15 (bundleId: 789) → Creates Schedule 2 for `bundlePurchaseId: 789`
- System retrieves schedule by `bundlePurchaseId` → Returns ONLY the relevant schedule
- **Result:** Each bundle purchase has its own unique schedule

---

## 📊 IMPACTED FUNCTIONS

### **3 Main Functions Identified:**

1. ✅ **`getSchedulesForProduct(int productVsid)`** - Line 459, `coupon_controller.dart`
2. ✅ **`createScheduledOrder({required int productVsid, ...})`** - Line 366, `coupon_controller.dart`
3. ✅ **`updateScheduledOrder({required int id, ...})`** - Line 400, `coupon_controller.dart`

**Additional Related Function:**
4. ✅ **`getScheduleForProduct(int productVsid)`** - Line 449, `coupon_controller.dart` (singular, not plural)

---

## 🔍 DETAILED INVESTIGATION FINDINGS

### **1. Data Model Analysis**

#### **BundlePurchase Model** (`lib/features/coupons/domain/models/bundle_purchase.dart`)

```dart
class BundlePurchase {
  final int id;                    // ✅ Bundle Purchase ID (unique per purchase)
  final String productName;
  final String vendorName;
  final int quantity;
  final int couponsPerBundle;
  final int totalCoupons;
  final num pricePerBundle;
  final num totalPrice;
  final num platformCommission;
  final num vendorPayout;
  final String vendorSkuPrefix;
  final DateTime purchasedAt;
  final String status;
  final int? productVsid;          // ❌ Product Variant ID (NOT unique per purchase)
  
  // ... constructor and fromJson
}
```

**Key Insight:**
- `id` = Unique identifier for THIS specific bundle purchase
- `productVsid` = Product variant ID (multiple purchases can have same productVsid)

#### **ScheduledOrderModel** (`lib/features/coupons/data/models/scheduled_order_model.dart`)

**Current Structure (WRONG):**
```dart
class ScheduledOrderModel {
  final int id;
  final int customerId;
  final String? customerName;
  final int productVsid;           // ❌ WRONG: Links to product, not purchase
  final String? productName;
  // ... other fields
}
```

**Missing Field:**
- ❌ **`bundlePurchaseId` field does NOT exist** - This is the root cause!

#### **CreateScheduledOrderRequest** (`lib/features/coupons/data/models/scheduled_order_model.dart`)

**Current Structure (WRONG):**
```dart
class CreateScheduledOrderRequest {
  final int productVsid;           // ❌ WRONG: Should be bundlePurchaseId
  final int weeklyFrequency;
  final int bottlesPerDelivery;
  final List<ScheduleEntry> schedule;
  final int deliveryAddressId;
  final bool autoRenewEnabled;
  final int? lowBalanceThreshold;
  
  // ... toJson sends 'productVsid' to backend
}
```

---

### **2. Impacted Files & Locations**

#### **File 1: `lib/features/coupons/presentation/provider/coupon_controller.dart`**

**Location 1: Line 366-397 - `createScheduledOrder` method**
```dart
Future<ScheduledOrderModel?> createScheduledOrder({
  required int productVsid,        // ❌ CHANGE TO: required int bundlePurchaseId,
  required int weeklyFrequency,
  required int bottlesPerDelivery,
  required List<ScheduleEntry> schedule,
  required int deliveryAddressId,
  required bool autoRenewEnabled,
  int? lowBalanceThreshold,
}) async {
  try {
    final request = CreateScheduledOrderRequest(
      productVsid: productVsid,    // ❌ CHANGE TO: bundlePurchaseId: bundlePurchaseId,
      weeklyFrequency: weeklyFrequency,
      bottlesPerDelivery: bottlesPerDelivery,
      schedule: schedule,
      deliveryAddressId: deliveryAddressId,
      autoRenewEnabled: autoRenewEnabled,
      lowBalanceThreshold: lowBalanceThreshold,
    );

    final created = await _scheduledOrderDataSource.createScheduledOrder(request);
    
    await fetchScheduledOrders();
    
    debugPrint('✅ Created scheduled order #${created.id}');
    return created;
  } catch (e) {
    _schedulesError = e.toString();
    debugPrint('❌ Error creating scheduled order: $e');
    notifyListeners();
    return null;
  }
}
```

**Location 2: Line 449-457 - `getScheduleForProduct` method (singular)**
```dart
ScheduledOrderModel? getScheduleForProduct(int productVsid) {
  // ❌ CHANGE SIGNATURE TO: getScheduleForBundle(int bundlePurchaseId)
  try {
    return _scheduledOrders.firstWhere(
      (s) => s.productVsid == productVsid && s.isActive,
      // ❌ CHANGE TO: (s) => s.bundlePurchaseId == bundlePurchaseId && s.isActive,
    );
  } catch (e) {
    return null;
  }
}
```

**Location 3: Line 459-461 - `getSchedulesForProduct` method (plural)**
```dart
List<ScheduledOrderModel> getSchedulesForProduct(int productVsid) {
  // ❌ CHANGE SIGNATURE TO: getSchedulesForBundle(int bundlePurchaseId)
  return _scheduledOrders.where((s) => s.productVsid == productVsid).toList();
  // ❌ CHANGE TO: return _scheduledOrders.where((s) => s.bundlePurchaseId == bundlePurchaseId).toList();
}
```

**Impact:** 🔴 HIGH - Core controller logic

---

#### **File 2: `lib/features/coupons/presentation/widgets/scheduled_order_helper.dart`**

**Location 1: Line 211 - Validation check**
```dart
if (bundle.productVsid == null) {
  // ❌ This check is checking wrong field
  // ✅ Should check: if (bundle.id == 0) or remove check entirely (id is required, not nullable)
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Product information missing. Cannot create schedule.'),
      backgroundColor: Colors.red,
    ),
  );
  return;
}
```

**Location 2: Line 284-292 - Creating scheduled order**
```dart
final created = await controller.createScheduledOrder(
  productVsid: bundle.productVsid!,  // ❌ CHANGE TO: bundlePurchaseId: bundle.id,
  weeklyFrequency: weeklyFrequency,
  bottlesPerDelivery: bottlesPerDelivery,
  schedule: scheduleEntries,
  deliveryAddressId: addressId,
  autoRenewEnabled: autoRenewEnabled,
  lowBalanceThreshold: lowBalanceThreshold,
);
```

**Impact:** 🔴 HIGH - This is where users create schedules

---

#### **File 3: `lib/features/coupons/presentation/widgets/coupon_card.dart`**

**Location: Line 88-89 - Loading schedule data**
```dart
if (_couponsController != null && widget.bundle.productVsid != null) {
  // ❌ CHANGE TO: if (_couponsController != null) {
  final schedule = _couponsController!.getScheduleForProduct(widget.bundle.productVsid!);
  // ❌ CHANGE TO: final schedule = _couponsController!.getScheduleForBundle(widget.bundle.id);
  
  if (schedule != null && mounted) {
    setState(() {
      _existingSchedule = schedule;
      _quantityController.text = schedule.weeklyFrequency.toString();
      _quantityTwoController.text = schedule.bottlesPerDelivery.toString();
      _isSwitched = schedule.autoRenewEnabled;
      
      _selectedPreferredDays.clear();
      for (var entry in schedule.schedule) {
        _selectedPreferredDays.add(entry.dayOfWeek);
        _selectedTimeSlotId = entry.timeSlotId;
      }
    });
    
    _quantityBloc.add(QuantityChanged(schedule.weeklyFrequency.toString()));
    _quantityTwoBloc.add(QuantityChanged(schedule.bottlesPerDelivery.toString()));
  }
}
```

**Impact:** 🔴 HIGH - This loads existing schedules in the UI

---

#### **File 4: `lib/features/coupons/data/models/scheduled_order_model.dart`**

**Location 1: Line 64-91 - ScheduledOrderModel class**
```dart
class ScheduledOrderModel {
  final int id;
  final int customerId;
  final String? customerName;
  final int productVsid;           // ❌ KEEP but ADD bundlePurchaseId field
  final String? productName;
  // ... other fields
  
  // ✅ ADD NEW FIELD:
  // final int bundlePurchaseId;    // Link to specific bundle purchase
}
```

**Location 2: Line 162-192 - CreateScheduledOrderRequest class**
```dart
class CreateScheduledOrderRequest {
  final int productVsid;           // ❌ CHANGE TO: final int bundlePurchaseId;
  final int weeklyFrequency;
  final int bottlesPerDelivery;
  final List<ScheduleEntry> schedule;
  final int deliveryAddressId;
  final bool autoRenewEnabled;
  final int? lowBalanceThreshold;

  CreateScheduledOrderRequest({
    required this.productVsid,     // ❌ CHANGE TO: required this.bundlePurchaseId,
    required this.weeklyFrequency,
    required this.bottlesPerDelivery,
    required this.schedule,
    required this.deliveryAddressId,
    required this.autoRenewEnabled,
    this.lowBalanceThreshold,
  });

  Map<String, dynamic> toJson() {
    return {
      'productVsid': productVsid,  // ❌ CHANGE TO: 'bundlePurchaseId': bundlePurchaseId,
      'weeklyFrequency': weeklyFrequency,
      'bottlesPerDelivery': bottlesPerDelivery,
      'schedule': schedule.map((s) => s.toJson()).toList(),
      'deliveryAddressId': deliveryAddressId,
      'autoRenewEnabled': autoRenewEnabled,
      if (lowBalanceThreshold != null) 'lowBalanceThreshold': lowBalanceThreshold,
    };
  }
}
```

**Impact:** 🔴 CRITICAL - Data models and API contract

---

#### **File 5: `lib/features/coupons/data/datasources/scheduled_order_remote_datasource.dart`**

**Location: Line 20-56 - createScheduledOrder method**
```dart
Future<ScheduledOrderModel> createScheduledOrder(
  CreateScheduledOrderRequest request,
) async {
  try {
    final token = await AuthService.getToken();
    
    print('🔵 Creating scheduled order: ${request.toJson()}');
    // ✅ This will automatically send bundlePurchaseId once model is fixed
    
    final response = await dio.post(
      '$baseUrl/v1/client/scheduled-orders',
      data: request.toJson(),  // ✅ No change needed - uses request.toJson()
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'accept': 'application/json',
        },
      ),
    );

    print('✅ Create response: ${response.statusCode}');
    
    if (response.statusCode == 201) {
      return ScheduledOrderModel.fromJson(response.data as Map<String, dynamic>);
      // ✅ Will automatically parse bundlePurchaseId once model is updated
    } else {
      throw Exception('Failed to create scheduled order');
    }
  } on DioException catch (e) {
    print('❌ DioException: ${e.response?.data}');
    final errorMessage = e.response?.data?['title']?.toString() 
        ?? e.response?.data?['detail']?.toString()
        ?? 'Failed to create schedule';
    throw Exception(errorMessage);
  } catch (e) {
    print('❌ Exception: $e');
    throw Exception('Unexpected error: $e');
  }
}
```

**Impact:** 🟡 MEDIUM - No code changes needed, just passes through the request

---

### **3. Additional Investigation: Related Code**

**Note:** `WalletCoupon` model already has `bundlePurchaseId` field:
```dart
// lib/features/coupons/domain/models/coupons_models.dart
class WalletCoupon {
  final int id;
  final int customerId;
  final int productVsid;
  final String productName;
  final String vendorSku;
  final String status;
  final int? orderId;
  final int? bundlePurchaseId;     // ✅ Already exists in coupon model!
  // ...
}
```

This confirms that the backend already supports `bundlePurchaseId` linking.

---

## 🔧 COMPREHENSIVE FIX PLAN

### **Phase 1: Data Model Updates** (30 minutes)

#### **Step 1.1: Update ScheduledOrderModel**
**File:** `lib/features/coupons/data/models/scheduled_order_model.dart`

**Changes:**
1. Add `bundlePurchaseId` field to `ScheduledOrderModel` class
2. Keep `productVsid` for backward compatibility and product info display
3. Update `fromJson` to parse `bundlePurchaseId`
4. Update constructor

**Code Changes:**
```dart
class ScheduledOrderModel {
  final int id;
  final int customerId;
  final String? customerName;
  final int bundlePurchaseId;      // ✅ ADD THIS FIELD
  final int productVsid;           // ✅ KEEP for product info
  final String? productName;
  // ... rest of fields

  ScheduledOrderModel({
    required this.id,
    required this.customerId,
    this.customerName,
    required this.bundlePurchaseId,  // ✅ ADD THIS
    required this.productVsid,
    this.productName,
    // ... rest of parameters
  });

  factory ScheduledOrderModel.fromJson(Map<String, dynamic> json) {
    return ScheduledOrderModel(
      id: json['id'] as int,
      customerId: json['customerId'] as int,
      customerName: json['customerName'] as String?,
      bundlePurchaseId: json['bundlePurchaseId'] as int,  // ✅ ADD THIS
      productVsid: json['productVsid'] as int,
      productName: json['productName'] as String?,
      // ... rest of parsing
    );
  }
}
```

#### **Step 1.2: Update CreateScheduledOrderRequest**
**File:** `lib/features/coupons/data/models/scheduled_order_model.dart`

**Changes:**
1. Change `productVsid` field to `bundlePurchaseId`
2. Update constructor parameter
3. Update `toJson` method

**Code Changes:**
```dart
class CreateScheduledOrderRequest {
  final int bundlePurchaseId;      // ✅ CHANGED from productVsid
  final int weeklyFrequency;
  final int bottlesPerDelivery;
  final List<ScheduleEntry> schedule;
  final int deliveryAddressId;
  final bool autoRenewEnabled;
  final int? lowBalanceThreshold;

  CreateScheduledOrderRequest({
    required this.bundlePurchaseId,  // ✅ CHANGED
    required this.weeklyFrequency,
    required this.bottlesPerDelivery,
    required this.schedule,
    required this.deliveryAddressId,
    required this.autoRenewEnabled,
    this.lowBalanceThreshold,
  });

  Map<String, dynamic> toJson() {
    return {
      'bundlePurchaseId': bundlePurchaseId,  // ✅ CHANGED
      'weeklyFrequency': weeklyFrequency,
      'bottlesPerDelivery': bottlesPerDelivery,
      'schedule': schedule.map((s) => s.toJson()).toList(),
      'deliveryAddressId': deliveryAddressId,
      'autoRenewEnabled': autoRenewEnabled,
      if (lowBalanceThreshold != null) 'lowBalanceThreshold': lowBalanceThreshold,
    };
  }
}
```

---

### **Phase 2: Controller Updates** (45 minutes)

#### **Step 2.1: Update createScheduledOrder method**
**File:** `lib/features/coupons/presentation/provider/coupon_controller.dart`
**Lines:** 366-397

**Changes:**
1. Change parameter from `productVsid` to `bundlePurchaseId`
2. Update CreateScheduledOrderRequest call

**Code Changes:**
```dart
Future<ScheduledOrderModel?> createScheduledOrder({
  required int bundlePurchaseId,   // ✅ CHANGED from productVsid
  required int weeklyFrequency,
  required int bottlesPerDelivery,
  required List<ScheduleEntry> schedule,
  required int deliveryAddressId,
  required bool autoRenewEnabled,
  int? lowBalanceThreshold,
}) async {
  try {
    final request = CreateScheduledOrderRequest(
      bundlePurchaseId: bundlePurchaseId,  // ✅ CHANGED
      weeklyFrequency: weeklyFrequency,
      bottlesPerDelivery: bottlesPerDelivery,
      schedule: schedule,
      deliveryAddressId: deliveryAddressId,
      autoRenewEnabled: autoRenewEnabled,
      lowBalanceThreshold: lowBalanceThreshold,
    );

    final created = await _scheduledOrderDataSource.createScheduledOrder(request);
    
    await fetchScheduledOrders();
    
    debugPrint('✅ Created scheduled order #${created.id}');
    return created;
  } catch (e) {
    _schedulesError = e.toString();
    debugPrint('❌ Error creating scheduled order: $e');
    notifyListeners();
    return null;
  }
}
```

#### **Step 2.2: Rename and update getScheduleForProduct (singular)**
**File:** `lib/features/coupons/presentation/provider/coupon_controller.dart`
**Lines:** 449-457

**Changes:**
1. Rename method to `getScheduleForBundle`
2. Change parameter to `bundlePurchaseId`
3. Filter by `bundlePurchaseId` instead of `productVsid`

**Code Changes:**
```dart
ScheduledOrderModel? getScheduleForBundle(int bundlePurchaseId) {  // ✅ RENAMED & CHANGED PARAM
  try {
    return _scheduledOrders.firstWhere(
      (s) => s.bundlePurchaseId == bundlePurchaseId && s.isActive,  // ✅ CHANGED
    );
  } catch (e) {
    return null;
  }
}

// ⚠️ DEPRECATED - Keep for backward compatibility temporarily
@deprecated
ScheduledOrderModel? getScheduleForProduct(int productVsid) {
  // Redirect to new method - find by first match
  // This is a temporary shim, will be removed in future version
  try {
    return _scheduledOrders.firstWhere(
      (s) => s.productVsid == productVsid && s.isActive,
    );
  } catch (e) {
    return null;
  }
}
```

#### **Step 2.3: Rename and update getSchedulesForProduct (plural)**
**File:** `lib/features/coupons/presentation/provider/coupon_controller.dart`
**Lines:** 459-461

**Changes:**
1. Rename method to `getSchedulesForBundle`
2. Change parameter to `bundlePurchaseId`
3. Filter by `bundlePurchaseId` instead of `productVsid`

**Code Changes:**
```dart
List<ScheduledOrderModel> getSchedulesForBundle(int bundlePurchaseId) {  // ✅ RENAMED & CHANGED PARAM
  return _scheduledOrders.where((s) => s.bundlePurchaseId == bundlePurchaseId).toList();  // ✅ CHANGED
}

// ⚠️ DEPRECATED - Keep for backward compatibility temporarily
@deprecated
List<ScheduledOrderModel> getSchedulesForProduct(int productVsid) {
  // This is a temporary shim, will be removed in future version
  return _scheduledOrders.where((s) => s.productVsid == productVsid).toList();
}
```

---

### **Phase 3: UI Widget Updates** (30 minutes)

#### **Step 3.1: Update scheduled_order_helper.dart**
**File:** `lib/features/coupons/presentation/widgets/scheduled_order_helper.dart`

**Location 1: Line 211 - Remove/update validation**
```dart
// ❌ OLD:
if (bundle.productVsid == null) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Product information missing. Cannot create schedule.'),
      backgroundColor: Colors.red,
    ),
  );
  return;
}

// ✅ NEW: Remove this check entirely (bundle.id is required, always exists)
// OR update error message:
// if (bundle.id == 0) {
//   ScaffoldMessenger.of(context).showSnackBar(
//     const SnackBar(
//       content: Text('Bundle purchase ID missing. Cannot create schedule.'),
//       backgroundColor: Colors.red,
//     ),
//   );
//   return;
// }
```

**Location 2: Line 284-292 - Update createScheduledOrder call**
```dart
// ❌ OLD:
final created = await controller.createScheduledOrder(
  productVsid: bundle.productVsid!,
  weeklyFrequency: weeklyFrequency,
  bottlesPerDelivery: bottlesPerDelivery,
  schedule: scheduleEntries,
  deliveryAddressId: addressId,
  autoRenewEnabled: autoRenewEnabled,
  lowBalanceThreshold: lowBalanceThreshold,
);

// ✅ NEW:
final created = await controller.createScheduledOrder(
  bundlePurchaseId: bundle.id,       // ✅ CHANGED
  weeklyFrequency: weeklyFrequency,
  bottlesPerDelivery: bottlesPerDelivery,
  schedule: scheduleEntries,
  deliveryAddressId: addressId,
  autoRenewEnabled: autoRenewEnabled,
  lowBalanceThreshold: lowBalanceThreshold,
);
```

#### **Step 3.2: Update coupon_card.dart**
**File:** `lib/features/coupons/presentation/widgets/coupon_card.dart`
**Lines:** 88-89

**Changes:**
```dart
// ❌ OLD:
if (_couponsController != null && widget.bundle.productVsid != null) {
  final schedule = _couponsController!.getScheduleForProduct(widget.bundle.productVsid!);
  
  // ... rest of code
}

// ✅ NEW:
if (_couponsController != null) {                                             // ✅ SIMPLIFIED
  final schedule = _couponsController!.getScheduleForBundle(widget.bundle.id);  // ✅ CHANGED
  
  // ... rest of code (no changes needed)
}
```

---

### **Phase 4: Testing & Validation** (45 minutes)

#### **Test Case 1: Single Bundle Purchase Schedule**
```
1. Customer buys Bundle A (id: 100, productVsid: 50)
2. Create schedule for Bundle A
3. Verify schedule created with bundlePurchaseId = 100
4. Load coupon card for Bundle A
5. Verify correct schedule loads
6. Update schedule
7. Verify schedule updated correctly
```

#### **Test Case 2: Multiple Purchases of Same Product**
```
1. Customer buys Product X Bundle (purchase 1: id=200, productVsid=50)
2. Create schedule for purchase 1 (2x per week)
3. Customer buys Product X Bundle again (purchase 2: id=201, productVsid=50)
4. Create schedule for purchase 2 (3x per week)
5. Load coupon card for purchase 1
6. Verify only 2x per week schedule shows (not the 3x)
7. Load coupon card for purchase 2
8. Verify only 3x per week schedule shows (not the 2x)
```

#### **Test Case 3: Backend API Integration**
```
1. Create schedule via mobile app
2. Verify backend receives bundlePurchaseId (not productVsid)
3. Fetch schedules via API
4. Verify response includes bundlePurchaseId
5. Update schedule
6. Verify update uses correct bundlePurchaseId
```

---

## 📊 IMPACT ASSESSMENT

### **Severity: HIGH**
- Affects core scheduling functionality
- Data integrity issue
- Multiple purchases of same product cannot be distinguished

### **Affected Users:**
- Any customer who purchases the same product bundle multiple times
- Vendors managing scheduled deliveries
- System administrators

### **Data Migration Required:**
- ⚠️ **YES** - Existing scheduled orders need `bundlePurchaseId` populated
- Backend team must provide migration script
- Mobile app must handle both old (productVsid-only) and new (bundlePurchaseId) data during transition

---

## ⚠️ RISKS & MITIGATION

### **Risk 1: Backend API Changes**
- **Risk:** Backend API may not support `bundlePurchaseId` yet
- **Mitigation:** Coordinate with backend team, confirm API contract
- **Action:** Review backend release notes for scheduled orders

### **Risk 2: Existing Data**
- **Risk:** Existing scheduled orders have no `bundlePurchaseId`
- **Mitigation:** Backend migration to populate missing `bundlePurchaseId`
- **Action:** Mobile app should gracefully handle null `bundlePurchaseId` initially

### **Risk 3: Breaking Changes**
- **Risk:** Changing parameter names breaks existing code
- **Mitigation:** Keep deprecated methods temporarily, add @deprecated annotation
- **Action:** Plan for deprecation removal in future release

---

## 📝 IMPLEMENTATION CHECKLIST

### **Pre-Implementation**
- [ ] Coordinate with backend team
- [ ] Confirm backend API supports `bundlePurchaseId`
- [ ] Review backend data migration plan
- [ ] Confirm API contract changes

### **Phase 1: Data Models**
- [ ] Add `bundlePurchaseId` to `ScheduledOrderModel`
- [ ] Update `ScheduledOrderModel.fromJson()` to parse `bundlePurchaseId`
- [ ] Change `CreateScheduledOrderRequest` parameter to `bundlePurchaseId`
- [ ] Update `CreateScheduledOrderRequest.toJson()` to send `bundlePurchaseId`
- [ ] Test model JSON parsing

### **Phase 2: Controller**
- [ ] Update `createScheduledOrder` parameter to `bundlePurchaseId`
- [ ] Update `CreateScheduledOrderRequest` instantiation
- [ ] Rename `getScheduleForProduct` → `getScheduleForBundle`
- [ ] Rename `getSchedulesForProduct` → `getSchedulesForBundle`
- [ ] Update filter logic from `productVsid` to `bundlePurchaseId`
- [ ] Add @deprecated to old methods

### **Phase 3: UI Widgets**
- [ ] Update `scheduled_order_helper.dart` validation check
- [ ] Update `scheduled_order_helper.dart` createScheduledOrder call
- [ ] Update `coupon_card.dart` getScheduleForBundle call
- [ ] Remove unnecessary null checks

### **Phase 4: Testing**
- [ ] Test single bundle purchase schedule creation
- [ ] Test multiple purchases of same product
- [ ] Test schedule loading in UI
- [ ] Test schedule updates
- [ ] Test error handling
- [ ] Test backend API integration
- [ ] Test with old data (null bundlePurchaseId)

### **Phase 5: Deployment**
- [ ] Code review
- [ ] Update release notes
- [ ] Coordinate backend deployment
- [ ] Deploy mobile app
- [ ] Monitor for errors
- [ ] Validate in production

---

## 🚀 RECOMMENDED APPROACH

### **Option A: Full Implementation (Recommended)**
- Fix all 3 functions + related code
- Coordinate with backend team
- Deploy with backend API changes
- **Time:** 2-3 hours
- **Risk:** Low (if coordinated)

### **Option B: Phased Rollout**
- Phase 1: Update data models only
- Phase 2: Update controller + UI (wait for backend)
- Phase 3: Deploy mobile changes
- **Time:** 3-4 hours (spread over multiple deploys)
- **Risk:** Medium (more coordination)

### **Recommended: Option A**
Single comprehensive fix with backend coordination is cleaner and less risky than phased rollout.

---

## 📄 SUMMARY

**Files to Modify:** 4 files  
**Functions to Update:** 3 main functions + 2 related  
**Estimated Time:** 2-3 hours  
**Testing Time:** 45 minutes  
**Backend Coordination Required:** YES  

**Critical Success Factors:**
1. ✅ Backend API must support `bundlePurchaseId` parameter
2. ✅ Backend must populate `bundlePurchaseId` in responses
3. ✅ Existing data must be migrated (backend team)
4. ✅ Mobile app must handle transition gracefully

---

**Status:** 🟢 Ready for Implementation (pending backend coordination)  
**Next Steps:** 
1. Confirm with backend team they support `bundlePurchaseId`
2. Review their data migration plan
3. Proceed with mobile implementation
4. Test thoroughly before deployment

---

*Investigation completed by Cascade AI - January 12, 2026*
