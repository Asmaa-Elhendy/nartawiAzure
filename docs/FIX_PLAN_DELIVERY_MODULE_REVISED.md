# 🚚 DELIVERY MODULE - REVISED FIX PLAN

**Module:** Delivery Module (Driver App)  
**Created:** January 10, 2026 12:45 AM  
**Status:** 🔴 READY FOR IMPLEMENTATION  
**Based On:** Deep investigation + User corrections + Backend API analysis

---

## 📊 EXECUTIVE SUMMARY

### **Corrected Understanding**

After deep investigation and user corrections, the actual state is:

1. ✅ **ASSIGNED_DELIVERY_MAN_ID EXISTS** in SCHEDULED_ORDER table
2. ✅ **15+ Driver Endpoints Available** (3 delivery-specific + 12 shared)
3. ❌ **"Start Delivery" Button MISSING** from UI (critical workflow gap)
4. ❌ **Timestamp Overlay MISSING** from POD photos (requirement not met)
5. ⚠️ **Driver Assignment via SCHEDULED_ORDER** (not CUSTOMER_ORDER)

### **Current State**
- **UI:** 100% Complete - All screens implemented
- **Backend Integration:** 20% - Only POD API integrated, fetchOrders commented out
- **Data:** Hardcoded in assigned orders, history, profile
- **M1.0.5 POD:** 80% - Camera works but missing timestamp overlay
- **Status Transition:** Missing "Start Delivery" button

### **Critical Blockers (5 Total)**

| # | Blocker | Severity | Can Fix Now | Backend Needed |
|---|---------|----------|-------------|----------------|
| 1 | Hardcoded orders data | 🔴 Critical | ✅ Yes | ❌ No |
| 2 | Hardcoded history data | 🔴 Critical | ❌ No | ✅ Yes |
| 3 | Profile controller commented | 🟡 High | ✅ Yes | ❌ No |
| 4 | **Start Delivery button missing** | 🔴 **CRITICAL NEW** | ✅ **Yes** | ❌ No |
| 5 | **Timestamp overlay missing** | 🔴 **CRITICAL NEW** | ✅ **Yes** | ❌ No |
| 6 | Navigation not wired | 🟡 Medium | ✅ Yes | ❌ No |

---

## 🎯 CORRECTED BUSINESS LOGIC

### **Driver Assignment Model**

```
Customer creates SCHEDULED_ORDER (Recurring subscription)
  └─ Vendor assigns ASSIGNED_DELIVERY_MAN_ID (FK to ACCOUNT)
      └─ CRON generates CUSTOMER_ORDER weekly/monthly
          └─ CUSTOMER_ORDER.SCHEDULED_ORDER_ID links back
              └─ Driver queries: JOIN to get their assigned orders
```

**Database Structure:**
```sql
SCHEDULED_ORDER
├─ ID (PK)
├─ ASSIGNED_DELIVERY_MAN_ID (FK to ACCOUNT) ✅ EXISTS
├─ DELIVERY_NOTES (nvarchar(500))
├─ VENDOR_NOTES (nvarchar(500))
├─ CRON_EXPRESSION
├─ NEXT_RUN
└─ IS_ACTIVE

CUSTOMER_ORDER
├─ ID (PK)
├─ SCHEDULED_ORDER_ID (FK to SCHEDULED_ORDER) ✅ LINK
├─ STATUS_ID (1=Pending, 2=Accepted, 3=On The Way, 4=Delivered)
└─ ISSUE_TIME
```

**Query Logic:**
```sql
-- How driver gets assigned orders:
SELECT co.* 
FROM CUSTOMER_ORDER co
INNER JOIN SCHEDULED_ORDER so ON co.SCHEDULED_ORDER_ID = so.ID
WHERE so.ASSIGNED_DELIVERY_MAN_ID = @CurrentDriverId
  AND co.STATUS_ID IN (1, 2, 3)  -- Pending, Accepted, On The Way
ORDER BY co.ISSUE_TIME DESC
```

