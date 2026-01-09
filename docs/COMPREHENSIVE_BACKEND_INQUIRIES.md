# Comprehensive Backend Validation & API Inquiries

**Date:** January 8, 2026  
**Purpose:** Complete validation of backend implementation, API structure, and business logic alignment  
**Scope:** All features required for mobile app - addresses, products, bundles, coupons, orders, disputes, scheduled orders, search, specifications  
**Context:** Mobile FE has significant UI implementation but missing API integrations. Need complete backend validation before proceeding.

---

## 📋 TABLE OF CONTENTS

1. [Authentication & Authorization](#section-1-authentication--authorization)
2. [Address Management](#section-2-address-management)
3. [Product Catalog & Search](#section-3-product-catalog--search)
4. [Bundle Products & Purchasing](#section-4-bundle-products--purchasing)
5. [Coupons & Wallet](#section-5-coupons--wallet)
6. [Scheduled Orders (Subscriptions)](#section-6-scheduled-orders-subscriptions)
7. [Regular Orders](#section-7-regular-orders)
8. [Disputes System](#section-8-disputes-system)
9. [Document Management](#section-9-document-management)
10. [Favorites](#section-10-favorites)
11. [Notifications](#section-11-notifications)
12. [Reviews & Ratings](#section-12-reviews--ratings)
13. [Delivery Operations](#section-13-delivery-operations)
14. [Error Handling & Standards](#section-14-error-handling--standards)
15. [Performance & Pagination](#section-15-performance--pagination)

---

## 🔐 SECTION 1: AUTHENTICATION & AUTHORIZATION

### Q1.1: Token Management
- **Current understanding:** Mobile uses `AuthService.getToken()` and sends as `Bearer {token}`
- **Question:** What's the token refresh mechanism?
  - Does token expire? If yes, after how long?
  - Is there a refresh token endpoint?
  - Should mobile handle 401 responses by refreshing token automatically?

### Q1.2: Role-Based Access
From SSoT: Accounts have roles (Admin, Vendor, Client, Delivery)

- **Question:** How does mobile determine user role after login?
  - Is role included in login response?
  - Should we call `GET /v1/client/account` after login to get role?
  - Can one account have multiple roles?

### Q1.3: Account Types in Mobile
Mobile UI currently shows customer features only.

- **Confirmed:** Mobile serves customers and delivery personnel
- **Question:** Do delivery personnel login through same app or separate credentials?
- **Question:** How does app detect user type and show appropriate UI?
- **Question:** Any role-switching mechanism or strictly one role per account?

---

## 🏠 SECTION 2: ADDRESS MANAGEMENT

### Q2.1: Address Update Endpoint
**Confirmed in Swagger (Position 12):** `PUT /api/v1/client/account/addresses/{id}`

**Request payload validation:**
```json
{
  "title": "Home",
  "address": "Building 45, Zone 52",
  "areaId": 3,
  "latitude": 25.276987,
  "longitude": 51.520008,
  "building": "45",
  "apartment": "3A",
  "floor": "3",
  "notes": "Ring doorbell twice",
  "isDefault": true
}
```

**Questions:**
- Which fields are **required** vs optional?
- Can we do partial updates (PATCH-like behavior) or must send all fields?
- What validates `areaId`? Is there a `GET /areas` endpoint?
- GPS coordinate validation rules? (range, precision)
- Max length for text fields? (title, address, notes)

### Q2.2: Area/Zone Management
Mobile shows area selection in address forms.

- **Question:** `GET /api/v1/areas` endpoint exists?
- **Expected response:**
  ```json
  [
    {"id": 1, "nameEn": "Al Sadd", "nameAr": "السد", "isActive": true},
    {"id": 2, "nameEn": "West Bay", "nameAr": "الخليج الغربي", "isActive": true}
  ]
  ```
- **Question:** Are areas hierarchical (city → zone → area)?

### Q2.3: Default Address Logic
- **Question:** When setting `isDefault: true`, does backend auto-set previous default to false?
- **Question:** Can customer have multiple default addresses (one per address type)?
- **Question:** What happens if customer deletes their only address?

### Q2.4: Delivery Address for Orders
From SSoT line 700-702: `CUSTOMER_ORDER` table has **critical limitation** - no `DELIVERY_ADDRESS_ID` field.

- **CRITICAL QUESTION:** How is delivery address stored for orders?
  - Is it copied as JSON in order record?
  - Is it derived from customer's default address at order creation time?
  - Can customer specify different address per order?
- **Question:** Where does mobile send `deliveryAddressId` in order creation payload?

---

## 🛍️ SECTION 3: PRODUCT CATALOG & SEARCH

### Q3.1: Products Endpoint Structure
**Confirmed:** `GET /api/v1/client/products` with filters

**Current mobile implementation uses:**
- `searchTerm`, `categoryId`, `supplierId`, `sortBy`, `pageIndex`, `pageSize`

**Questions:**
- Is `searchTerm` a full-text search? Which fields does it search? (name, description, SKU?)
- Does it support Arabic search terms?
- Case-sensitive or insensitive?
- Any fuzzy matching or exact match only?

### Q3.2: Product Details Extended Data
From SSoT lines 1766-1844: `PRODUCT_DETAILS` table exists with:
- `BRAND`, `INTERNAL_CODE` (barcode)
- `EN_DESCRIPTION`, `AR_DESCRIPTION` (4000 chars each)
- `LOW_STOCK_THRESHOLD`, `IS_PINNED`, `PINNED_ORDER`

**CRITICAL QUESTIONS:**
- ❓ Does `GET /api/v1/client/products/{vsId}/details` endpoint exist?
- ❓ Or is extended data included in main product response?
- **If endpoint exists, provide:**
  - Example response payload
  - Any authorization requirements
  - Is it public or requires authentication?

### Q3.3: Product Specifications
From SSoT lines 1705-1762: `PRODUCT_SPECIFICATION` table with:
- `SPEC_NAME_EN/AR`, `SPEC_VALUE`, `UNIT`
- `DISPLAY_ORDER`, `IS_HIGHLIGHTED`

**CRITICAL QUESTIONS:**
- ❓ Does `GET /api/v1/client/products/{vsId}/specifications` endpoint exist?
- **If yes, provide:**
  - Example response payload
  - How many specs per product typically?
  - Are specs sorted by `DISPLAY_ORDER`?

**Example expected response:**
```json
[
  {
    "id": 1,
    "specNameEn": "pH Level",
    "specNameAr": "مستوى الحموضة",
    "specValue": "7.8",
    "unit": null,
    "displayOrder": 1,
    "isHighlighted": true
  },
  {
    "id": 2,
    "specNameEn": "Sodium",
    "specNameAr": "صوديوم",
    "specValue": "15",
    "unit": "mg/L",
    "displayOrder": 2,
    "isHighlighted": false
  }
]
```

### Q3.4: Product Images
From SSoT: `PRODUCT_IMAGES` table exists.

- **Question:** Are images included in main product response?
- **Question:** Image URL format? Full URL or relative path?
- **Question:** Primary image vs gallery images - how differentiated?
- **Question:** Max images per product?

### Q3.5: Product Availability
- **Question:** How does mobile know if product is out of stock?
- **Question:** Is there a `stockQuantity` field in response?
- **Question:** Or just boolean `isAvailable`?
- **Question:** Should mobile hide out-of-stock products or show as disabled?

---

## 📦 SECTION 4: BUNDLE PRODUCTS & PURCHASING

### Q4.1: Bundle Products Filter
Mobile needs to show bundles separately from regular products.

**CRITICAL QUESTION:** Does `GET /api/v1/client/products` support `isBundle=true` filter?

**Test queries:**
```
GET /api/v1/client/products?isBundle=true
GET /api/v1/client/products?isBundle=false
```

- **If YES:** Provide example response
- **If NO:** How should mobile filter bundles? By category? By product type?

### Q4.2: Bundle Structure
From SSoT lines 616-657: `BUNDLE` table links bundle VSID to single-item VSID.

**Questions:**
- Does product response include bundle relationship data?
- **Example:** Product VSID 100 (25-gallon bundle) links to VSID 10 (1-gallon single)
  - Does response show this relationship?
  - Does it show: `"linkedProductVsid": 10` or similar?

### Q4.3: Bundle Purchase Endpoint
Mobile shows bundle purchase history at `GET /v1/client/wallet/bundle-purchases` ✅ **CONFIRMED WORKING**

**Question:** How do customers **purchase** bundles?
- Is it through regular order flow `POST /v1/client/orders`?
- Or separate endpoint `POST /v1/client/bundle-purchases`?
- Or vendor-only endpoint?

**Clarification needed:** Bundle purchase workflow:
1. Customer browses bundles
2. Customer adds to cart
3. Customer checks out → **What endpoint creates BUNDLE_PURCHASE record?**
4. Backend generates coupons in COUPONS_BALANCE
5. Customer can now create scheduled order using those coupons

### Q4.4: Bundle Purchase Details
When fetching `GET /v1/client/wallet/bundle-purchases`, response includes:
- `id`, `productName`, `vendorName`, `quantity`, `couponsPerBundle`, `totalCoupons`
- `pricePerBundle`, `totalPrice`, `platformCommission`, `vendorPayout`
- `purchasedAt`, `status`

**Questions:**
- What are valid `status` values? (Pending, Completed, Cancelled?)
- Can customer cancel bundle purchase?
- Refund logic - if cancelled, do coupons get revoked?

---

## 🎟️ SECTION 5: COUPONS & WALLET

### Q5.1: Wallet Balance Endpoint
✅ **CONFIRMED WORKING:** `GET /v1/client/wallet/balance`

Mobile receives:
- Cash balance
- Coupon balance (total coupons, available, used, expired)
- Low balance warnings

**Questions:**
- How often should mobile refresh wallet balance? (On app open? After each transaction?)
- Is there a WebSocket/push notification for real-time balance updates?
- Balance currency - always QAR?

### Q5.2: Coupons Listing
✅ **CONFIRMED WORKING:** `GET /v1/client/wallet/coupons` with pagination

Mobile uses filters: `productVsid`, `vendorId`, `status`

**Questions:**
- What are ALL valid `status` values?
  - Available, Used, Expired, Disputed, Cancelled?
- Does it support date range filters? (e.g., expiring soon)
- Any bulk operations endpoint? (e.g., mark multiple as used)

### Q5.3: Coupon Consumption Tracking
Mobile shows "View Last Consumption" feature.

Current logic (`@coupon_controller.dart:211`): Groups coupons by `MARKED_USED_AT` day/hour

**Questions:**
- Is this the correct grouping logic?
- Should coupons be grouped by `CUSTOMER_ORDER.ISSUE_TIME` instead?
- How does backend determine which coupons were used in same delivery?
- Is there a `deliveryBatchId` or similar concept?

### Q5.4: Proof of Delivery (POD)
Mobile displays POD data:
- GPS location, photo URL, geofence validation, delivery timestamp

**Questions:**
- Is `proofOfDelivery` object included in coupon response?
- Or requires separate call `GET /v1/coupons/{id}/proof-of-delivery`?
- Photo URL - full URL or need to construct?
- Can customer dispute if POD shows wrong location?

### Q5.5: Coupon Serial Number Format
From SSoT line 631: `COUPON_SERIAL = {VENDOR_SKU_PREFIX}/{COUPON_INDEX}`

**Example:** `ZAWAYA/00001`, `ZAWAYA/00002`

**Questions:**
- Is serial number included in coupon response?
- Any QR code generation for coupons? (mobile scanning?)
- Serial number validation rules - format, length?

---

## 🔄 SECTION 6: SCHEDULED ORDERS (SUBSCRIPTIONS)

### Q6.1: Client CRUD Endpoints

**Q6.1.1 - CREATE:** Does `POST /api/v1/client/scheduled-orders` exist?
**Expected payload:**
```json
{
  "title": "Weekly Water Delivery",
  "items": [
    {"productVsid": 1, "quantity": 2, "notes": "Leave at door"}
  ],
  "dayTimes": [
    {"dayOfWeek": 0, "timeSlotId": 1},
    {"dayOfWeek": 2, "timeSlotId": 1}
  ],
  "bundlePurchaseId": 5
}
```

**Questions:**
- Is `bundlePurchaseId` required or optional?
- Can schedule be created without bundle purchase (using existing coupons)?
- Does backend validate sufficient coupons before creating?
- Does backend auto-generate `CRON_EXPRESSION` from `dayTimes`?

**Q6.1.2 - READ:** Does `GET /api/v1/client/scheduled-orders` exist?
**Expected response:**
```json
{
  "data": [
    {
      "id": 1,
      "title": "Weekly Water",
      "cronExpression": "0 8 * * 0,2,4",
      "lastRun": "2026-01-05T08:00:00Z",
      "nextRun": "2026-01-12T08:00:00Z",
      "isActive": true,
      "bundlePurchaseId": 5,
      "items": [...],
      "dayTimes": [...],
      "remainingCoupons": 20
    }
  ],
  "pagination": {...}
}
```

**Questions:**
- Is it paginated?
- Any filters? (active, inactive, by bundle, by product)
- Does response include remaining coupons count?
- Does response include next delivery date clearly?

**Q6.1.3 - UPDATE:** Does `PUT /api/v1/client/scheduled-orders/{id}` exist?

**Questions:**
- Can customer update all fields or only specific ones?
- Updateable fields: title, items, dayTimes, isActive?
- Does updating reset next delivery date?
- Validation - can't reduce items if coupons already consumed?

**Q6.1.4 - DELETE/CANCEL:** Does `DELETE /api/v1/client/scheduled-orders/{id}` exist?

**Questions:**
- Hard delete or soft delete (set `isActive = false`)?
- What happens to unused coupons? Returned to wallet?
- Can customer reactivate cancelled schedule?

### Q6.2: Time Slots Management

**Q6.2.1:** Does `GET /api/v1/time-slots` endpoint exist?

**Expected response:**
```json
[
  {"id": 1, "name": "8AM-10AM", "nameAr": "8 صباحاً - 10 صباحاً", "displayOrder": 1},
  {"id": 2, "name": "10AM-12PM", "nameAr": "10 صباحاً - 12 ظهراً", "displayOrder": 2},
  {"id": 3, "name": "12PM-2PM", "nameAr": "12 ظهراً - 2 ظهراً", "displayOrder": 3},
  {"id": 4, "name": "2PM-4PM", "nameAr": "2 ظهراً - 4 عصراً", "displayOrder": 4}
]
```

**Questions:**
- Are time slots fixed or configurable per vendor?
- Any holiday/closed dates logic?
- Time zone handling - all times in Doha timezone (UTC+3)?

### Q6.3: Day of Week Convention
Mobile uses: `0=Sunday, 1=Monday, ..., 6=Saturday`

**CRITICAL VALIDATION:**
- Does backend use **same convention**?
- Or does it use: `1=Monday, 7=Sunday`?
- Or: `0=Monday, 6=Sunday`?

**Test case:** Customer selects "Tuesday" in mobile → `dayOfWeek: 2`
- Does backend interpret this as Tuesday?

### Q6.4: Reschedule Request
Mobile has "Request New Date" feature in calendar dialog.

**Q6.4.1:** Does `POST /api/v1/client/scheduled-orders/{id}/reschedule` exist?

**Expected payload:**
```json
{
  "newDate": "2026-01-15T08:00:00Z",
  "reason": "Traveling - won't be home"
}
```

**Questions:**
- Creates `SCHEDULED_ORDER_RESCHEDULE_REQUEST` record?
- Status workflow: Pending → Approved/Rejected?
- Who approves? Vendor? Auto-approved if >24h notice?
- Minimum notice period? (24h, 48h?)
- Does this reschedule only NEXT delivery or entire schedule?

**Q6.4.2:** Reschedule status tracking
- How does mobile know if request was approved?
- Is there a notification sent?
- Endpoint to check reschedule request status?

### Q6.5: Auto-Renewal Logic
Mobile UI shows: "Auto-Renewal - Automatically Purchase New Coupons When This Bundle Runs Out"

**CRITICAL QUESTIONS:**
- Is auto-renewal **implemented** in backend?
- What table/field controls it? (`SCHEDULED_ORDER.AUTO_RENEW`? `BUNDLE_PURCHASE.AUTO_RENEW`?)
- How does payment work for auto-renewal? (stored payment method? manual?)
- What happens when auto-renewal triggers?
  - Auto-purchase new bundle?
  - Charge customer's wallet?
  - Send notification first?

### Q6.6: Order Generation from Schedule
From SSoT: CRON job auto-generates `CUSTOMER_ORDER` records.

**Questions:**
- How often does CRON run? (hourly, daily at midnight?)
- Does it create orders X hours in advance?
- What happens if customer has insufficient coupons when order should generate?
  - Skip that delivery?
  - Pause schedule?
  - Notify customer?
- Link between scheduled order and generated orders:
  - Does `CUSTOMER_ORDER.SCHEDULED_ORDER_ID` field exist?
  - Can mobile fetch all orders generated from specific schedule?
  - Endpoint: `GET /api/v1/client/scheduled-orders/{id}/orders`?

### Q6.7: Coupon Assignment to Schedule
From SSoT line 626: "Coupons auto-assigned to `SCHEDULED_ORDER_ID` if subscription"

**Questions:**
- When bundle is purchased WITH schedule creation, are coupons immediately assigned?
- Or assigned as orders are generated?
- Can customer view which coupons are assigned to which schedule?
- Can customer unassign coupons from schedule?
- What if customer wants to use coupons for one-time order instead of schedule?

---

## 📋 SECTION 7: REGULAR ORDERS

### Q7.1: Order Creation
✅ **CONFIRMED WORKING:** `POST /api/v1/client/orders`

Mobile sends:
```json
{
  "items": [
    {"productId": 5, "quantity": 2, "notes": "Cold water please"}
  ],
  "deliveryAddressId": 3,
  "couponId": 10,
  "notes": "Ring doorbell",
  "terminalId": 1
}
```

**Questions:**
- Is `deliveryAddressId` **actually used** given SSoT says `CUSTOMER_ORDER` lacks this field?
- How is delivery address persisted if not in order table?
- What validates `terminalId`? How does mobile know which terminal to use?
- Can order be created without coupon? (pay with cash/card?)
- Multiple coupons per order or single coupon only?

### Q7.2: Order Status Lifecycle
**Questions:**
- What are ALL possible order status values?
  - Pending, Confirmed, Preparing, OutForDelivery, Delivered, Cancelled, Disputed?
- Status transition rules - which statuses can customer change?
- Can customer cancel after "OutForDelivery" status?
- Delivery time estimates - included in response?

### Q7.3: Order Details
✅ **CONFIRMED:** `GET /api/v1/client/orders/{id}`

**Questions:**
- Does response include delivery address details?
- Does it include delivery person info? (name, phone, photo?)
- Real-time tracking data? (GPS location of delivery person?)
- Estimated delivery time?

### Q7.4: Order Cancellation
✅ **CONFIRMED:** `POST /api/v1/client/orders/{id}/cancel`

**Questions:**
- Cancellation deadline - can cancel anytime or only before certain status?
- Refund logic:
  - If paid by coupon, does coupon return to wallet?
  - If paid by cash, does cash return to wallet?
  - Cancellation fees?
- Does cancellation create `EWALLET_TRANSACTION` record?

---

## 🚨 SECTION 8: DISPUTES SYSTEM

### Q8.1: Dispute Creation
✅ **CONFIRMED IN SWAGGER:** `POST /api/v1/client/disputes`

**Payload structure validation:**
```json
{
  "title": "Damaged bottles received",
  "claims": "3 out of 6 bottles were cracked and leaking",
  "items": [
    {"orderId": 123, "productId": 5},
    {"orderId": 123, "productId": 7}
  ],
  "documentIds": [10, 11]
}
```

**Questions:**
- Is `title` required or optional?
- Max length for `claims`? (SSoT shows `NVARCHAR(MAX)`)
- Is `documentIds` array for photos? Or general documents?
- Can dispute be created for coupon delivery (not regular order)?
- How are `orderId` and `productId` validated?

### Q8.2: Document Upload Flow
**CRITICAL QUESTION - Two possible flows:**

**Option A: Separate upload first**
1. Mobile calls `POST /api/v1/documents` with photo base64
2. Gets back `documentId`
3. Passes `documentIds` array to dispute creation

**Option B: Direct base64 in dispute payload**
1. Mobile sends photos as base64 array directly in dispute creation
2. Backend handles upload internally

**Which flow is correct?**

**If Option A:**
- Provide `POST /api/v1/documents` endpoint details
- Request/response structure
- Max file size? Supported formats? (jpg, png, pdf?)

**If Option B:**
- Update dispute creation payload structure
- Add `photos` array field

### Q8.3: Dispute Lifecycle
**Questions:**
- Status values: Open, Responded, Resolved, Rejected, Closed?
- Who can change status?
  - Customer: Create, Add Evidence
  - Vendor: Respond, Reject
  - Admin: Resolve, Close, Approve Refund
- Status transition rules?

### Q8.4: Dispute Response Structure
✅ **CONFIRMED:** `GET /api/v1/client/disputes/{id}`

**Expected response validation:**
```json
{
  "id": 1,
  "title": "...",
  "claims": "...",
  "statusId": 1,
  "statusName": "Open",
  "issueTime": "2026-01-08T10:00:00Z",
  "completedOn": null,
  "daysOpen": 2,
  "items": [
    {
      "orderId": 123,
      "productId": 5,
      "productName": "5-Gallon Water",
      "disputeId": 1
    }
  ],
  "logs": [
    {
      "id": 1,
      "actionId": 1,
      "actionName": "Dispute Created",
      "logTime": "2026-01-08T10:00:00Z",
      "notes": "Customer filed complaint",
      "isInternal": false,
      "actionByName": "John Doe"
    },
    {
      "id": 2,
      "actionId": 5,
      "actionName": "Internal Review",
      "logTime": "2026-01-08T11:00:00Z",
      "notes": "Checking with warehouse",
      "isInternal": true,
      "actionByName": "Admin User"
    }
  ],
  "files": [
    {
      "id": 10,
      "fileName": "damaged_bottle_1.jpg",
      "fileUrl": "https://...",
      "uploadedAt": "2026-01-08T10:05:00Z"
    }
  ]
}
```

**Confirm:**
- Is this the actual structure?
- Are `isInternal=true` logs hidden from customer in response?
- Or should mobile filter them?

### Q8.5: Dispute Actions
From SSoT: `DISPUTE_ACTION` table has 10 action types.

**Questions:**
- What are ALL 10 action types?
  1. Dispute Created
  2. Vendor Responded
  3. Customer Added Evidence
  4. Rejected
  5. Resolved
  6. Refund Approved
  7. Refund Processed
  8. Escalated
  9. Customer Attached Evidence (same as #3?)
  10. ?

### Q8.6: Refund Process
**Questions:**
- When dispute is resolved with refund:
  - Does it create `EWALLET_TRANSACTION` automatically?
  - Cash or coupon refund?
  - How does mobile track refund status?
- Endpoint for refund approval: `POST /api/v1/disputes/{id}/approve-refund`?
- Customer notification when refund processed?

### Q8.7: Adding Evidence After Creation
**Question:** Can customer add more evidence to existing dispute?
- Endpoint: `POST /api/v1/disputes/{id}/evidence`?
- Or only during creation?

---

## 📄 SECTION 9: DOCUMENT MANAGEMENT

### Q9.1: Document Upload
**Questions:**
- Endpoint: `POST /api/v1/documents`?
- Request format - multipart/form-data or JSON with base64?
- **Example request:**
  ```json
  {
    "fileBase64": "iVBORw0KGgoAAAANSUhEUgAA...",
    "fileName": "photo.jpg",
    "fileType": "image/jpeg",
    "documentType": "DisputeEvidence"
  }
  ```
- Max file size limit?
- Supported file types? (jpg, png, pdf, what else?)
- Response includes public URL or need to construct?

### Q9.2: Document Retrieval
- Are document URLs in response fully qualified or relative?
- **Example:** `"https://cdn.nartawi.com/documents/123.jpg"` or `"/documents/123.jpg"`?
- Any authentication required to access document URLs?
- Or public URLs with signed tokens?

### Q9.3: Document Types
**Questions:**
- What are valid `documentType` values?
  - DisputeEvidence
  - ProofOfDelivery
  - ProductImage
  - ProfileAvatar
  - Other?
- Any validation rules per document type?

---

## ⭐ SECTION 10: FAVORITES

### Q10.1: Product Favorites
✅ **CONFIRMED WORKING:** Mobile has full implementation

**Endpoints in use:**
- `GET /api/v1/client/favorites/products`
- `POST /api/v1/client/favorites/products/{productVsid}`
- `DELETE /api/v1/client/favorites/products/{productVsid}`
- `GET /api/v1/client/favorites/products/check/{productVsid}`

**Questions:**
- Any limits on favorite count per user?
- Are favorites synced across devices automatically?

### Q10.2: Vendor Favorites
✅ **CONFIRMED WORKING:** Mobile has full implementation

**Endpoints in use:**
- `GET /api/v1/client/favorites/vendors`
- `POST /api/v1/client/favorites/vendors/{vendorId}`
- `DELETE /api/v1/client/favorites/vendors/{vendorId}`

**Questions:**
- Does favoriting vendor affect search/product ranking?
- Any special offers for favorited vendors?

---

## 🔔 SECTION 11: NOTIFICATIONS

### Q11.1: Notification Listing
Mobile has notification screen UI.

**Questions:**
- Endpoint: `GET /api/v1/client/notifications`?
- Response structure:
  ```json
  [
    {
      "id": 1,
      "title": "Order Delivered",
      "message": "Your order #123 has been delivered",
      "type": "OrderUpdate",
      "isRead": false,
      "createdAt": "2026-01-08T10:00:00Z",
      "actionUrl": "/orders/123"
    }
  ]
  ```
- Is it paginated?

### Q11.2: Mark as Read
**Questions:**
- Endpoint: `PUT /api/v1/client/notifications/{id}/read`?
- Or bulk mark all as read: `POST /api/v1/client/notifications/mark-all-read`?

### Q11.3: Push Notifications
Mobile imports FCM (Firebase Cloud Messaging).

**Questions:**
- Endpoint to register device token: `POST /api/v1/client/notifications/push-tokens`?
- Request structure:
  ```json
  {
    "token": "fcm_device_token_here",
    "deviceType": "android",
    "appVersion": "1.0.2"
  }
  ```
- Endpoint to remove token on logout?

### Q11.4: Notification Types
**Questions:**
- What are ALL notification types?
  - OrderUpdate, DeliveryUpdate, DisputeUpdate, WalletUpdate, ScheduledOrderReminder?
- Which types trigger push notifications vs in-app only?

---

## ⭐ SECTION 12: REVIEWS & RATINGS

**USER CONFIRMED:** Postponed to Release 4 (future)

### Q12.1: Current Implementation Status
- **Question:** Are review endpoints live but just not used in mobile?
- Or not implemented in backend yet?

**If implemented:**
- Endpoints: `GET /api/v1/client/suppliers/{id}/reviews` ✅ **CONFIRMED IN SWAGGER**
- `POST /api/v1/client/reviews` exists?

**If not implemented:**
- Acknowledge this is future work
- Mobile will skip for now

---

## 🚚 SECTION 13: DELIVERY OPERATIONS

### Q13.1: Delivery Man Account
**Questions:**
- Do delivery personnel use same mobile app with different UI?
- Login endpoint same as customers?
- How does app detect delivery man role vs customer?

### Q13.2: Delivery Man Orders
Mobile has delivery man features implemented.

**Endpoints:**
- `GET /api/v1/delivery/orders` - Get assigned orders
- `POST /api/v1/delivery/orders/{id}/start` - Start delivery?
- `POST /api/v1/delivery/orders/{id}/complete` - Mark delivered?

**Questions:**
- What's the complete delivery workflow?
  1. Order assigned to delivery man
  2. Delivery man accepts?
  3. Delivery man starts delivery
  4. Delivery man marks as delivered + POD
  5. Customer confirms?
- Status updates at each step?

### Q13.3: QR Code Scanning
✅ **CONFIRMED:** `POST /api/v1/delivery/qr-scan`

**Questions:**
- What data is encoded in customer QR code?
  - Customer ID? Order ID? Both?
- QR scan validation logic:
  - Verify delivery man is assigned to this order?
  - Geofence validation?
  - Time window validation?

### Q13.4: Proof of Delivery Submission
✅ **CONFIRMED:** `POST /api/v1/delivery/pod`

**Request structure:**
```json
{
  "orderId": 123,
  "customerId": 456,
  "photoBase64": "...",
  "latitude": 25.276987,
  "longitude": 51.520008,
  "notes": "Left at door as requested",
  "deliveredAt": "2026-01-08T14:30:00Z"
}
```

**Questions:**
- Is geofence validation done server-side?
- What happens if POD is outside geofence? Rejected? Warning?
- Photo required or optional?
- Does this automatically mark coupons as consumed?

---

## ⚠️ SECTION 14: ERROR HANDLING & STANDARDS

### Q14.1: Error Response Format
**Question:** Standard error response structure?

**Expected:**
```json
{
  "type": "https://tools.ietf.org/html/rfc7231#section-6.5.1",
  "title": "Bad Request",
  "status": 400,
  "detail": "Validation failed",
  "errors": {
    "items": ["Product ID 999 does not exist"],
    "deliveryAddressId": ["Address not found"]
  },
  "traceId": "00-abc123..."
}
```

**Confirm:**
- Is this the format used across all endpoints?
- Or different format for different error types?

### Q14.2: Common Error Scenarios

**Q14.2.1:** Insufficient coupons for order/schedule
- HTTP Status: `400`?
- Error message format?
- Does response include: available coupons count, required count?

**Q14.2.2:** Invalid product/vendor ID
- HTTP Status: `404`?
- Or `400` with validation error?

**Q14.2.3:** Unauthorized access (wrong token)
- HTTP Status: `401`
- Does response suggest refresh token?

**Q14.2.4:** Forbidden (valid token but wrong role)
- HTTP Status: `403`
- Example: Customer trying to access vendor endpoints

**Q14.2.5:** Rate limiting
- HTTP Status: `429`
- Response includes retry-after header?

### Q14.3: Validation Rules
**Questions:**
- Are validation rules consistent across endpoints?
- **Examples:**
  - Max text length: 255 chars? 4000 chars? Varies by field?
  - Required fields clearly documented?
  - Date format: ISO 8601 (`2026-01-08T10:00:00Z`)?
  - Coordinate precision: 6 decimal places?

---

## 📊 SECTION 15: PERFORMANCE & PAGINATION

### Q15.1: Pagination Standards
**Questions:**
- Is pagination consistent across all list endpoints?
- **Format:**
  - Query params: `pageIndex` (0-based or 1-based?) and `pageSize`
  - Or: `page` and `limit`?
  - Or: `offset` and `limit`?

**Response format:**
```json
{
  "data": [...],
  "pagination": {
    "currentPage": 1,
    "pageSize": 20,
    "totalPages": 5,
    "totalCount": 87,
    "hasNextPage": true,
    "hasPreviousPage": false
  }
}
```

**Confirm:**
- Is this the structure?
- What's the default page size if not specified?
- Max page size allowed? (prevent abuse)

### Q15.2: Sorting Standards
**Questions:**
- Sort parameter naming: `sortBy` and `isDescending`?
- Or: `sort=field:desc`?
- Allowed sort fields - documented per endpoint?

### Q15.3: Rate Limiting
**Questions:**
- Are there rate limits on client endpoints?
- Limits per endpoint? Or global per user?
- **Example:** 100 requests per minute per user?
- How is mobile notified? (429 status + Retry-After header?)

### Q15.4: Caching
**Questions:**
- Should mobile cache certain responses?
  - Product catalog (15 minutes?)
  - User profile (until logout?)
  - Areas/time slots (24 hours?)
- Do responses include cache control headers?
- ETags supported for conditional requests?

---

## 🔍 SECTION 16: BUSINESS LOGIC VALIDATIONS

### Q16.1: Order vs Scheduled Order
**CRITICAL CLARIFICATION:**

Mobile has two concepts:
1. **Regular Order:** One-time purchase, immediate delivery
2. **Scheduled Order:** Recurring deliveries (subscription)

**Questions:**
- Are these **completely separate** systems?
- Or is scheduled order just a flag on regular order?
- Can scheduled order generate regular orders automatically?
- Can customer view regular orders generated from schedule?

### Q16.2: Coupon Types
From SSoT: Two coupon types:
1. **Discount coupons:** Apply discount to order
2. **Bundle coupons:** Refill coupons from bundle purchase

**Questions:**
- Can mobile differentiate between these types in coupon list?
- Does response include `couponType` field?
- Can discount coupon be used for scheduled order?
- Can bundle coupon be used for one-time order?

### Q16.3: Payment Methods
**Questions:**
- What are ALL supported payment methods?
  - Cash on delivery
  - Wallet balance
  - Coupon
  - Credit card
  - Bank transfer
- Can order use multiple payment methods? (wallet + cash?)
- Payment gateway integration - which provider?
- Is payment gateway integration done or pending?

### Q16.4: Delivery Scheduling
**Questions:**
- For regular orders, can customer choose delivery time?
- Or vendor assigns delivery time?
- Delivery time slots - same as scheduled orders?
- Same-day delivery available?
- Delivery fees - fixed or variable by distance?

### Q16.5: Vendor vs Terminal
From SSoT: Multiple vendors, each vendor has terminals.

**Questions:**
- When creating order, mobile sends `terminalId`
- How does mobile know which terminal to use?
  - Based on customer's area?
  - Based on product availability?
  - Does backend have endpoint: `GET /api/v1/terminals/nearest?lat=...&lng=...`?
- Can customer choose vendor/terminal explicitly?

---

## 📋 SECTION 17: DATA SYNCHRONIZATION

### Q17.1: Offline Support
**Questions:**
- Should mobile work offline?
- If yes, which features should cache locally?
  - Cart (already local)
  - Favorites
  - Recent orders
- Sync strategy when coming back online?

### Q17.2: Data Consistency
**Questions:**
- If customer updates address on mobile, does it reflect immediately on next order?
- If customer creates scheduled order, when does it show in list? (immediately or after CRON runs?)
- If dispute status changes, does mobile get notification or must poll?

### Q17.3: Real-Time Updates
**Questions:**
- Are there WebSocket endpoints for real-time updates?
- Or mobile should poll periodically?
- **Use cases:**
  - Order status changes
  - Dispute updates
  - Wallet balance changes
  - Delivery man location (if tracking)

---

## 🧪 SECTION 18: TESTING & ENVIRONMENTS

### Q18.1: Test Accounts
**REQUEST:** Backend team provide test accounts with:

**Customer Account:**
- Username/email and password
- Has bundle purchases
- Has active scheduled orders
- Has coupons in wallet (some used, some available, some expiring)
- Has historical regular orders
- Has at least one dispute

**Delivery Man Account:**
- Username/email and password
- Has assigned orders
- Can test POD submission
- Can test QR scanning

**Vendor Account (if mobile will support vendor features later):**
- Username/email and password

### Q18.2: Environment URLs
**Questions:**
- Production: `https://nartawi.smartvillageqatar.com/api` ✅ **CONFIRMED**
- Staging/QA environment URL?
- Development environment URL?
- Different API keys/tokens per environment?

### Q18.3: Swagger Documentation
**Questions:**
- Swagger URL: `https://nartawi.smartvillageqatar.com/swagger/index.html` ✅ **CONFIRMED**
- Is Swagger updated automatically on deploy?
- Are all endpoints documented?
- Any undocumented "internal" endpoints mobile should use?

---

## 🚀 SECTION 19: DEPLOYMENT & VERSIONING

### Q19.1: API Versioning
**Questions:**
- Current version: `/api/v1/...`
- Any plans for v2?
- Breaking changes policy - how much advance notice?
- Version negotiation - can mobile specify which version?

### Q19.2: Backward Compatibility
**Questions:**
- If backend adds optional field, will it break mobile?
- If backend removes field, will it be gradual (deprecated first)?
- Deprecation timeline - how long until removal?

### Q19.3: Mobile App Versions
**Questions:**
- Does backend track which mobile app version is calling?
- Should mobile send app version in headers?
- **Example:** `X-App-Version: 1.0.2`
- Any minimum supported app version enforced by backend?

---

## 📞 SECTION 20: CONTACT & ESCALATION

### Q20.1: API Issues
**Questions:**
- Who should mobile team contact for:
  - API bugs
  - Documentation questions
  - Performance issues
  - Schema clarifications
- Response time SLA for urgent issues?

### Q20.2: Change Requests
**Questions:**
- Process for requesting new endpoints or fields?
- Timeline for implementing new features?
- Priority system for mobile team requests?

---

## 📊 SUMMARY OF CRITICAL BLOCKERS

### 🔴 HIGH PRIORITY (Must resolve before M1.0.2):
1. **Q2.1:** Address update endpoint - field requirements
2. **Q2.4:** Order delivery address - how is it stored/used?
3. **Q8.2:** Document upload flow - Option A or B?
4. **Q3.2 & Q3.3:** Product details/specs endpoints - do they exist?
5. **Q3.4:** Bundle filter - isBundle parameter support?

### 🟡 MEDIUM PRIORITY (Must resolve before M1.0.3):
6. **Q6.1.1-6.1.4:** Scheduled orders CRUD endpoints confirmation
7. **Q6.2.1:** Time slots endpoint existence
8. **Q6.3:** Day of week convention alignment
9. **Q6.5:** Auto-renewal implementation status
10. **Q6.6:** Order generation workflow details

### 🟢 LOW PRIORITY (Nice to have clarifications):
11. **Q11:** Notifications implementation details
12. **Q13:** Delivery operations complete workflow
13. **Q15:** Performance & pagination standards
14. **Q16:** Business logic validations

---

## ✅ RESPONSE FORMAT REQUEST

Please provide responses grouped by section with this format:

```markdown
## SECTION X: [Section Name]

### QX.X: [Question]
**Answer:** [Your response]
**Endpoint:** [If applicable]
**Example Payload/Response:** [If applicable]
**Notes:** [Additional context]

---
```

---

## 📋 CHECKLIST FOR BACKEND TEAM

Before responding, please:
- [ ] Review all 20 sections
- [ ] Test endpoints mentioned to ensure they work
- [ ] Provide example requests/responses
- [ ] Clarify any ambiguous business logic
- [ ] Flag any endpoints that don't exist yet
- [ ] Provide timeline for missing endpoints
- [ ] Share test account credentials
- [ ] Confirm Swagger is up-to-date
- [ ] Note any breaking changes planned

---

## 🎯 NEXT STEPS AFTER RESPONSES

1. ✅ Mobile team updates implementation plan
2. ✅ Create detailed API integration specs
3. ✅ Begin M1.0.2 implementation (no blockers)
4. ✅ Parallel: Backend implements missing endpoints
5. ✅ Schedule weekly sync meetings
6. ✅ Set up shared Postman collection for testing

---

**Document Created By:** Mobile FE Team  
**Date:** January 8, 2026  
**Purpose:** Complete backend validation before mobile implementation  
**Expected Response Time:** 2-3 business days  
**Priority:** HIGH - Blocking mobile development

Thank you for your thorough responses! 🙏
