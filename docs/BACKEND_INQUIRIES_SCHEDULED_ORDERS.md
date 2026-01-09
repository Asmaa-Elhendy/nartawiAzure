# Backend API Inquiries - Scheduled Orders & Integration

**Date:** January 8, 2026  
**Purpose:** Validate existing backend implementation and clarify integration requirements for Mobile FE  
**Context:** Backend team confirmed scheduled orders are running in production. Mobile FE has UI but no API integration.

---

## 🔍 SECTION 1: SCHEDULED ORDERS - ENDPOINT VERIFICATION

### 1.1 Client Endpoints (Customer-Facing)

**Q1:** Does `POST /api/v1/client/scheduled-orders` exist?
- **Mobile needs:** Create new recurring delivery schedule
- **Expected payload:** 
  ```json
  {
    "title": "Weekly Water Delivery",
    "items": [{"productVsid": 1, "quantity": 2}],
    "dayTimes": [
      {"dayOfWeek": 0, "timeSlotId": 1},
      {"dayOfWeek": 2, "timeSlotId": 1}
    ]
  }
  ```
- **Question:** What's the exact payload structure? Any required fields we're missing?

**Q2:** Does `GET /api/v1/client/scheduled-orders` exist?
- **Mobile needs:** List all customer's active subscriptions
- **Expected response:** Paginated list with status, next delivery date
- **Question:** What filters are available (status, active/inactive)?

**Q3:** Does `PUT /api/v1/client/scheduled-orders/{id}` exist?
- **Mobile needs:** Update preferences (frequency, bottles per delivery, delivery days)
- **Expected fields:** dayTimes[], items[], isActive
- **Question:** Can customers edit all fields or only specific ones?

**Q4:** Does `POST /api/v1/client/scheduled-orders/{id}/reschedule` exist?
- **Mobile needs:** Request one-time date change for next delivery
- **Expected payload:** `{"newDate": "2026-01-15", "reason": "Traveling"}`
- **Question:** Does this require vendor approval? What's the workflow?

**Q5:** Does `DELETE /api/v1/client/scheduled-orders/{id}` or `/cancel` exist?
- **Mobile needs:** Cancel subscription
- **Question:** Hard delete or soft delete (is_active = false)?

---

## 🔍 SECTION 2: DATA STRUCTURE VALIDATION

### 2.1 SCHEDULED_ORDER Table

From SSoT (`SINGLE_SOURCE_OF_TRUTH.md:1949-2073`), we understand:
- `TITLE`, `CRON_EXPRESSION`, `LAST_RUN`, `NEXT_RUN`, `IS_ACTIVE`
- Links to `BUNDLE_PURCHASE_ID`, `ACCOUNT_ID`, `TERMINAL_ID`

**Q6:** When customer creates scheduled order, does backend:
- ✅ Auto-generate `CRON_EXPRESSION` from `dayTimes[]`?
- ✅ Calculate `NEXT_RUN` automatically?
- ✅ Assign coupons from `COUPONS_BALANCE` immediately or on first run?

**Q7:** What's returned in `GET /api/v1/client/scheduled-orders` response?
```json
{
  "data": [
    {
      "id": 1,
      "title": "Weekly Water",
      "nextRun": "2026-01-12T08:00:00Z",
      "lastRun": "2026-01-05T08:00:00Z",
      "isActive": true,
      "items": [...],
      "dayTimes": [...],
      "remainingCoupons": 20  // ← Do you include this?
    }
  ]
}
```

### 2.2 SCHEDULED_ORDER_DAY_TIME Table

**Q8:** Structure validation:
- Mobile sends: `[{"dayOfWeek": 0, "timeSlotId": 1}]` (0=Sunday)
- Does backend expect: `dayOfWeek` as 0-6 or 1-7?
- What are valid `timeSlotId` values? (1-4 for morning/afternoon/evening/night?)

**Q9:** Do you have `GET /api/v1/time-slots` endpoint?
- Mobile needs: List available delivery time slots
- Expected: `[{"id": 1, "name": "8AM-10AM", "displayOrder": 1}]`

### 2.3 SCHEDULED_ORDER_RESCHEDULE_REQUEST Table

**Q10:** Reschedule workflow:
- Customer submits request via `POST /scheduled-orders/{id}/reschedule`
- Does it create `SCHEDULED_ORDER_RESCHEDULE_REQUEST` record with `STATUS = 'Pending'`?
- Who approves? Vendor or auto-approved if within X days notice?
- Does mobile get notification when approved/rejected?

---

## 🔍 SECTION 3: BUSINESS LOGIC CLARIFICATIONS

### 3.1 Coupon Assignment

**Q11:** When scheduled order is created:
- Mobile UI shows: "Select products from available coupons in wallet"
- Question: Does `POST /scheduled-orders` verify customer has enough coupons?
- Question: Are coupons immediately linked to `SCHEDULED_ORDER_ID` or only when order is generated?

