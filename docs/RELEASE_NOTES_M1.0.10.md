# 🚀 Release Notes - M1.0.10

**Release Date:** January 14, 2026  
**Type:** Bug Fixes & API Alignment  
**Priority:** High  
**Status:** ✅ Ready for Testing

---

## 📋 Executive Summary

This release addresses critical build errors and API alignment issues identified after the Delivery Login implementation (M1.0.9). All fixes focus on backend integration, maintaining the signed-off UI designs without modifications.

**Scope:**
- 6 syntax errors fixed across 4 files
- Role-based API endpoint implementation for Orders
- Delivery API alignment and response normalization
- OTP purpose correction for password reset
- Delivery profile endpoint specification for backend team

---

## 🐛 Bug Fixes

### **1. Syntax Error: OrdersQuery Parameter Usage**
**Issue:** Incorrect parameter passing in `history_delivery.dart`  
**Files:** `lib/features/Delivery_Man/history/presentation/screens/history_delivery.dart`

**Before:**
```dart
ordersController.fetchOrders(statusId: 4, executeClear: true);
```

**After:**
```dart
ordersController.fetchOrders(
  query: OrdersQuery(statusId: 4),
  executeClear: true,
);
```

**Locations Fixed:** Lines 45-48, 304-307, 338-341

---

### **2. Syntax Error: Missing ReviewAlertDialog Parameters**
**Issue:** Required constructor parameters not passed  
**Files:** `lib/features/orders/presentation/pages/order_details.dart`

**Before:**
```dart
ReviewAlertDialog()
```

**After:**
```dart
ReviewAlertDialog(
  orderId: widget.clientOrder.id ?? 0,
  supplierId: widget.clientOrder.supplierId ?? 0,
  supplierName: widget.clientOrder.supplierName ?? 'Unknown',
)
```

**Location:** Lines 470-474

---

### **3. Type Error: EdgeInsetsGeometry Usage**
**Issue:** Using abstract class instead of concrete class  
**Files:** `lib/features/orders/presentation/widgets/orders_buttons.dart`

**Error:**
```
_TypeError: type '_Map<String, dynamic>' is not a subtype of type 'String'
```

**Root Cause:** `EdgeInsetsGeometry` (abstract) used instead of `EdgeInsets` (concrete)

**Fixed:** Lines 28-30
```dart
// Before: EdgeInsetsGeometry.only / EdgeInsetsGeometry.symmetric
// After: EdgeInsets.only / EdgeInsets.symmetric
```

---

### **4. OTP Purpose Error**
**Issue:** Invalid OTP purpose causing 400 Bad Request  
**Files:** `lib/features/auth/presentation/bloc/login_event.dart`

**Before:**
```dart
SendOtp({
  required this.email,
  this.purpose = "Auth",  // ❌ Invalid
});
```

**After:**
```dart
SendOtp({
  required this.email,
  this.purpose = "reset_password",  // ✅ Valid
});
```

**Valid Purposes:** `login`, `register`, `reset_password`

**Location:** Line 48

---

## 🔧 Feature Enhancements

### **5. Role-Based API Endpoints (Option B Implementation)**

**Issue:** Delivery users receiving 403 Forbidden when accessing orders

**Solution:** Modified existing `OrdersController` for role-based endpoint selection

**Files:** `lib/features/orders/presentation/provider/order_controller.dart`

#### Changes:

**1. Added Role Parameter:**
```dart
class OrdersController extends ChangeNotifier {
  final Dio dio;
  final String? userRole; // 'Delivery' or null/other for client

  OrdersController({required this.dio, this.userRole});
}
```

**2. Dynamic Endpoint Selection:**
```dart
String get _ordersEndpoint {
  if (userRole == 'Delivery') {
    return '$base_url/v1/delivery/orders';
  }
  return '$base_url/v1/client/orders';
}
```