### **Order Status Lifecycle**

```
1. Pending (1)          - Order created by CRON
   ↓
2. Accepted (2)         - Vendor confirms order
   ↓
3. On The Way (3)       - Driver starts delivery ← MISSING UI
   ↓
4. Delivered (4)        - Driver submits POD
```

**Missing UI Element:**
- **"Start Delivery" button** must change status from Pending/Accepted → On The Way
- Currently only "Mark As Delivered" appears for "On The Way" status
- No way for driver to signal delivery started

---

## 🔧 DETAILED FIX PLANS

### **FIX #1: Uncomment fetchOrders() - UNCHANGED** 🟢

**File:** `lib/features/Delivery_Man/orders/presentation/screens/assigned_orders_screen.dart`

**Issue:** API call commented out, using hardcoded data

**Implementation:** Same as previous plan
- Uncomment lines 62-68
- Wire `ordersController.fetchOrders()` 
- Add tab filtering with statusId parameter
- Use real data instead of hardcoded orders

**Endpoint:** `GET /api/v1/delivery/orders` or `GET /api/v1/client/orders`

**Query Modification Needed:**
```dart
// Backend should filter by:
// JOIN SCHEDULED_ORDER WHERE ASSIGNED_DELIVERY_MAN_ID = current_user_id
```

**Effort:** 30 minutes  
**Status:** ✅ Can implement immediately

---

### **FIX #2: History - Requires Backend** 🔴

**File:** `lib/features/Delivery_Man/history/presentation/screens/history_delivery.dart`

**Issue:** Uses hardcoded `WalletTransaction` data, no backend endpoint exists

**Backend Required:**
```
GET /api/v1/delivery/history
OR
GET /api/v1/delivery/orders?status=delivered&sort=desc
```

**Response Schema:**
```json
{
  "items": [
    {
      "orderId": 185,
      "deliveredAt": "2026-01-09T14:30:00Z",
      "customerName": "Ahmed Mohammed",
      "address": "Zone 52, Building 45",
      "amountCollected": 55.00,
      "items": [...]
    }
  ],
  "pagination": {...}
}
```

**Temporary Solution:** Show "Coming Soon" message

**Effort:** 15 min (mobile) + Backend team  
**Status:** ⚠️ Backend dependency

---

### **FIX #3: Uncomment ProfileController - UNCHANGED** 🟢

**File:** `lib/features/Delivery_Man/profile/presentation/screens/delivery_profile.dart`

**Issue:** Controller completely commented out, shows hardcoded name/phone

**Implementation:** Same as previous plan
- Uncomment `ProfileController`
- Use `GET /api/v1/client/account` endpoint
- Display real driver name and mobile
- Wire refresh and edit profile navigation

**Effort:** 30 minutes  
**Status:** ✅ Can implement immediately

---

### **FIX #4: Add "Start Delivery" Button** 🆕 🔴 CRITICAL

**File:** `lib/features/Delivery_Man/orders/presentation/widgets/order_card_delivery.dart`

**Issue:** Missing UI to transition order status from Pending/Accepted → On The Way

**Current Code (Line 163-209):**
```dart
Widget BuildOrderButtonsDelivery(
    BuildContext context,
    double screenWidth,
    double screenHeight,
    String orderStatus,
    String paymentStatus,
    ClientOrder? clientOrder,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      // View Details button (always shown)
      Expanded(
        child: InkWell(
          onTap: () { Navigator.push(...OrderDetailScreen...) },
          child: CustomGradientButton('View Details', ...),
        ),
      ),

      // Mark As Delivered (only for "On The Way")
      orderStatus == 'On The Way'
          ? Expanded(
              child: InkWell(
                onTap: () { showDialog(CancelAlertDialog) },
                child: BuildOutlinedIconButton('Mark As Delivered', ...),
              ),
            )
          : SizedBox(),
    ],
  );
}
```

