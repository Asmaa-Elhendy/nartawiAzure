# Nartawi Mobile - Implementation Roadmap (SSoT)

**Version:** M1.0.2 → M1.0.5  
**Status:** 🟢 Ready - All Backend APIs Confirmed  
**Date:** January 9, 2026  
**Authority:** Single Source of Truth for Mobile Implementation

---

## 🎯 DOCUMENT PURPOSE

This is the **OFFICIAL Single Source of Truth** for all mobile development work.

**Backend Team Confirmation:**
> *"FE team has everything needed to start integration immediately!"*
> - 100% of inquiries answered (20 sections)
> - All endpoints verified in production
> - Test accounts and Swagger provided
> - Known limitations documented with workarounds

**All implementation work MUST follow this roadmap.**

---

## 📊 RELEASES OVERVIEW

| Release | Status | Duration | Start | Features | Blockers |
|---------|--------|----------|-------|----------|----------|
| **M1.0.2** | 🟢 Ready | 1-2 weeks | **Today** | Address, Products, Bundles, Disputes | **NONE** |
| **M1.0.3** | 🟡 Partial | 2 weeks | +3 days | Scheduled Orders (Full CRUD) | UPDATE/DELETE in testing |
| **M1.0.4** | 🟢 Ready | 1 week | After M1.0.3 | Notifications, Reviews, Polish | **NONE** |
| **M1.0.5** | 🟢 Ready | 1 week | After M1.0.4 | Order Tracking, Final QA | **NONE** |

---

## 🚀 M1.0.2 - CORE INTEGRATION (Start Today)

**Theme:** Connect existing UI to backend APIs, remove mock data  
**Duration:** 1-2 weeks  
**Target:** January 23, 2026

### Features Summary

1. **Address Update** (2 days) - `PUT /v1/client/account/addresses/{id}`
2. **Product Details with Specs** (1 day) - Data in main product response
3. **Bundle Browsing** (2 days) - `GET /v1/client/products?isBundle=true`
4. **Disputes System** (3-4 days) - Create, track, upload evidence
5. **Remove Mock Data** (1 day) - Replace hardcoded data in coupons screen

---

### 1. ADDRESS UPDATE INTEGRATION

**Priority:** 🔴 HIGH | **Status:** ✅ Ready | **Duration:** 2 days

#### API Specification
- **Endpoint:** `PUT /api/v1/client/account/addresses/{id}`
- **Method:** PUT (requires ALL fields, not partial)
- **Auth:** Bearer token required

#### Required Fields
```json
{
  "address": "string (max 500)",  // Required
  "latitude": "double (-90 to 90)",  // Required
  "longitude": "double (-180 to 180)",  // Required
  "title": "string (max 100)",  // Optional
  "areaId": "int",  // Optional, validated
  "building": "string (max 50)",  // Optional
  "apartment": "string (max 50)",  // Optional
  "floor": "string (max 20)",  // Optional
  "notes": "string (max 1000)",  // Optional
  "isDefault": "boolean"  // Optional, default false
}
```

#### Implementation Tasks
1. Update `AddressModel` with all optional fields
2. Add `updateAddress()` method to controller
3. Connect existing UI form to API
4. Add field validation before API call
5. Handle 400/401/404 error responses
6. Show success/error messages
7. Test with `testcustomer@nartawi.com`

#### Acceptance Criteria
- [ ] All fields can be edited and saved
- [ ] GPS coordinates validated (range check)
- [ ] Field length limits enforced
- [ ] "Set as default" clears other defaults
- [ ] Success message shown
- [ ] Loading state during API call
- [ ] Error messages displayed properly

---

### 2. PRODUCT DETAILS WITH SPECIFICATIONS

**Priority:** 🔴 HIGH | **Status:** ✅ Ready | **Duration:** 1 day

#### API Specification
- **Endpoint:** `GET /api/v1/client/products/{id}`
- **KEY FINDING:** Specifications included in main response (no separate endpoint)

#### Response Includes
- Product description and brand
- **Specifications array** (sorted by displayOrder)
  - Each spec: nameEn, nameAr, value, unit, isHighlighted
- **Images array** (with isPrimary flag)
- **Inventory data** (totalAvailableQuantity, per-terminal stock)