From SSoT line 626:
> "Coupons auto-assigned to `SCHEDULED_ORDER_ID` if subscription"

**Q12:** Can customers create scheduled order WITHOUT bundle purchase first?
- Or must they: Buy bundle → Get coupons → Create schedule?

### 3.2 Auto-Renewal Logic

Mobile UI shows toggle: "Auto-Renewal - Automatically Purchase New Coupons When This Bundle Runs Out"

**Q13:** Is auto-renewal implemented in backend?
- If yes, what field controls it? `BUNDLE_PURCHASE.AUTO_RENEW`?
- Does it auto-purchase new bundle when `COUPONS_BALANCE.REMAINING = 0`?
- How is payment handled for auto-renewal?

### 3.3 Order Generation from Schedule

**Q14:** CRON job or scheduled task:
- How often does it run? (Hourly? Daily at midnight?)
- Does it create `CUSTOMER_ORDER` records automatically?
- What happens if customer has no coupons left when order should generate?

From SSoT line 700-702:
> "`SCHEDULED_ORDER_ID` for auto-generated orders"

**Q15:** When auto-generated order is created:
- Does it link to `SCHEDULED_ORDER.ID` via `CUSTOMER_ORDER.SCHEDULED_ORDER_ID`?
- Does it consume coupons from `COUPONS_BALANCE` (marks them as CONSUMED)?
- Is delivery address pulled from scheduled order preferences or customer's default address?

---

## 🔍 SECTION 4: MISSING ENDPOINTS CHECK

### 4.1 Address Management

**Q16:** `PUT /api/v1/client/account/addresses/{id}` - CONFIRMED it exists (Swagger position 12)
- Question: Can we get example request/response payload?
- Question: Which fields are required vs optional?

Expected payload:
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
  "notes": "Ring doorbell twice"
}
```

### 4.2 Product Details & Specifications

**Q17:** Do these endpoints exist?
- `GET /api/v1/client/products/{vsId}/details`
- `GET /api/v1/client/products/{vsId}/specifications`

From SSoT lines 1766-1844, tables exist:
- `PRODUCT_DETAILS` (brand, description, internal_code)
- `PRODUCT_SPECIFICATION` (spec_name, spec_value, unit)

Question: Are these exposed via API or still backend-only?

### 4.3 Bundle Products Filter

**Q18:** Does `GET /api/v1/client/products` support `isBundle=true` filter?
- Current mobile uses: `/products?searchTerm=...&categoryId=...`
- Need: `/products?isBundle=true` to show only bundles
- Question: Is this parameter already supported or need to add?

---

## 🔍 SECTION 5: DISPUTES INTEGRATION

**Q19:** Disputes endpoints - CONFIRMED they exist (Swagger positions 45-46):
- `GET /api/v1/client/disputes`
- `POST /api/v1/client/disputes`
- `GET /api/v1/client/disputes/{id}`

**CREATE DISPUTE - Payload Validation:**
```json
{
  "title": "Damaged bottles received",
  "claims": "3 out of 6 bottles were cracked",
  "items": [
    {"orderId": 123, "productId": 5}
  ],
  "documentIds": [10, 11]  // ← Photo uploads
}
```

**Q20:** Document upload flow:
- Does mobile first upload photos via `POST /api/v1/documents`?
- Then pass document IDs to `POST /api/v1/client/disputes`?
- Or can we send base64 photos directly in dispute payload?

**Q21:** Dispute response structure:
```json
{
  "id": 1,
  "title": "...",
  "claims": "...",
  "statusId": 1,
  "statusName": "Open",
  "issueTime": "...",
  "items": [...],
  "logs": [
    {
      "id": 1,
      "actionId": 1,
      "actionName": "Dispute Created",
      "logTime": "...",
      "notes": "...",
      "isInternal": false
    }
  ],
  "files": [...]
}
```

Question: Is this the actual response structure?

---

## 🔍 SECTION 6: SWAGGER vs SSoT ALIGNMENT

**Q22:** Swagger Documentation:
- Live Swagger: `https://nartawi.smartvillageqatar.com/swagger/index.html`
- Question: Is Swagger up-to-date with all production endpoints?
- Question: Are there endpoints in production NOT documented in Swagger?

**Q23:** SSoT References:
- From `SINGLE_SOURCE_OF_TRUTH.md` (67 tables, controllers documented)
- Question: Should mobile team reference SSoT or Swagger as primary source?
- Question: If they conflict, which takes precedence?

---

## 🔍 SECTION 7: MOBILE-SPECIFIC REQUIREMENTS

### 7.1 Calendar & Time Slots

**Q24:** Mobile UI shows calendar with:
- "Weekly Delivery Frequency" (1-7 days per week)
- "Preferred Refill Times /Week" - day selection grid (Sun-Sat)
- "Next Refill" date picker

Question: How should mobile calculate `CRON_EXPRESSION` or does backend handle it?