**FIXED CODE:**
```dart
Widget BuildOrderButtonsDelivery(
    BuildContext context,
    double screenWidth,
    double screenHeight,
    String orderStatus,
    String paymentStatus,
    ClientOrder? clientOrder,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      // View Details button (always shown)
      Expanded(
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderDetailScreen(
                  orderStatus: orderStatus,
                  paymentStatus: paymentStatus,
                  clientOrder: clientOrder!,
                  fromDeliveryMan: true,
                ),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsetsGeometry.only(right: screenWidth * .01),
            child: CustomGradientButton(
              'assets/images/orders/hugeicons_view.svg',
              screenWidth * .015,
              'View Details',
              screenWidth,
              screenHeight,
            ),
          ),
        ),
      ),

      // ✅ NEW: Start Delivery button (for Pending/Accepted orders)
      (orderStatus == 'Pending' || orderStatus == 'Accepted')
          ? Expanded(
              child: InkWell(
                onTap: () async {
                  // Show confirmation dialog
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('Start Delivery'),
                      content: Text(
                        'Are you ready to start delivery for Order #${clientOrder!.id}?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: Text('Start'),
                        ),
                      ],
                    ),
                  );

                  if (confirmed == true && clientOrder != null) {
                    await _startDelivery(context, clientOrder.id);
                  }
                },
                child: BuildOutlinedIconButton(
                  screenWidth,
                  screenHeight,
                  'Start Delivery',
                  () {},
                  fromDelivery: true,
                ),
              ),
            )
          : SizedBox(),

      // Mark As Delivered button (for "On The Way" status)
      orderStatus == 'On The Way'
          ? Expanded(
              child: InkWell(
                onTap: () {
                  // Navigate to track order screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TrackOrderScreen(
                        order: clientOrder!,
                      ),
                    ),
                  );
                },
                child: BuildOutlinedIconButton(
                  screenWidth,
                  screenHeight,
                  'Track & Deliver',
                  () {},
                  fromDelivery: true,
                ),
              ),
            )
          : SizedBox(),
    ],
  );
}

// ✅ ADD: Function to call status change API
Future<void> _startDelivery(BuildContext context, int orderId) async {
  try {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(child: CircularProgressIndicator()),
    );

    final token = await AuthService.getToken();
    final dio = Dio();

    // Call API to change status
    final response = await dio.post(
      'https://nartawi.smartvillageqatar.com/api/v1/client/orders/$orderId/ChangeStatus',
      data: {
        'statusId': 3,  // 3 = "Out for Delivery" / "On The Way"
        'notes': 'Driver started delivery',
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );

    // Close loading
    Navigator.pop(context);

    if (response.statusCode == 200 || response.statusCode == 204) {
      // Success
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Delivery started successfully'),
          backgroundColor: Colors.green,
        ),
      );

      // Refresh orders list
      // (trigger parent widget refresh)
    } else {
      throw Exception('Failed to start delivery');
    }
  } catch (e) {
    // Close loading if still open
    Navigator.pop(context);

    // Show error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to start delivery: $e'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
```

**Additional Required Imports:**
```dart
import 'package:dio/dio.dart';
import '../../../../core/services/auth_service.dart';
```

**API Endpoint:**
```
POST /api/v1/client/orders/{id}/ChangeStatus
Body: { "statusId": 3, "notes": "Driver started delivery" }
```

**Button Logic:**
- **Pending/Accepted orders:** Show "Start Delivery" button
- **On The Way orders:** Show "Track & Deliver" button
- **Delivered/Canceled:** Show nothing (only View Details)

**Effort:** 1.5 hours  
**Status:** 🔴 CRITICAL - Must implement

---

### **FIX #5: Add Timestamp Overlay to POD Photo** 🆕 🔴 CRITICAL