#### Implementation Tasks
1. Add `ProductSpecification` model class
2. Add `ProductImage` model class
3. Update `ProductModel.fromJson()` to parse specs/images
4. Create Specifications tab in product details screen
5. Display highlighted specs prominently
6. Show image gallery with primary image first
7. Add stock status indicator (In Stock / Low Stock / Out of Stock)

#### Acceptance Criteria
- [ ] Specifications tab shows all specs
- [ ] Highlighted specs have distinct styling
- [ ] Spec values include units where applicable
- [ ] Multiple images shown in carousel
- [ ] Primary image displayed first
- [ ] Stock badge shown correctly
- [ ] "Add to Cart" disabled for out-of-stock
- [ ] Arabic/English specs based on locale

---

### 3. BUNDLE PRODUCTS BROWSING

**Priority:** 🔴 HIGH | **Status:** ✅ Ready | **Duration:** 2 days

#### API Specification
- **Endpoint:** `GET /api/v1/client/products?isBundle=true&pageSize=20`
- **KEY CONFIRMATION:** `isBundle` parameter EXISTS (added Release 1.0.20)

#### Query Parameters
```
isBundle: true/false  // Filter by bundle vs one-time
searchTerm: string
supplierId: int
minPrice: double
maxPrice: double
sortBy: string
pageNumber: int (default 1)
pageSize: int (default 20, max 100)
```

#### Implementation Tasks
1. Create new `BundlesBrowseScreen` (current coupons screen shows history only)
2. Add grid view with bundle cards
3. Add "Bundle" badge on cards
4. Implement pagination (load more on scroll)
5. Add filter dialog (vendor, price range)
6. Connect "Add to Cart" button
7. Add navigation link from home screen
8. Test bundle purchase flow (uses regular order endpoint)

#### Acceptance Criteria
- [ ] Grid displays available bundles
- [ ] Bundle badge visible on cards
- [ ] Pagination loads more bundles
- [ ] Pull-to-refresh reloads first page
- [ ] Filter by vendor works
- [ ] Add to cart functionality
- [ ] Bundle purchase creates order correctly
- [ ] Coupons generated after bundle purchase

---

### 4. DISPUTES SYSTEM

**Priority:** 🔴 HIGH | **Status:** ✅ Ready | **Duration:** 3-4 days

#### API Flow
1. **Upload photos:** `POST /v1/client/documents/upload` (multipart)
2. **Create dispute:** `POST /v1/client/disputes` (with document IDs)
3. **Track status:** `GET /v1/client/disputes/{id}`

#### Create Dispute Specification
```json
{
  "orderId": 185,
  "title": "Missing items",
  "claims": "Detailed description...",
  "disputeItems": [{
    "orderItemId": 421,
    "productId": 5,
    "quantity": 1,
    "issueType": "MISSING",  // MISSING, WRONG_ITEM, DAMAGED, etc.
    "description": "1 bottle not delivered"
  }],
  "requestedResolution": "REFUND_ONE_COUPON",  // REFUND_FULL, REPLACEMENT, etc.
  "attachmentIds": [45, 46]  // IDs from document upload
}
```

#### Business Rules
- Only delivered orders can be disputed
- Must create within 7 days of delivery
- One dispute per order
- Max 10 files (10MB each, JPG/PNG/PDF/MP4)

#### Implementation Tasks
1. Update existing `DisputeAlertDialog` to connect to API
2. Add photo picker (gallery + camera)
3. Implement document upload flow
4. Create `DisputeController` with create/list/details methods
5. Create `DisputesListScreen` to show all disputes
6. Create `DisputeDetailsScreen` to track status
7. Handle 7 dispute statuses (Open → Resolved/Escalated)
8. Show refund information when resolved

#### Acceptance Criteria
- [ ] User can select photos from gallery or camera
- [ ] Photos uploaded before dispute creation
- [ ] Dispute form validates all required fields
- [ ] Success message after submission
- [ ] Dispute appears in list screen
- [ ] Status updates shown in timeline
- [ ] Refund details displayed when resolved
- [ ] Can add more evidence after creation

---

### 5. REMOVE MOCK DATA FROM COUPONS SCREEN

**Priority:** 🔴 HIGH | **Duration:** 1 day

#### Current Mock Data Identified