Example mobile state:
- User selects: Sunday, Tuesday, Thursday (3 days/week)
- User selects time slot: "8AM-10AM" (timeSlotId: 1)
- Backend generates: `CRON_EXPRESSION = "0 8 * * 0,2,4"` ?

**Q25:** "Request New Date" flow:
- User wants to reschedule ONLY next delivery (one-time change)
- Should mobile call: `POST /scheduled-orders/{id}/reschedule`
- Or update main schedule: `PUT /scheduled-orders/{id}` with temp date override?

### 7.2 Consumption Tracking

Mobile shows: "View Last Consumption" - displays coupons marked as used in last delivery

**Q26:** How does mobile know which coupons were in "last delivery"?
- Current logic (`@coupon_controller.dart:211`): Groups by delivery day/hour
- Question: Does `COUPONS_BALANCE.MARKED_USED_AT` accurately reflect delivery batches?
- Question: Should we use `CUSTOMER_ORDER.ISSUE_TIME` instead to group coupons?

### 7.3 Proof of Delivery

**Q27:** Mobile displays POD with:
- GPS location
- Photo URL
- Geofence validation result
- Delivery timestamp

Question: Is `proofOfDelivery` object included in coupon response?
```json
{
  "couponId": 1,
  "proofOfDelivery": {
    "photoUrl": "...",
    "location": "25.276987, 51.520008",
    "isWithinGeofence": true,
    "deliveredAt": "..."
  }
}
```

---

## 🔍 SECTION 8: INTEGRATION TESTING REQUIREMENTS

**Q28:** Test accounts:
- Can backend team provide test customer accounts with:
  - ✅ Active bundle purchases
  - ✅ Existing scheduled orders
  - ✅ Available coupons in wallet
  - ✅ Historical disputes
  
- Credentials needed for QA environment testing

**Q29:** Rate limiting & pagination:
- Are there rate limits on client endpoints?
- Default page size for paginated endpoints?
- Max page size allowed?

---

## 🔍 SECTION 9: DEPLOYMENT & VERSIONING

**Q30:** API Versioning:
- Current: `/api/v1/...`
- Question: Are any scheduled order endpoints in v2 or newer?
- Question: Do we need to handle multiple API versions in mobile?

**Q31:** Breaking changes:
- Are there any planned breaking changes to scheduled orders API in next 3 months?
- Should mobile prepare for backwards compatibility?

---

## 🔍 SECTION 10: ERROR HANDLING

**Q32:** Common error scenarios for scheduled orders:

**Scenario 1:** Customer tries to create schedule with insufficient coupons
- Expected response: `400 Bad Request` with error message?
- Should mobile prevent submission or rely on backend validation?

**Scenario 2:** Customer tries to reschedule with less than 24h notice
- Expected response: `400 Bad Request` - "Minimum 24h notice required"?
- Is there a minimum notice period?

**Scenario 3:** Scheduled order conflicts with existing schedule
- Can customer have multiple active scheduled orders?
- Or only one schedule per bundle purchase?

**Q33:** Error response format:
```json
{
  "type": "https://tools.ietf.org/html/rfc7231#section-6.5.1",
  "title": "Bad Request",
  "status": 400,
  "detail": "Insufficient coupons for scheduled order",
  "errors": {
    "items": ["Not enough coupons for product VSID 5"]
  }
}
```

Question: Is this the standard error format across all endpoints?

---

## 📋 SUMMARY OF CRITICAL QUESTIONS

### HIGH PRIORITY (Blocking Mobile Development):
1. **Q1-Q5:** Confirm exact scheduled orders CRUD endpoints
2. **Q8-Q9:** Time slot structure and available time slots API
3. **Q11-Q12:** Coupon assignment logic and requirements
4. **Q17-Q18:** Product details/specs endpoints and bundle filter
5. **Q20:** Document upload flow for disputes

### MEDIUM PRIORITY (Needed for Full Feature):
6. **Q13:** Auto-renewal implementation status
7. **Q15:** Order generation and coupon consumption flow
8. **Q24-Q25:** Calendar integration and reschedule workflow
9. **Q28:** Test accounts for QA

### LOW PRIORITY (Nice to Have):
10. **Q22-Q23:** Documentation alignment
11. **Q30-Q31:** Versioning and future changes
12. **Q32-Q33:** Error handling details

---

## 📬 RESPONSE FORMAT REQUEST

Please provide responses in this format:

```
**Q[Number]: [Question Title]**
Answer: [Your response]
Endpoint: [If applicable: GET /api/v1/... with example]
Example Payload: [If applicable]
Notes: [Any additional context]
```

This will help us document and implement efficiently.

---

**Next Steps:**
1. Backend team reviews and answers questions
2. Mobile team creates implementation plan based on answers
3. Schedule alignment meeting if any conflicts found
4. Begin M1.0.2 implementation

Thank you! 🙏