**File:** `lib/features/Delivery_Man/orders/presentation/screens/delivery_confirmation_screen.dart`

**Issue:** Photo captured from camera but NO timestamp overlay added to image

**Requirement:** Photo must show visible timestamp (date + time) when it was taken

**Step 1: Add Package to pubspec.yaml**
```yaml
dependencies:
  image: ^4.1.7  # For image manipulation and text overlay
```

**Step 2: Import Required Packages**
```dart
import 'package:image/image.dart' as img;
import 'dart:typed_data';
```

**Step 3: Add Timestamp Overlay Function**
```dart
/// Adds timestamp overlay to captured photo
/// Returns modified image bytes with timestamp burned into the image
Future<Uint8List> _addTimestampOverlay(Uint8List photoBytes) async {
  try {
    // Decode image
    img.Image? image = img.decodeImage(photoBytes);
    if (image == null) return photoBytes;

    // Get current timestamp
    final now = DateTime.now();
    final timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    final locationText = 'GPS: ${_currentPosition?.latitude.toStringAsFixed(6)}, ${_currentPosition?.longitude.toStringAsFixed(6)}';

    // Define text position (bottom of image)
    final textPadding = 20;
    final textY = image.height - 100;
    final bgHeight = 90;

    // Draw semi-transparent black background for text
    img.fillRect(
      image,
      x: 0,
      y: textY - 10,
      width: image.width,
      height: bgHeight,
      color: img.ColorRgba8(0, 0, 0, 200),  // Black with 200/255 opacity
    );

    // Draw timestamp text (white, centered-left)
    img.drawString(
      image,
      '📅 $timestamp',
      font: img.arial48,
      x: textPadding,
      y: textY,
      color: img.ColorRgba8(255, 255, 255, 255),  // White
    );

    // Draw location text below timestamp
    img.drawString(
      image,
      '📍 $locationText',
      font: img.arial24,
      x: textPadding,
      y: textY + 50,
      color: img.ColorRgba8(255, 255, 255, 255),  // White
    );

    // Encode back to JPEG
    final modifiedBytes = img.encodeJpg(image, quality: 85);
    return Uint8List.fromList(modifiedBytes);
  } catch (e) {
    print('Failed to add timestamp overlay: $e');
    // Return original if overlay fails
    return photoBytes;
  }
}
```

**Step 4: Modify _submitPOD Function**
```dart
Future<void> _submitPOD(XFile photo) async {
  setState(() => _isSubmitting = true);

  try {
    // Read original photo bytes
    final originalBytes = await photo.readAsBytes();
    
    // ✅ ADD TIMESTAMP OVERLAY TO PHOTO
    final timestampedBytes = await _addTimestampOverlay(originalBytes);
    
    // Encode to base64
    final base64Photo = base64Encode(timestampedBytes);

    // Submit to backend
    await _podDatasource.submitPOD(
      orderId: widget.orderId,
      photoBase64: base64Photo,
      latitude: _currentPosition!.latitude,
      longitude: _currentPosition!.longitude,
      notes: _commentCtrl.text.trim().isEmpty ? null : _commentCtrl.text.trim(),
    );

    setState(() => _isSubmitting = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Delivery confirmed successfully'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context, true);
  } catch (e) {
    setState(() => _isSubmitting = false);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to submit POD: $e'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
```

**Timestamp Format:**
```
📅 2026-01-10 01:15:30
📍 GPS: 25.276987, 51.520008
```

**Visual Result:**
```
┌─────────────────────────────────┐
│                                 │
│    [Delivered bottles photo]   │
│                                 │
│                                 │
├─────────────────────────────────┤
│ ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ │ ← Black semi-transparent background
│ 📅 2026-01-10 01:15:30         │ ← White timestamp
│ 📍 GPS: 25.276987, 51.520008   │ ← White GPS coordinates
└─────────────────────────────────┘
```

**Effort:** 2 hours  
**Status:** 🔴 CRITICAL - Must implement