**File:** `view_Consumption_history_alert.dart`
- Lines 188-194: Hardcoded dispute reason "Never Received Water"
- Lines 193: Hardcoded resolution "Returned"

#### Changes Needed
1. Replace hardcoded strings with data from dispute object
2. Fetch dispute details if coupon has dispute
3. Show "No dispute" if `disbute = false`
4. Display actual dispute reason and resolution from API
5. Link to dispute details screen for full info

#### API to Use
- `GET /v1/client/disputes/{id}` for dispute details
- Data already in coupon response includes dispute status

---

## 🔄 M1.0.3 - SCHEDULED ORDERS (Start +3 Days)

**Theme:** Complete scheduled orders implementation  
**Duration:** 2 weeks  
**Blockers:** UPDATE/DELETE endpoints in testing (3 days)

### Features

#### 1. Scheduled Order Creation ✅ Ready Now
- **Endpoint:** `POST /v1/client/scheduled-orders`
- Create subscription with weekly frequency and time slots
- Hardcode time slots in mobile (5 slots provided by backend)
- Auto-approval workflow (vendor must approve before active)

#### 2. Scheduled Order Listing ✅ Ready Now
- **Endpoint:** `GET /v1/client/scheduled-orders`
- Show all customer schedules with status
- Display `nextRun`, `remainingCoupons`, `estimatedRunsRemaining`

#### 3. Reschedule Request ✅ Ready Now
- **Endpoint:** `POST /v1/client/scheduled-orders/{id}/reschedule`
- Customer requests new date for next delivery
- Vendor must approve
- Only affects NEXT delivery, not entire schedule

#### 4. Update Schedule ⏸️ Wait 3 Days
- **Endpoint:** `PUT /v1/client/scheduled-orders/{id}`
- Update frequency, quantity, days, time slots
- Cannot change product (must cancel and recreate)
- Recalculates `nextRun` after update

#### 5. Cancel/Pause Schedule ⏸️ Wait 3 Days
- **Endpoint:** `DELETE /v1/client/scheduled-orders/{id}`
- Soft delete (sets `isActive = false`)
- Unused coupons remain in wallet
- Cannot reactivate (must create new)

### Implementation Plan

#### Phase 1 (Start Today if desired)
1. Create hardcoded time slots constant file
2. Implement CREATE flow in existing UI
3. Connect `NextRefillButton` to reschedule API
4. Update `CouponeCard` to show schedule details

#### Phase 2 (Wait 3 Days)
5. Implement UPDATE endpoint when confirmed
6. Implement DELETE/CANCEL endpoint when confirmed
7. Add edit schedule dialog
8. Full integration testing

### Key Validations
- `dayOfWeek`: 0-6 (0=Sunday) ✅ Confirmed aligned with mobile
- `weeklyFrequency`: 1-7
- `bottlesPerDelivery`: > 0
- Schedule array length must match weeklyFrequency
- `timeSlotId`: 1-5 (hardcoded)

### Auto-Renewal Clarification
- Does NOT auto-purchase bundles
- Only sends notification when balance low
- Pauses schedule until manual refill
- Update UI text: "Notify me when balance is low" (not "Auto-purchase")

---

## 🔔 M1.0.4 - NOTIFICATIONS & POLISH

**Theme:** Notifications, reviews, favorites  
**Duration:** 1 week  
**Start:** After M1.0.3

### Features

#### 1. Notifications System ✅
- `GET /v1/client/notifications?pageNumber=1`
- `GET /v1/client/notifications/unread-count`
- `POST /v1/client/notifications/{id}/read`
- `POST /v1/client/notifications/read-all`
- `POST /v1/client/notifications/push-tokens` (FCM registration)

#### 2. Notification Preferences ✅
- `GET /v1/client/notifications/preferences`
- `PUT /v1/client/notifications/preferences`
- Toggle order updates, scheduled reminders, disputes, marketing

#### 3. Reviews (Suppliers Only) ✅
- `GET /v1/client/reviews?supplierId=1`
- `POST /v1/client/reviews` (after order delivered)
- Rating scale: 1-5 stars
- One review per order
- **Note:** Reviews for SUPPLIERS, NOT products (business model)

#### 4. Favorites (Already Working) ✅
- `POST /v1/client/favorites/products/{productVsid}`
- `DELETE /v1/client/favorites/products/{productVsid}`
- Same for vendors
- Just test and verify working correctly

