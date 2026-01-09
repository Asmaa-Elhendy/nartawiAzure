# Backend Responses Analysis - Part 1

**Date:** January 9, 2026  
**Analyzed By:** Mobile FE Team  
**Source:** COMPREHENSIVE_BACKEND_RESPONSES-Part1.md  
**Coverage:** Sections 1-7 (Authentication through Regular Orders)

---

## 🎯 EXECUTIVE SUMMARY

**Response Quality:** ⭐⭐⭐⭐⭐ Excellent - Detailed, with code examples and validation rules

**Key Statistics:**
- ✅ **70% endpoints confirmed working**
- ⚠️ **20% partially implemented** (scheduled orders UPDATE/DELETE)
- ❌ **10% missing** (time slots API, areas API)
- 🔴 **3 critical blockers identified** with workarounds provided

**Immediate Actions:**
1. ✅ Start M1.0.2 implementation (address update, disputes) - **NO BLOCKERS**
2. ⏸️ Wait 3 days for scheduled orders client endpoints completion
3. 🔧 Use workarounds for delivery address and time slots

---

## 🔴 CRITICAL BLOCKERS & WORKAROUNDS

### BLOCKER #1: Delivery Address Not Stored in Orders ⚠️

**Problem:** `CUSTOMER_ORDER` table lacks `DELIVERY_ADDRESS_ID` field

**Impact:** HIGH - Order history shows wrong address if customer edits their addresses

**Status:** Database design limitation acknowledged by backend team

**WORKAROUND (Immediate):**
```dart
// Mobile stores deliveryAddressId locally for display
// Backend uses it for validation but doesn't persist
// Order creation still works, just history is inaccurate
```

**PROPER FIX:** 
- Release 1.0.21 (2 weeks)
- Database migration adds `DELIVERY_ADDRESS_ID` and `DELIVERY_ADDRESS_SNAPSHOT` columns
- Mobile changes: NONE (same request structure)

**Action:** Proceed with current implementation, no mobile changes needed

---

### BLOCKER #2: Scheduled Orders Client Endpoints Partial ⏸️

**Problem:** Vendor endpoints exist, client-facing endpoints incomplete

**Status:** Backend team creating client endpoints - **ETA 3 days**

**What EXISTS NOW:**
- ✅ `POST /api/v1/client/scheduled-orders` - CREATE
- ✅ `GET /api/v1/client/scheduled-orders` - LIST
- ⚠️ `PUT /api/v1/client/scheduled-orders/{id}` - UPDATE (in testing)
- ⚠️ `DELETE /api/v1/client/scheduled-orders/{id}` - CANCEL (in testing)
- ✅ `POST /api/v1/client/scheduled-orders/{id}/reschedule` - RESCHEDULE

**Action:** 
- Can start CREATE/READ implementation immediately
- Wait 3 days for UPDATE/DELETE confirmation before implementing
- Use provided payload structures and validation rules

---

### BLOCKER #3: Time Slots API Missing ❌

**Problem:** No `GET /api/v1/time-slots` endpoint

**Status:** Not implemented

**WORKAROUND:** Hardcode time slots in mobile

```dart
// lib/core/constants/time_slots.dart
class TimeSlots {
  static final List<Map<String, dynamic>> slots = [
    {
      "id": 1,
      "name": "Early Morning",
      "nameAr": "الصباح الباكر",
      "timeRange": "6:00-9:00",
      "displayOrder": 1
    },
    {
      "id": 2,
      "name": "Before Noon",
      "nameAr": "قبل الظهيرة",
      "timeRange": "10:00-13:00",
      "displayOrder": 2
    },
    {
      "id": 3,
      "name": "Afternoon",
      "nameAr": "بعد الظهر",
      "timeRange": "13:00-17:00",
      "displayOrder": 3
    },
    {
      "id": 4,
      "name": "Evening",
      "nameAr": "المساء",
      "timeRange": "17:00-21:00",
      "displayOrder": 4
    },
    {
      "id": 5,
      "name": "Night",
      "nameAr": "الليل",
      "timeRange": "20:00-23:59",
      "displayOrder": 5
    }
  ];
}
```