**3. Updated Delivery Screens:**
- `lib/features/Delivery_Man/orders/presentation/screens/assigned_orders_screen.dart:62`
- `lib/features/Delivery_Man/history/presentation/screens/history_delivery.dart:40`

```dart
ordersController = OrdersController(dio: Dio(), userRole: 'Delivery');
```

---

### **6. API Response Normalization**

**Issue:** Client and Delivery APIs have different response structures

**Solution:** Added `_normalizeResponse()` helper to map delivery format → client format

#### Key Mappings:

| Delivery API | Client API | Normalization |
|--------------|------------|---------------|
| `page` | `pageIndex` | ✅ Mapped |
| `orderId` | `id` | ✅ Mapped |
| `totalAmount` | `total` | ✅ Mapped |
| `customerPhone` | N/A | ✅ Preserved |
| `orderNumber` | N/A | ✅ Preserved |

#### Query Parameter Alignment:

**Client API Request:**
```dart
GET /v1/client/orders?statusId=4&pageIndex=1&pageSize=20
```

**Delivery API Request:**
```dart
GET /v1/delivery/orders?statusId=4&page=1&pageSize=20
```

**Implementation:**
```dart
Map<String, dynamic> toQueryParams({
  required int pageIndex,
  required int pageSize,
  bool isDeliveryRole = false,
}) {
  return {
    // ... other params
    if (isDeliveryRole)
      'page': pageIndex
    else
      'pageIndex': pageIndex,
    'pageSize': pageSize,
  };
}
```

---

### **7. Design Correction: history_delivery.dart**

**Issue:** Incorrect widget used after previous fixes

**Correction:** Restored original design using `TransactionCard` with `WalletTransaction` model

**Before (Incorrect):**
```dart
BuildOrderDeliveryCard(context, screenHeight, screenWidth, ...)
```

**After (Correct):**
```dart
TransactionCard(screenHeight, screenWidth, tx, fromDeliveryMan: true)
```

**Files:**
- `lib/features/Delivery_Man/history/presentation/screens/history_delivery.dart`

**Imports Changed:**
```dart
// Before:
import '../../../../orders/presentation/provider/orders_controller.dart';
import '../widgets/delivery_history_card.dart';

// After:
import '../../../../profile/presentation/provider/wallet_transaction_controller.dart';
import '../../../../profile/presentation/widgets/transaction_card.dart';
```

---

## 📄 Documentation

### **8. Backend API Specification: Delivery Profile**

**Created:** `docs/BE_API_REQUEST_DELIVERY_PROFILE.md`

**Issue:** Delivery users receive 403 when accessing profile endpoints

**Requested Endpoints:**

#### GET /v1/delivery/profile
```json
{
  "id": 22,
  "username": "delivery.john",
  "fullName": "John Delivery",
  "email": "john.delivery@nartawi.com",
  "mobile": "+97412345678",
  "role": "Delivery",
  "deliveryMetrics": {
    "totalDeliveries": 150,
    "completedToday": 8,
    "rating": 4.8,
    "activeOrders": 3
  }
}
```

#### PUT /v1/delivery/profile
Update delivery person profile information

**Status:** ⏳ Pending backend implementation

---

## 📊 Files Modified

| # | File Path | Changes | Lines |
|---|-----------|---------|-------|
| 1 | `features/Delivery_Man/history/presentation/screens/history_delivery.dart` | Restored TransactionCard design + userRole | 1-378 |
| 2 | `features/Delivery_Man/orders/presentation/screens/assigned_orders_screen.dart` | Added userRole parameter | 62 |
| 3 | `features/orders/presentation/pages/order_details.dart` | ReviewAlertDialog parameters | 470-474 |
| 4 | `features/orders/presentation/widgets/orders_buttons.dart` | EdgeInsets fix | 28-30 |
| 5 | `features/auth/presentation/bloc/login_event.dart` | OTP purpose correction | 48 |
| 6 | `features/orders/presentation/provider/order_controller.dart` | Role-based endpoints + normalization | 67-277 |
| 7 | `docs/BE_API_REQUEST_DELIVERY_PROFILE.md` | New specification document | NEW |