---

### **FIX #6: Wire Navigation Button - UNCHANGED** 🟢

**File:** `lib/features/Delivery_Man/orders/presentation/screens/track_order.dart`

**Issue:** "Open Google Map" button has empty handler

**Implementation:** Same as previous plan
- Add `url_launcher` package
- Wire button to open Google Maps with customer address
- Pass order data to TrackOrderScreen

**Effort:** 1 hour  
**Status:** ✅ Can implement immediately

---

## 📊 IMPLEMENTATION PRIORITY

### **PHASE 1: CRITICAL FIXES (Day 1)** - 5 hours

Priority order based on criticality:

1. **FIX #5:** Add timestamp overlay to POD photos - **2 hours** 🔴
   - **MOST CRITICAL** - Business requirement not met
   - Photo evidence must show when it was taken
   - Without this, POD is not legally valid

2. **FIX #4:** Add "Start Delivery" button - **1.5 hours** 🔴
   - **CRITICAL** - Workflow broken without this
   - Drivers cannot signal delivery started
   - Orders stuck in Pending/Accepted status

3. **FIX #1:** Uncomment fetchOrders() - **30 min** 🟢
   - Wire real data from backend
   - Enable tab filtering by status

4. **FIX #3:** Uncomment ProfileController - **30 min** 🟢
   - Load driver profile from API
   - Show real name and phone

5. **FIX #6:** Wire navigation button - **30 min** 🟢
   - Open Google Maps for directions

**Expected Result After Phase 1:**
- Module goes from 65% → 95%
- All critical POD requirements met
- Complete delivery workflow functional
- Real data integrated

### **PHASE 2: BACKEND COORDINATION (Week 2)** - Backend team

1. **Create delivery history endpoint:**
   ```
   GET /api/v1/delivery/history
   OR
   GET /api/v1/delivery/orders?status=delivered&includeEarnings=true
   ```

2. **Optimize driver order filtering:**
   - Ensure `GET /api/v1/delivery/orders` filters by ASSIGNED_DELIVERY_MAN_ID
   - Join SCHEDULED_ORDER to CUSTOMER_ORDER
   - Return only assigned orders

**Expected Result After Phase 2:**
- Module goes from 95% → 100%
- Full feature parity with designs
- Production-ready

---

## 🧪 TESTING CHECKLIST

### **After Phase 1:**