**Action:** Use hardcoded list, request backend team prioritize endpoint creation

---

## ✅ CONFIRMED WORKING ENDPOINTS

### Section 1: Authentication ✅

| Endpoint | Status | Notes |
|----------|--------|-------|
| `POST /api/Auth/login` | ✅ Working | Returns roles array |
| `POST /api/Auth/refresh-token` | ✅ Working | 60min access token expiry |
| `POST /api/Auth/logout` | ✅ Working | Invalidates token |

**Key Details:**
- Access token: 60 minutes
- Refresh token: 7 days
- Roles included in login response
- JWT token includes role claims
- Multiple roles supported per account

**Mobile Implementation:**
```dart
// Auto-refresh token on 401
class DioInterceptor extends Interceptor {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final refreshed = await AuthService.refreshToken();
      if (refreshed) {
        // Retry original request
        return handler.resolve(await _retry(err.requestOptions));
      }
    }
    handler.next(err);
  }
}
```

---

### Section 2: Address Management ✅

| Endpoint | Status | Notes |
|----------|--------|-------|
| `PUT /api/v1/client/account/addresses/{id}` | ✅ Working | PUT behavior (all fields) |
| `GET /api/v1/client/account/addresses` | ✅ Working | List addresses |
| `POST /api/v1/client/account/addresses` | ✅ Working | Create address |
| `DELETE /api/v1/client/account/addresses/{id}` | ✅ Working | Hard delete |

**Field Requirements:**

**Required:**
- `address` (string, max 500 chars)
- `latitude` (double, -90 to 90)
- `longitude` (double, -180 to 180)

**Optional:**
- `title` (string, max 100 chars)
- `areaId` (int, validated against AREA table)
- `building`, `apartment` (string, max 50 chars)
- `floor` (string, max 20 chars)
- `notes` (string, max 1000 chars)
- `isDefault` (bool)

**Important:** PUT requires ALL fields, not partial update

---

### Section 3: Products ✅

| Endpoint | Status | Notes |
|----------|--------|-------|
| `GET /api/v1/client/products` | ✅ Working | With isBundle filter! |
| `GET /api/v1/client/products/{id}` | ✅ Working | Includes details + specs |
| `GET /api/v1/client/categories/{id}/products` | ✅ Working | Category filtering |

**MAJOR CONFIRMATION:** `isBundle=true` filter EXISTS (added in Release 1.0.20)

**Test Queries:**
```
# Bundle products only
GET /api/v1/client/products?isBundle=true&pageSize=20

# One-time products only
GET /api/v1/client/products?isBundle=false&pageSize=20
```

**Product Details & Specs:**
- ✅ NO separate endpoints needed
- ✅ ALL data in main product response
- Includes: descriptions, brand, specifications array, images array, inventory

**Example Response Structure:** (See lines 467-556 in responses)

---

### Section 4: Bundle Products ✅

| Endpoint | Status | Notes |
|----------|--------|-------|
| `GET /api/v1/client/products?isBundle=true` | ✅ Working | NEW in 1.0.20 |
| `POST /api/v1/client/orders` | ✅ Working | Handles bundle purchases |
| `GET /api/v1/client/wallet/bundle-purchases` | ✅ Working | Purchase history |
| `POST /api/v1/client/bundle-purchases/{id}/cancel` | ✅ Working | Cancel if unused |

**Key Finding:** Bundle purchases use SAME order endpoint as regular orders
- Backend detects `IS_BUNDLE = true` on product
- Auto-creates `BUNDLE_PURCHASE` record
- Auto-generates coupons

**No separate bundle purchase endpoint needed**

---

### Section 5: Coupons & Wallet ✅

| Endpoint | Status | Notes |
|----------|--------|-------|
| `GET /api/v1/client/wallet/balance` | ✅ Working | Cash + coupon balance |
| `GET /api/v1/client/wallet/coupons` | ✅ Working | With filters |
| `GET /api/v1/client/wallet/bundle-purchases` | ✅ Working | Purchase history |