---

## 📦 M1.0.5 - ORDER TRACKING & FINAL QA

**Theme:** Order tracking, POD viewing, final polish  
**Duration:** 1 week  
**Start:** After M1.0.4

### Features

#### 1. Order Status Tracking ✅
- Real-time order status updates (7 statuses)
- Timeline view showing status history
- Driver info when "Out for Delivery"
- Estimated delivery time

#### 2. Proof of Delivery Viewing ✅
- POD photo included in order/coupon details
- GPS coordinates and geofence validation
- Delivery person name and timestamp
- "Report Issue" button if geofence invalid

#### 3. Order Cancellation ✅
- `POST /v1/client/orders/{id}/cancel`
- Immediate cancel if status = Pending
- Requires vendor approval if Accepted
- Refund processing (coupons/wallet/card)

#### 4. Driver Location Polling
- Poll driver location every 30 seconds when "Out for Delivery"
- Display on map
- No WebSocket (use polling)

---

## 🔧 TECHNICAL SPECIFICATIONS

### Authentication
- **Access Token:** 60 minutes expiry
- **Refresh Token:** 7 days expiry
- **Endpoint:** `POST /api/Auth/refresh-token`
- **Auto-refresh:** Implement Dio interceptor for 401 responses

### Error Handling
**Standard error format:**
```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Validation failed",
    "details": [{
      "field": "email",
      "message": "Invalid email format"
    }],
    "timestamp": "2026-01-09T15:00:00Z"
  }
}
```

**HTTP Status Codes:**
- 200 OK, 201 Created, 202 Accepted
- 400 Bad Request, 401 Unauthorized, 403 Forbidden, 404 Not Found, 409 Conflict
- 500 Internal Server Error

### Pagination
**Standard params:**
```
pageNumber: int (default 1)
pageSize: int (default 20, max 100)
```

**Response:**
```json
{
  "items": [...],
  "pagination": {
    "currentPage": 1,
    "totalPages": 5,
    "totalCount": 87,
    "hasNextPage": true
  }
}
```

### Validation Rules
- Phone: `+974-XXXX-XXXX` (Qatar format)
- Email: Max 100 chars
- Password: Min 8 chars, 1 uppercase, 1 number
- Dates: ISO 8601 (`2026-01-09T15:00:00Z`)
- Timezone: UTC+3 (Doha, no DST)

### Caching Strategy
**Cache Forever:**
- Product categories
- Time slots (when endpoint created)
- Areas list

**Cache 1 Hour:**
- Product list (by category/vendor)
- Bundle products

**Never Cache:**
- Wallet balance
- Order status
- Notifications
- Coupon availability

---

## ⚠️ KNOWN LIMITATIONS & WORKAROUNDS

### 1. Delivery Address Not Stored in Orders
- **Problem:** `CUSTOMER_ORDER` table lacks `DELIVERY_ADDRESS_ID`
- **Impact:** Order history shows wrong address if customer edits addresses
- **Workaround:** Cache delivery address locally in mobile
- **Fix:** Release 1.0.21 (2 weeks) - database migration

### 2. Time Slots API Missing
- **Problem:** No `GET /v1/time-slots` endpoint
- **Workaround:** Hardcode 5 time slots in mobile (provided by backend)
- **File:** `lib/core/constants/time_slots.dart`

**Time Slots:**
1. Early Morning (6:00-9:00)
2. Before Noon (10:00-13:00)
3. Afternoon (13:00-17:00)
4. Evening (17:00-21:00)
5. Night (20:00-23:59)

### 3. No Real-Time Updates
- **Problem:** No WebSocket/SignalR
- **Workaround:** Use polling
  - Order status: Every 10 seconds when active
  - Driver location: Every 30 seconds when out for delivery
  - Notifications: Every 60 seconds

### 4. No Offline Support
- **Problem:** Backend requires internet
- **Workaround:** Cache read-only data locally, queue writes for retry

### 5. No Staging Environment
- **Problem:** Only production environment exists
- **Workaround:** Use test accounts carefully, clean up test data

---

## 🧪 TESTING REQUIREMENTS

### Test Accounts (Production)
**Customer:**
```
Email: testcustomer@nartawi.com
Password: Test@123456
Phone: +974-5555-0001
Role: Client
```