**POD Timestamp (FIX #5):**
- [ ] Capture photo shows timestamp overlay
- [ ] Timestamp format is readable: "YYYY-MM-DD HH:MM:SS"
- [ ] GPS coordinates visible below timestamp
- [ ] Black background makes text readable
- [ ] Timestamp matches actual capture time
- [ ] Photo quality remains good after overlay

**Start Delivery (FIX #4):**
- [ ] "Start Delivery" button appears for Pending orders
- [ ] "Start Delivery" button appears for Accepted orders
- [ ] Button does NOT appear for On The Way orders
- [ ] Button does NOT appear for Delivered orders
- [ ] Tapping button shows confirmation dialog
- [ ] Confirming calls API and changes status
- [ ] Status updates to "On The Way" (ID: 3)
- [ ] "Track & Deliver" button appears after start
- [ ] Error message shows if API fails

**Assigned Orders (FIX #1):**
- [ ] Orders load from backend on app open
- [ ] Tab filtering works (All, Pending, On The Way, etc.)
- [ ] Pull to refresh reloads orders
- [ ] Empty state shows if no orders
- [ ] Loading indicator appears
- [ ] Only assigned orders shown (via SCHEDULED_ORDER link)

**Profile (FIX #3):**
- [ ] Driver name loads from backend
- [ ] Driver phone loads from backend
- [ ] Refresh works
- [ ] Edit profile navigates correctly

**Navigation (FIX #6):**
- [ ] "Open Google Map" button works
- [ ] Google Maps opens with customer address
- [ ] Destination is correct

---

## 📋 FILES TO MODIFY

### **Phase 1 - Critical Fixes:**

1. **delivery_confirmation_screen.dart** (FIX #5 - Timestamp)
   - Add `image` package import
   - Add `_addTimestampOverlay()` function
   - Modify `_submitPOD()` to call overlay function
   - Test timestamp display

2. **order_card_delivery.dart** (FIX #4 - Start Delivery)
   - Add `_startDelivery()` function
   - Modify `BuildOrderButtonsDelivery()` widget
   - Add status-based button logic
   - Add confirmation dialog

3. **assigned_orders_screen.dart** (FIX #1 - Fetch Orders)
   - Uncomment `fetchOrders()` call
   - Add tab filtering logic
   - Use real data instead of hardcoded

4. **delivery_profile.dart** (FIX #3 - Profile)
   - Uncomment `ProfileController`
   - Wire refresh logic
   - Use real profile data

5. **track_order.dart** (FIX #6 - Navigation)
   - Add `url_launcher` import
   - Wire Google Maps button
   - Pass order data

6. **pubspec.yaml**
   - Add `image: ^4.1.7`
   - Add `url_launcher: ^6.2.0`

---

## 🎯 SUCCESS CRITERIA

### **Phase 1 Complete When:**
- ✅ POD photos show timestamp overlay (date + time + GPS)
- ✅ "Start Delivery" button visible for Pending/Accepted orders
- ✅ Status changes to "On The Way" when button tapped
- ✅ Driver can see real assigned orders from backend
- ✅ Driver profile loads real name and phone
- ✅ Navigation to Google Maps works
- ✅ Complete delivery workflow functional end-to-end
- ✅ Module score improves to 95%

### **Phase 2 Complete When:**
- ✅ Delivery history shows real completed deliveries
- ✅ Backend filters orders by ASSIGNED_DELIVERY_MAN_ID
- ✅ Module score reaches 100%

---

## 🚨 CRITICAL NOTES

### **1. Timestamp Overlay is NON-NEGOTIABLE**
- Business requirement: Photo MUST show when it was taken
- Legal requirement: Proof of delivery needs verifiable timestamp
- Current implementation: ❌ Timestamp only in database, NOT in photo
- **Must be fixed before any POD submissions**

### **2. Start Delivery is Workflow Blocker**
- Orders cannot transition from Pending → On The Way → Delivered
- Drivers have no way to signal "I started this delivery"
- "Mark As Delivered" only shows for "On The Way" status
- **Workflow is broken without this button**

### **3. Driver Assignment via SCHEDULED_ORDER**
- Drivers assigned to recurring schedules, NOT individual orders
- Link: SCHEDULED_ORDER.ASSIGNED_DELIVERY_MAN_ID → ACCOUNT
- CUSTOMER_ORDER.SCHEDULED_ORDER_ID links to schedule
- **Query must JOIN these tables to get driver's orders**

### **4. Testing Requirements**
- Test POD with timestamp on REAL device (not emulator)
- Verify timestamp is readable in different lighting
- Verify GPS coordinates are accurate
- Test "Start Delivery" changes order status in database
- Verify backend filters orders correctly by driver

---

**Plan Status:** 🟢 READY FOR IMPLEMENTATION  
**Estimated Time:** Phase 1: 5 hours | Phase 2: Backend team  
**Expected Module Score After Fixes:** 95% (Phase 1) → 100% (Phase 2)  
**Critical Priority:** FIX #5 (Timestamp) and FIX #4 (Start Delivery)

---

**Next Steps:**
1. Get approval for this revised plan
2. Add `image` package to pubspec.yaml
3. Implement timestamp overlay (FIX #5)
4. Implement Start Delivery button (FIX #4)
5. Implement remaining fixes (FIX #1, #3, #6)
6. Test complete delivery workflow
7. Coordinate with backend for Phase 2