**Coupon Status Values:**
1. `"Available"` - Ready to use
2. `"Pending"` - Assigned to scheduled order
3. `"Used"` - Consumed in delivery
4. `"Disputed"` - Under investigation
5. `"Returned"` - Refunded
6. `"Expired"` - Past expiry date

**Proof of Delivery:**
- ✅ Included in coupon response (no separate endpoint)
- Includes: photoUrl, GPS, timestamp, delivery person, geofence validation

**Coupon Grouping:**
- ✅ Current mobile logic is CORRECT (group by consumed_at day/hour)
- ✅ Better approach: Group by `consumedByOrderId` directly
- One order = One delivery batch

---

### Section 6: Scheduled Orders ⚠️ PARTIAL

| Endpoint | Status | ETA | Notes |
|----------|--------|-----|-------|
| `POST /api/v1/client/scheduled-orders` | ✅ Working | Now | Create subscription |
| `GET /api/v1/client/scheduled-orders` | ✅ Working | Now | List subscriptions |
| `PUT /api/v1/client/scheduled-orders/{id}` | ⚠️ Testing | 3 days | Update schedule |
| `DELETE /api/v1/client/scheduled-orders/{id}` | ⚠️ Testing | 3 days | Cancel (soft delete) |
| `POST /api/v1/client/scheduled-orders/{id}/reschedule` | ✅ Working | Now | Request date change |

**CREATE Endpoint Details:**

**Request Structure:**
```json
{
  "productVsid": 1,
  "weeklyFrequency": 3,
  "bottlesPerDelivery": 2,
  "schedule": [
    {"dayOfWeek": 1, "timeSlotId": 1},
    {"dayOfWeek": 3, "timeSlotId": 3},
    {"dayOfWeek": 5, "timeSlotId": 2}
  ],
  "deliveryAddressId": 1,
  "autoRenewEnabled": true,
  "lowBalanceThreshold": 5
}
```

**Validation Rules:**
- `productVsid`: Required
- `weeklyFrequency`: 1-7
- `bottlesPerDelivery`: > 0
- `schedule` array length must equal `weeklyFrequency`
- `dayOfWeek`: 0-6 (0=Sunday) ✅ CONFIRMED SAME AS MOBILE
- `timeSlotId`: 1-5
- `deliveryAddressId`: Required
- `autoRenewEnabled`: Optional (default false)
- `lowBalanceThreshold`: Optional (default 10)

**Business Logic:**
1. Customer submits → Status = "Pending"
2. Vendor approves → Status = "Active", `nextRun` calculated
3. CRON generates orders daily at midnight
4. Orders created 1 day in advance