**Total:** 6 files modified, 1 new document

---

## 🧪 Testing Requirements

### **For Client Users:**
- ✅ Login with client role → navigate to `/home`
- ✅ Orders fetched from `/v1/client/orders`
- ✅ Profile access works without 403

### **For Delivery Users:**
- ✅ Login with delivery role → navigate to delivery home
- ✅ Orders fetched from `/v1/delivery/orders` (no more 403)
- ✅ History screen uses wallet transactions
- ⏳ Profile shows 403 until backend implements endpoints

### **Forget Password:**
- ✅ Enter email → OTP sent with `reset_password` purpose
- ✅ Verify OTP → no more 400 error

### **Build & Runtime:**
- ✅ Application compiles successfully
- ✅ No type errors in orders_buttons.dart
- ✅ Review dialog works from order details

---

## 🔄 API Compatibility Matrix

| Component | Client API | Delivery API | Status |
|-----------|------------|--------------|--------|
| **Authentication** | Bearer token | Bearer token | ✅ Compatible |
| **Endpoint** | `/v1/client/orders` | `/v1/delivery/orders` | ✅ Dynamic |
| **Query Params** | `statusId`, `pageIndex`, `pageSize` | `statusId`, `page`, `pageSize` | ✅ Normalized |
| **Response Pagination** | `pageIndex`, `totalPages` | `page`, `totalPages` | ✅ Mapped |
| **Order ID Field** | `id` | `orderId` | ✅ Mapped |
| **Total Field** | `total` | `totalAmount` | ✅ Mapped |
| **Status Fields** | `statusId`, `statusName` | `statusId`, `statusName` | ✅ Same |

---

## ⚠️ Known Limitations

1. **Delivery Profile:** Returns 403 until backend implements `/v1/delivery/profile`
   - **Workaround:** Specification provided in `BE_API_REQUEST_DELIVERY_PROFILE.md`
   - **Impact:** Medium - Profile screen unusable for delivery users

2. **Delivery Orders - Null Fields:** These client-specific fields will be `null`:
   - `subTotal`, `discount`, `deliveryCost`
   - `supplierId`, `supplierName`
   - `isPaid`, `paymentMethod`
   - **Impact:** Low - Fields are optional in model

3. **History Screen for Delivery:** Uses wallet transactions (current design)
   - May need revision if delivery-specific history required
   - **Impact:** Low - Current design acceptable

---

## 📝 Migration Notes

### **For Developers:**

**No breaking changes** - all modifications maintain backward compatibility.

**If creating new delivery screens:**
```dart
// Always pass userRole for delivery features
final controller = OrdersController(
  dio: Dio(),
  userRole: 'Delivery',  // ← Important!
);
```

**Query parameter usage:**
```dart
// Correct:
controller.fetchOrders(query: OrdersQuery(statusId: 4));

// Incorrect (will fail):
controller.fetchOrders(statusId: 4);
```

---

## 🎯 Next Steps

### **Immediate (Before Production):**
1. ✅ Test all fixes in development environment
2. ✅ Verify delivery login → orders flow
3. ⏳ Coordinate with backend team for delivery profile endpoints

### **Post-Release:**
1. Monitor delivery API response times
2. Collect feedback on delivery user experience
3. Consider creating dedicated `DeliveryOrder` model if needed

---

## 👥 Credits

**Mobile Team:** Build error identification and fixes  
**Backend Team:** API endpoint specification and alignment

---

## 📞 Support

For issues or questions:
- **Build Errors:** Mobile Development Team
- **API Issues:** Backend API Team
- **Delivery Profile:** Refer to `BE_API_REQUEST_DELIVERY_PROFILE.md`

---

**Release Version:** M1.0.10  
**Previous Version:** M1.0.9 (Delivery Login Implementation)  
**Next Version:** M1.0.11 (TBD)