**Vendor:**
```
Email: testvendor@nartawi.com
Password: Test@123456
Role: Vendor
```

### Swagger Documentation
**URL:** `https://nartawi.smartvillageqatar.com/swagger/index.html`

**How to use:**
1. Login via `/api/auth/login`
2. Copy `accessToken`
3. Click "Authorize" button
4. Paste as `Bearer {token}`
5. Test all endpoints

### Testing Checklist (M1.0.2)

**Address Update:**
- [ ] Update with all fields
- [ ] Update with only required fields
- [ ] Validate GPS range
- [ ] Test invalid area ID
- [ ] Test token refresh on 401

**Product Details:**
- [ ] Product with specifications
- [ ] Product without specifications
- [ ] Multi-image product
- [ ] Out-of-stock product
- [ ] Arabic specs display

**Bundle Browsing:**
- [ ] Grid displays bundles
- [ ] Pagination works
- [ ] Filter by vendor
- [ ] Add bundle to cart
- [ ] Purchase bundle (creates order + coupons)

**Disputes:**
- [ ] Upload photos from gallery
- [ ] Take photos with camera
- [ ] Create dispute with evidence
- [ ] View dispute list
- [ ] Track dispute status
- [ ] View refund when resolved

---

## 📋 ACCEPTANCE CRITERIA SUMMARY

### M1.0.2 Complete When:
- [ ] Address update works with all fields
- [ ] Product details shows specs and images
- [ ] Bundle browsing screen functional
- [ ] Disputes can be created and tracked
- [ ] Mock data removed from coupons screen
- [ ] All API errors handled gracefully
- [ ] Loading states shown during API calls
- [ ] Success/error messages displayed
- [ ] No crashes or blocking bugs
- [ ] Tested with test accounts in production

### M1.0.3 Complete When:
- [ ] Scheduled orders can be created
- [ ] Existing schedules displayed with details
- [ ] Reschedule requests sent successfully
- [ ] Update schedule works (after 3-day wait)
- [ ] Cancel schedule works (after 3-day wait)
- [ ] Time slots hardcoded correctly
- [ ] Auto-renewal UI text updated
- [ ] Coupon balance warnings working

### M1.0.4 Complete When:
- [ ] Notifications list displayed
- [ ] Unread count badge shown
- [ ] Mark as read functionality
- [ ] FCM push tokens registered
- [ ] Notification preferences toggleable
- [ ] Supplier reviews submittable
- [ ] Favorites work correctly

### M1.0.5 Complete When:
- [ ] Order status tracking real-time
- [ ] Driver location polling when delivering
- [ ] POD photos viewable
- [ ] Order cancellation with refunds
- [ ] All features integrated and tested
- [ ] Final QA passed
- [ ] Ready for production release

---

## 🚨 CRITICAL REMINDERS

1. **All API calls require Bearer token** - Implement auto-refresh on 401
2. **PUT requires ALL fields** - Address update needs complete payload
3. **isBundle=true confirmed** - Bundle browsing is ready to implement
4. **Time slots hardcoded** - Use provided list until endpoint created
5. **No separate product details API** - Everything in main product response
6. **Bundle purchases use order endpoint** - Backend handles coupon generation
7. **Disputes need document upload first** - Two-step process
8. **Day of week aligned** - 0=Sunday confirmed matching mobile
9. **Auto-renewal is notification-only** - Not automatic purchase yet
10. **Coupons pooled** - Not reserved per schedule, used dynamically

---

## 📞 SUPPORT & ESCALATION

**For Development Questions:**
- Backend team Slack channel
- Email: dev@nartawi.com
- Response time: 4-8 hours

**For Production Issues:**
- P1 Critical: Call immediately
- P2 High: Slack #urgent-issues
- P3 Medium: Create ticket

**SLA:**
- API availability: 99.5% uptime
- Maintenance: Sundays 2:00-4:00 AM (Doha time)
- Advance notice: 48 hours

---

**END OF ROADMAP**

**Next Steps:**
1. Review this roadmap with team
2. Start M1.0.2 implementation today
3. Create tickets for each feature
4. Daily standups to track progress
5. Test continuously with test accounts

**Document Status:** ✅ Complete - Ready for implementation