**CRON Expression:**
- ✅ Backend auto-generates (mobile doesn't calculate)
- Example: Mon/Wed/Fri at 8AM → `0 8 * * 1,3,5`

**Coupon Assignment:**
- Coupons NOT pre-assigned to schedules
- Backend uses "first available" logic when generating orders
- All coupons pooled, used dynamically

**Auto-Renewal:**
- ⚠️ Currently notification-only (not auto-purchase)
- When balance < threshold → Notification sent, schedule paused
- Customer must manually buy bundles
- Schedule resumes when balance refilled
- Future: Auto-purchase with stored payment method

**Reschedule Workflow:**
1. Customer requests via `POST /reschedule`
2. Creates `SCHEDULED_ORDER_RESCHEDULE_REQUEST` (status: Pending)
3. Vendor approves/rejects
4. Customer notified
5. If approved: Only NEXT delivery rescheduled (not entire schedule)

---

### Section 7: Regular Orders ✅

| Endpoint | Status | Notes |
|----------|--------|-------|
| `POST /api/v1/client/orders` | ✅ Working | Create order |
| `GET /api/v1/client/orders` | ✅ Working | Order history |
| `GET /api/v1/client/orders/{id}` | ✅ Working | Order details |
| `POST /api/v1/client/orders/{id}/cancel` | ✅ Working | Cancel order |

**Order Creation Request:**
```json
{
  "items": [
    {
      "productId": 5,
      "quantity": 2,
      "notes": "Cold water please"
    }
  ],
  "deliveryAddressId": 3,
  "couponIds": [123, 124],
  "notes": "Ring doorbell twice",
  "timeSlotId": 2,
  "deliveryDate": "2026-01-10"
}
```

**Key Details:**
- `deliveryAddressId`: Required (but not stored - see Blocker #1)
- `terminalId`: NOT required (auto-selected by backend based on area)
- `couponIds`: Array (multiple coupons supported)
- Payment options: coupons, wallet, card, cash on delivery
- Multiple payment methods: NOT supported yet

**Terminal Selection:**
- Backend auto-selects based on customer's `AREA_ID`
- Matches area → finds terminal serving that area → uses terminal with highest stock

---

## ❌ MISSING ENDPOINTS

| Endpoint | Impact | Workaround | Priority |
|----------|--------|------------|----------|
| `GET /api/v1/time-slots` | Medium | Hardcode in mobile | High |
| `GET /api/v1/client/areas` | Low | Use admin endpoint | Medium |
| `GET /api/v1/client/scheduled-orders/{id}/orders` | Low | Use filter on orders endpoint | Low |

---

## 📊 ENDPOINT STATUS MATRIX

### ✅ READY TO IMPLEMENT (M1.0.2)

**Authentication:**
- Login, logout, refresh token ✅

**Address Management:**
- Create, read, update, delete ✅

**Products:**
- List with isBundle filter ✅
- Product details with specs ✅

**Coupons:**
- Wallet balance ✅
- Coupon listing with filters ✅

**Orders:**
- Create, read, cancel ✅

**Disputes:**
- *Waiting for Part 2 of responses*

---

### ⏸️ BLOCKED - WAITING 3 DAYS (M1.0.3)

**Scheduled Orders:**
- CREATE ✅ (can start immediately)
- READ ✅ (can start immediately)
- UPDATE ⏸️ (wait for testing completion)
- DELETE ⏸️ (wait for testing completion)
- RESCHEDULE ✅ (can start immediately)

---

### 🔧 WORKAROUND AVAILABLE

**Delivery Address Storage:**
- Use provided workaround
- Track fix in Release 1.0.21 (2 weeks)

**Time Slots:**
- Hardcode list
- Request endpoint creation

**Areas List:**
- Use `GET /api/areas` (admin endpoint, no auth required)

---

## 🎯 UPDATED IMPLEMENTATION PRIORITIES

### **IMMEDIATE START - M1.0.2 (This Week)**

**1. Address Update Integration** - NO BLOCKERS
```
✅ Endpoint confirmed: PUT /api/v1/client/account/addresses/{id}
✅ Field requirements documented
✅ Validation rules clear
Action: Implement immediately
```

**2. Product Details Display** - NO SEPARATE ENDPOINTS NEEDED
```
✅ All data in main product response
✅ Specifications array included
✅ Images array included
Action: Update product details screen to use existing response data
```

**3. Bundle Products Filter** - CONFIRMED WORKING
```
✅ isBundle parameter exists
✅ Added in Release 1.0.20
Action: Implement bundle browsing screen
```

---

### **START IN 3 DAYS - M1.0.3 (Next Week)**

**4. Scheduled Orders Implementation**
```
✅ CREATE endpoint ready
✅ READ endpoint ready
✅ RESCHEDULE endpoint ready
⏸️ UPDATE endpoint in testing (ETA: 3 days)
⏸️ DELETE endpoint in testing (ETA: 3 days)

Action: 
- Start CREATE/READ/RESCHEDULE now
- Wait for UPDATE/DELETE confirmation
- Use hardcoded time slots
```

---

### **WAITING FOR PART 2**

**5. Disputes System**
- Document upload flow
- Dispute creation
- Dispute listing
- *Need responses to Section 8 questions*

---

## 📋 CRITICAL VALIDATIONS CONFIRMED

### Day of Week Convention ✅
- Mobile: 0=Sunday, 6=Saturday
- Backend: 0=Sunday, 6=Saturday
- **ALIGNED** - No conversion needed

### Coupon Status Values ✅
1. Available
2. Pending
3. Used
4. Disputed
5. Returned
6. Expired

### Time Slots (Hardcoded) ✅
1. Early Morning (6:00-9:00)
2. Before Noon (10:00-13:00)
3. Afternoon (13:00-17:00)
4. Evening (17:00-21:00)
5. Night (20:00-23:59)

### Token Expiry ✅
- Access: 60 minutes
- Refresh: 7 days
- Auto-refresh on 401

### Timezone ✅
- All times in Doha (UTC+3 / AST)
- No daylight saving in Qatar

---

## 🚨 IMPORTANT BUSINESS LOGIC CLARIFICATIONS

### Bundle Purchase Flow ✅
```
1. Customer browses bundles (isBundle=true)
2. Customer adds to cart (local)
3. Customer checks out
4. Mobile calls: POST /api/v1/client/orders (same as regular orders)
5. Backend detects IS_BUNDLE = true
6. Backend creates BUNDLE_PURCHASE record
7. Backend generates coupons
8. Customer can now create scheduled order
```

### Scheduled Order CRON ✅
```
- Runs daily at midnight (Doha time)
- Generates orders 1 day in advance
- Checks available coupons before generation
- If insufficient coupons: Skip delivery, notify customer
- After 3 missed deliveries: Auto-pause schedule
```

### Auto-Renewal Current State ⚠️
```
✅ Toggle exists in UI
✅ Low balance threshold configurable
❌ Does NOT auto-purchase bundles
✅ Sends notification when low
✅ Pauses schedule until manual refill

Mobile UI should say: "Notify me when balance is low"
NOT: "Automatically purchase bundles"
```

### Coupon Pooling ✅
```
- All coupons for same product pooled together
- NOT reserved per scheduled order
- Used dynamically (first available)
- One-time orders and scheduled orders share same pool
- Risk: Customer uses all coupons for one-time orders, schedule fails
```

---

## 📝 RECOMMENDED MOBILE CHANGES

### 1. Update Coupon Grouping Logic
**Current:** Group by `consumedAt` day/hour
**Better:** Group by `consumedByOrderId`

```dart
// Better approach
final deliveryBatches = coupons
    .where((c) => c.consumedByOrderId != null)
    .groupBy((c) => c.consumedByOrderId)
    .map((orderId, coupons) => DeliveryBatch(
        orderId: orderId,
        coupons: coupons,
        deliveredAt: coupons.first.consumedAt,
        count: coupons.length,
    ));
```

### 2. Token Refresh Interceptor
```dart
class AuthInterceptor extends Interceptor {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Try refresh
      final refreshed = await AuthService.refreshToken();
      if (refreshed) {
        // Retry original request with new token
        final opts = err.requestOptions;
        opts.headers['Authorization'] = 'Bearer ${await AuthService.getToken()}';
        final response = await Dio().fetch(opts);
        return handler.resolve(response);
      } else {
        // Refresh failed, redirect to login
        NavigationService.navigateToLogin();
      }
    }
    handler.next(err);
  }
}
```

### 3. Hardcode Time Slots
Create `lib/core/constants/time_slots.dart` with provided data

### 4. Auto-Renewal UI Text
Change from: "Automatically purchase new bundles"
To: "Notify me when coupon balance is low"

---

## ⏭️ NEXT STEPS

### For Mobile Team:
1. ✅ Read Part 2 of backend responses when available
2. ✅ Update MOBILE_FE_IMPLEMENTATION_PLAN.md with accurate data
3. ✅ Start M1.0.2 implementation immediately (no blockers)
4. ⏸️ Schedule M1.0.3 kickoff for 3 days from now
5. 📋 Create tickets in project management system

### Questions for Backend Team (Part 2):
- Dispute endpoints confirmation (Section 8)
- Document upload flow (Section 9)
- Notifications structure (Section 11)
- Delivery operations (Section 13)
- Error handling standards (Section 14)

---

**Analysis Complete:** Part 1 covers ~40% of all inquiries  
**Blocking Issues:** 0 (all have workarounds)  
**Ready to Start:** M1.0.2 implementation  
**Next Review:** After Part 2 responses received
