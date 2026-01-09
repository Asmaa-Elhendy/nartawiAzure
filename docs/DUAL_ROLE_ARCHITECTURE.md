# 🎭 DUAL-ROLE ARCHITECTURE GUIDE

**Purpose:** Comprehensive documentation of how the Nartawi mobile app supports both Customer and Delivery personnel roles  
**Created:** January 9, 2026  
**Status:** Active Pattern in Production Code

---

## 📋 TABLE OF CONTENTS

1. [Overview](#overview)
2. [Architecture Pattern](#architecture-pattern)
3. [Role Detection & Routing](#role-detection--routing)
4. [Existing Dual-Role Screens](#existing-dual-role-screens)
5. [Module Structure](#module-structure)
6. [Navigation Flow](#navigation-flow)
7. [Backend Role System](#backend-role-system)
8. [Implementation Examples](#implementation-examples)
9. [Best Practices](#best-practices)

---

## 🎯 OVERVIEW

### **Business Requirement**
The Nartawi mobile app serves **TWO distinct user types** with the same codebase:
1. **Customers** - Order water, track deliveries, manage wallet
2. **Delivery Personnel** - View assigned orders, submit proof of delivery, navigate routes

### **Solution**
A **dual-role architecture** that:
- Uses a single Flutter codebase
- Routes users to appropriate screens based on their `SECURITY_ROLE`
- Shares common widgets with role-specific behavior via flags
- Maintains separate navigation stacks for each role

---

## 🏗️ ARCHITECTURE PATTERN

### **Role-Based Flag Pattern**

The app uses a consistent pattern throughout: the `fromDeliveryMan` boolean flag.

```dart
// Pattern used across the app
class SomeScreen extends StatefulWidget {
  final bool fromDeliveryMan; // 👈 Role indicator
  
  const SomeScreen({
    this.fromDeliveryMan = false, // Defaults to customer
  });
}
```

### **Why This Pattern?**

✅ **Single Codebase** - Avoid duplication  
✅ **Easy Maintenance** - One widget, multiple behaviors  
✅ **Consistent UX** - Shared components maintain brand consistency  
✅ **Role Isolation** - Clear separation when needed  

---

## 🔐 ROLE DETECTION & ROUTING

### **Backend Role System**

**Database Schema:**
```sql
-- User account
ACCOUNT (ID, LOGIN_NAME, EMAIL, ...)

-- Roles lookup
SECURITY_ROLE
├── ID=9  → Admin
├── ID=29 → Client (Customer)
└── ID=49 → Vendor

-- User-to-Role mapping (junction table)
ACCOUNT_SEC_ROLES
├── ACCOUNT_ID (FK → ACCOUNT.ID)
└── SEC_ROLE_ID (FK → SECURITY_ROLE.ID)
```

**Example Data:**
```sql
-- Customer user
ACCOUNT.ID = 21 (asmaa@gmail.com)
ACCOUNT_SEC_ROLES: (21, 29) -- Has Client role

-- Delivery user  
ACCOUNT.ID = 25 (delivery_rayyan)
ACCOUNT_SEC_ROLES: (25, 29) -- Also has Client role (dual purpose)
```

### **Authentication Flow**

```dart
// Step 1: User logs in
POST /api/v1/auth/login
{
  "username": "delivery_rayyan",
  "password": "***"
}

// Step 2: Backend returns JWT with role claims
Response: {
  "token": "eyJ...",
  "refreshToken": "...",
  "account": {
    "id": 25,
    "name": "Delivery Rayyan",
    "roles": ["Client", "Delivery"] // 👈 Role list
  }
}

// Step 3: App stores token and roles
await AuthService.saveToken(token);
await AuthService.saveUserRoles(roles);

// Step 4: Routing decision
if (roles.contains('Delivery')) {
  Navigator.pushReplacementNamed(context, '/delivery-home');
} else if (roles.contains('Client')) {
  Navigator.pushReplacementNamed(context, '/customer-home');
}
```

---

## 📱 EXISTING DUAL-ROLE SCREENS

### **1. Order Details Screen**
**File:** `lib/features/orders/presentation/pages/order_details.dart`

```dart
class OrderDetailScreen extends StatefulWidget {
  String orderStatus;
  String paymentStatus;
  ClientOrder clientOrder;
  bool fromDeliveryMan; // 👈 DUAL-ROLE FLAG

  OrderDetailScreen({
    required this.orderStatus,
    required this.paymentStatus,
    required this.clientOrder,
    this.fromDeliveryMan = false, // Default: Customer view
  });
}
```

**Behavior Differences:**

| Feature | Customer View | Delivery View |
|---------|---------------|---------------|
| **Order Header** | Shows order date | Shows order date + payment status |
| **Customer Info** | Hidden | Shows customer card with contact |
| **Delivery Info** | Shows delivery address | Hidden |
| **Payment Info** | Shows payment method | Hidden |
| **Seller Info** | Shows supplier details | Hidden |
| **Action Buttons** | Leave Review / Cancel | Start Delivery / Mark Delivered |

**Code Example:**
```dart
// In build method
Column(
  children: [
    OrderSummaryCard(...),
    
    // Customer-only section
    if (!widget.fromDeliveryMan) ...[
      OrderDeliveryCard(...),
      OrderPaymentCard(...),
      OrderSellerInformationCard(...),
      if (widget.orderStatus == 'Delivered')
        BuildInfoAndAddToCartButton('Leave Review', ...),
    ],
    
    // Delivery-only section
    if (widget.fromDeliveryMan) ...[
      CustomerCardInformation(...),
      if (widget.orderStatus == 'Pending' || widget.orderStatus == 'On The Way')
        CustomGradientButton('Start Delivery', ...),
    ],
  ],
)
```

---

### **2. Notification Screen**
**File:** `lib/features/notification/presentation/pages/notification_screen.dart`

```dart
class NotificationScreen extends StatefulWidget {
  bool fromDeliveryMan;
  
  NotificationScreen({this.fromDeliveryMan = false});
}
```

**Tab Differences:**

```dart
// Customer tabs
static const List<String> _tabsUser = [
  'All', 'New', 'Read', 'Orders', 'Coupons', 'Promos',
];

// Delivery tabs
static const List<String> _tabsDelivery = [
  'All', 'New', 'Read', 'One Time', 'Coupons', 'Disputes', 'Canceled',
];

List<String> get _tabs => widget.fromDeliveryMan ? _tabsDelivery : _tabsUser;
```

---

### **3. App Bar Widget**
**File:** `lib/features/home/presentation/widgets/build_ForegroundAppBarHome.dart`

```dart
class BuildForegroundappbarhome extends StatelessWidget {
  final bool fromDeliveryMan;
  // ... other params
  
  const BuildForegroundappbarhome({
    this.fromDeliveryMan = false,
    // ...
  });
}
```

**Behavior:**
- Adjusts navigation based on role
- Shows role-specific menu items
- Different back navigation logic

---

## 📂 MODULE STRUCTURE

### **Customer Module**
```
lib/features/
├── home/              # Customer home screen
├── orders/            # Order history & details
├── cart/              # Shopping cart
├── coupons/           # Coupon management
├── favourites/        # Saved products/suppliers
├── profile/           # Profile, wallet, addresses
└── notification/      # Notifications
```

### **Delivery Module**
```
lib/features/Delivery_Man/
├── home/              # Delivery home screen
│   └── screens/
│       └── home_delivery.dart
├── orders/            # Assigned orders
│   └── screens/
│       ├── assigned_orders_screen.dart
│       ├── delivery_confirmation_screen.dart
│       └── track_order.dart
├── history/           # Delivery history
└── profile/           # Delivery profile
```

### **Shared Widgets**
```
lib/features/
├── home/presentation/widgets/
│   ├── background_home_Appbar.dart
│   ├── build_ForegroundAppBarHome.dart  # 👈 Role-aware
│   └── main_screen_widgets/
└── orders/presentation/widgets/
    ├── order_status_widget.dart         # 👈 Role-aware
    └── order_summary_card.dart          # 👈 Role-aware
```

---

## 🗺️ NAVIGATION FLOW

### **Customer Navigation**
```dart
// Main screen with bottom nav
MainScreen (IndexedStack)
├── Tab 0: Home
├── Tab 1: Favorites
├── Tab 2: Orders
├── Tab 3: Coupons
└── Tab 4: Profile

// Customer sees:
- Product browsing
- Shopping cart
- Order placement
- Wallet management
- Address management
```

### **Delivery Navigation**
```dart
// Delivery main screen
MainScreenDelivery (IndexedStack)
├── Tab 0: History
├── Tab 1: Orders (Assigned)
└── Tab 2: Profile

// Delivery sees:
- Assigned orders list
- Order details with customer info
- Navigation to delivery address
- POD submission
- Delivery history
```

### **Entry Point Routing**
```dart
// In AppRouter or AuthService
Future<String> getInitialRoute() async {
  final isLoggedIn = await AuthService.isAuthenticated();
  
  if (!isLoggedIn) {
    return '/login';
  }
  
  final roles = await AuthService.getUserRoles();
  
  // Priority: Delivery > Customer
  if (roles.contains('Delivery')) {
    return '/delivery-home';
  } else if (roles.contains('Client')) {
    return '/customer-home';
  } else {
    return '/login'; // Fallback
  }
}
```

---

## 🔧 BACKEND ROLE SYSTEM

### **Role Assignment**

**During Account Creation:**
```sql
-- Step 1: Create account
INSERT INTO ACCOUNT (ID, LOGIN_NAME, EMAIL, ...)
VALUES (25, 'delivery_rayyan', 'delivery@rayyan.com', ...);

-- Step 2: Assign role
INSERT INTO ACCOUNT_SEC_ROLES (ACCOUNT_ID, SEC_ROLE_ID)
VALUES (25, 29); -- Client role (if delivery can also order)
-- OR
-- (25, 50); -- Delivery role (if it exists)
```

**Current Production Roles:**
- **Admin** (ID=9): Full system access
- **Client** (ID=29): Customer features
- **Vendor** (ID=49): Supplier dashboard (web only)
- **Delivery** (Custom): Delivery personnel (needs verification)

---

## 💻 IMPLEMENTATION EXAMPLES

### **Example 1: Shared Widget with Role Logic**

```dart
class OrderStatusWidget extends StatelessWidget {
  final String status;
  final bool fromDeliveryMan;
  
  const OrderStatusWidget({
    required this.status,
    this.fromDeliveryMan = false,
  });
  
  @override
  Widget build(BuildContext context) {
    // Different colors/labels based on role
    if (fromDeliveryMan) {
      // Delivery sees: "Ready to Pick", "In Transit", "Delivered"
      return _buildDeliveryStatus();
    } else {
      // Customer sees: "Pending", "Confirmed", "Out for Delivery", "Delivered"
      return _buildCustomerStatus();
    }
  }
}
```

---

### **Example 2: Navigation with Role Passing**

```dart
// From customer order list
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => OrderDetailScreen(
      orderStatus: order.status,
      paymentStatus: order.paymentStatus,
      clientOrder: order,
      fromDeliveryMan: false, // 👈 Customer context
    ),
  ),
);

// From delivery assigned orders
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => OrderDetailScreen(
      orderStatus: order.status,
      paymentStatus: order.paymentStatus,
      clientOrder: order,
      fromDeliveryMan: true, // 👈 Delivery context
    ),
  ),
);
```

---

### **Example 3: API Endpoints by Role**

```dart
class OrderService {
  // Customer endpoints
  Future<List<Order>> getMyOrders() async {
    return dio.get('/api/v1/client/orders');
  }
  
  Future<Order> getOrderDetails(int id) async {
    return dio.get('/api/v1/client/orders/$id');
  }
  
  // Delivery endpoints
  Future<List<Order>> getAssignedOrders() async {
    // Backend filters by delivery person
    return dio.get('/api/v1/delivery/orders');
  }
  
  Future<void> submitPOD({
    required int orderId,
    required String photoBase64,
    required double latitude,
    required double longitude,
  }) async {
    return dio.post('/api/v1/delivery/pod', data: {
      'orderId': orderId,
      'photoBase64': photoBase64,
      'geoLocation': {
        'latitude': latitude,
        'longitude': longitude,
      },
    });
  }
}
```

---

## ✅ BEST PRACTICES

### **1. Always Default to Customer**
```dart
// ✅ GOOD
class MyScreen extends StatefulWidget {
  final bool fromDeliveryMan;
  MyScreen({this.fromDeliveryMan = false}); // Defaults to customer
}

// ❌ BAD
class MyScreen extends StatefulWidget {
  final bool fromDeliveryMan;
  MyScreen({required this.fromDeliveryMan}); // Forces explicit flag
}
```

**Reason:** Most screens are customer-facing. Default to customer prevents bugs.

---

### **2. Use Clear Conditional Sections**
```dart
// ✅ GOOD
if (!fromDeliveryMan) {
  // Customer-only section
  return CustomerWidget();
}

if (fromDeliveryMan) {
  // Delivery-only section
  return DeliveryWidget();
}

// ❌ BAD - Nested ternaries
return fromDeliveryMan 
  ? DeliveryWidget() 
  : isCustomer 
    ? CustomerWidget() 
    : DefaultWidget();
```

---

### **3. Role-Specific API Calls**
```dart
// ✅ GOOD - Different endpoints
if (fromDeliveryMan) {
  orders = await orderService.getAssignedOrders();
} else {
  orders = await orderService.getMyOrders();
}

// ❌ BAD - Same endpoint with flag
orders = await orderService.getOrders(isDelivery: fromDeliveryMan);
```

**Reason:** Backend has separate endpoints for security isolation.

---

### **4. Maintain UI Consistency**
```dart
// Both roles use same widgets, different data
return Column([
  OrderSummaryCard(order), // 👈 Same widget
  if (fromDeliveryMan)
    CustomerInfoCard(order.customer), // 👈 Delivery-specific
  if (!fromDeliveryMan)
    DeliveryInfoCard(order.delivery), // 👈 Customer-specific
]);
```

---

### **5. Test Both Roles**
```dart
// In widget tests
testWidgets('Order screen - Customer view', (tester) async {
  await tester.pumpWidget(OrderDetailScreen(
    fromDeliveryMan: false, // 👈 Test customer
    // ...
  ));
  expect(find.text('Delivery Address'), findsOneWidget);
});

testWidgets('Order screen - Delivery view', (tester) async {
  await tester.pumpWidget(OrderDetailScreen(
    fromDeliveryMan: true, // 👈 Test delivery
    // ...
  ));
  expect(find.text('Customer Information'), findsOneWidget);
});
```

---

## 🔍 ROLE DETECTION HELPERS

### **Suggested AuthService Extension**

```dart
// lib/core/services/auth_service.dart
class AuthService {
  static Future<bool> isDeliveryPersonnel() async {
    final roles = await getUserRoles();
    return roles.contains('Delivery');
  }
  
  static Future<bool> isCustomer() async {
    final roles = await getUserRoles();
    return roles.contains('Client');
  }
  
  static Future<bool> isVendor() async {
    final roles = await getUserRoles();
    return roles.contains('Vendor');
  }
  
  static Future<List<String>> getUserRoles() async {
    final prefs = await SharedPreferences.getInstance();
    final rolesJson = prefs.getString('user_roles');
    if (rolesJson == null) return [];
    return List<String>.from(jsonDecode(rolesJson));
  }
}
```

**Usage:**
```dart
// In initState or routing logic
final isDelivery = await AuthService.isDeliveryPersonnel();
setState(() {
  fromDeliveryMan = isDelivery;
});
```

---

## 📊 CURRENT STATUS MATRIX

| Screen | Customer Support | Delivery Support | Status |
|--------|-----------------|------------------|--------|
| **Order Details** | ✅ Yes | ✅ Yes | **Production** |
| **Notifications** | ✅ Yes | ✅ Yes | **Production** |
| **App Bar** | ✅ Yes | ✅ Yes | **Production** |
| **Home Screen** | ✅ Yes | ✅ Yes | **Production** |
| **Assigned Orders** | ❌ No | ✅ Yes | **Production** |
| **Delivery Confirmation** | ❌ No | ⚠️ Mock Data | **Needs API** |
| **Track Order** | ❌ No | ⚠️ Mock Data | **Needs API** |
| **POD Display** | ⚠️ Missing | ❌ No | **M1.0.5** |
| **Dispute Screen** | ⚠️ Missing | ❌ No | **M1.0.5** |

---

## 🎯 M1.0.5 INTEGRATION POINTS

### **Customer Side - POD & Dispute**
Add to existing `order_details.dart`:
- POD display section (when order delivered)
- Dispute button (when order delivered)
- Dispute status display

### **Delivery Side - POD Submission**
Connect existing `delivery_confirmation_screen.dart`:
- Remove mock data
- Add camera integration
- Add GPS capture
- Connect to `/api/v1/delivery/pod` endpoint

### **Shared Logic**
Both roles interact with:
- `ORDER_CONFIRMATION` table (POD)
- `DISPUTE` tables (customer creates, delivery may respond)
- `DOCUMENT` table (photo uploads)

---

## 🔐 SECURITY CONSIDERATIONS

### **Role Validation**
```dart
// Backend must validate role on EVERY request
[Authorize(Roles = "Client")]
public async Task<IActionResult> GetMyOrders() {
  var userId = User.GetUserId();
  // Only return orders for this customer
}

[Authorize(Roles = "Delivery")]
public async Task<IActionResult> GetAssignedOrders() {
  var deliveryId = User.GetUserId();
  // Only return orders assigned to this delivery person
}
```

### **Frontend Role Checks**
```dart
// Don't rely solely on frontend role checks
// Backend MUST enforce authorization
if (await AuthService.isDeliveryPersonnel()) {
  // Show delivery menu
} else {
  // Show customer menu
}
```

---

## 📚 REFERENCES

**Code Locations:**
- Customer Home: `lib/features/home/presentation/pages/mainscreen.dart`
- Delivery Home: `lib/features/Delivery_Man/home/presentation/screens/home_delivery.dart`
- Dual-Role Order Screen: `lib/features/orders/presentation/pages/order_details.dart`
- Backend Schema: `docs/SINGLE_SOURCE_OF_TRUTH.md`
- App Router: `lib/core/routing/app_router.dart`

**Backend Endpoints:**
- Customer Orders: `/api/v1/client/orders`
- Delivery Orders: `/api/v1/delivery/orders`
- POD Submission: `/api/v1/delivery/pod`
- Disputes: `/api/v1/client/disputes`

---

## ✅ SUMMARY

The Nartawi app uses a **proven dual-role pattern**:
1. **Single codebase** with `fromDeliveryMan` flag
2. **Role-based routing** after authentication
3. **Shared widgets** with conditional rendering
4. **Separate API endpoints** for security
5. **Consistent UX** across both roles

This architecture allows efficient development while maintaining clear separation of concerns between customer and delivery workflows.

**Next Steps:**
- See `M1.0.5_REVISED_IMPLEMENTATION_GUIDE.md` for POD/Dispute integration
- Maintain this pattern for all future dual-role features
- Test both roles thoroughly before release

---

**Document Version:** 1.0  
**Last Updated:** January 9, 2026  
**Maintained By:** Development Team
