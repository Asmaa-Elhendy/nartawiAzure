# 🔧 SPRINT 1: CODE REFERENCE GUIDE
## Quick Copy-Paste Solutions for All 6 Fixes

**Use this guide for:** Quick implementation without reading full plan  
**Status:** Ready to implement  
**Estimated Time:** 6-8 hours total

---

## 📌 QUICK NAVIGATION

1. [Fix #1: Logout (30min)](#fix-1-logout-30-minutes)
2. [Fix #2: Clear Cart (30min)](#fix-2-clear-cart-30-minutes)
3. [Fix #3: Order Filtering (2-3h)](#fix-3-order-tab-filtering-2-3-hours)
4. [Fix #4: Start Delivery Endpoint (1h)](#fix-4-start-delivery-endpoint-1-hour)
5. [Fix #5: OTP Verification (1-2h)](#fix-5-otp-verification-1-2-hours)
6. [Fix #6: Password Reset (1-2h)](#fix-6-password-reset-1-2-hours)

---

## Fix #1: Logout (30 minutes)

### File: `lib/features/profile/presentation/pages/profile.dart`

**Line:** ~235

**Replace this:**
```dart
BuildSingleSeetingProfile(
  screenWidth,
  screenHeight,
  'assets/images/profile/logout.svg',
  'Log Out',
  () {
    // TODO: logout
  },
),
```

**With this:**
```dart
BuildSingleSeetingProfile(
  screenWidth,
  screenHeight,
  'assets/images/profile/logout.svg',
  'Log Out',
  () async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Log Out'),
        content: Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Log Out', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await AuthService.deleteToken();
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  },
),
```

### Import required (add at top if missing):
```dart
import '../../../core/services/auth_service.dart';
```

✅ **Done!** Test by clicking logout button.

---

## Fix #2: Clear Cart (30 minutes)

### File: `lib/features/cart/presentation/screens/cart_screen.dart`

**Location:** Find the clear cart button (search for "Clear" or similar)

**Replace button's onPressed with:**
```dart
onPressed: () async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text('Clear Cart'),
      content: Text('Remove all items from your cart?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(ctx, true),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: Text('Clear All', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );

  if (confirmed == true) {
    _clearCart();
  }
},
```

**Add this method to the cart screen's State class:**
```dart
Future<void> _clearCart() async {
  try {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(child: CircularProgressIndicator()),
    );

    final dio = Dio();
    final token = await AuthService.getToken();

    final response = await dio.delete(
      'https://nartawi.smartvillageqatar.com/api/v1/client/cart/clear',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    Navigator.pop(context);

    if (response.statusCode == 200 || response.statusCode == 204) {
      setState(() {
        // Trigger cart reload via your cart controller
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cart cleared'), backgroundColor: Colors.green),
      );
    }
  } catch (e) {
    if (Navigator.canPop(context)) Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed: ${e.toString()}'), backgroundColor: Colors.red),
    );
  }
}
```

### Imports required:
```dart
import 'package:dio/dio.dart';
import '../../../core/services/auth_service.dart';
```

✅ **Done!** Test by adding items and clearing cart.

---

## Fix #3: Order Tab Filtering (2-3 hours)

### File: `lib/features/orders/presentation/pages/orders_screen.dart`

**Step 1: Find the TabBarView (around line 50-150)**

**Replace this pattern:**
```dart
TabBarView(
  controller: _tabController,
  children: [
    _buildOrderList(null),
    _buildHardcodedList(),  // REMOVE
    _buildHardcodedList(),  // REMOVE
    _buildHardcodedList(),  // REMOVE
  ],
)
```

**With this:**
```dart
TabBarView(
  controller: _tabController,
  children: [
    _buildOrderList(null),    // All
    _buildOrderList(1),       // Pending
    _buildOrderList(4),       // Delivered
    _buildOrderList(5),       // Canceled
  ],
)
```

**Step 2: Update _buildOrderList method:**

```dart
Widget _buildOrderList(int? statusId) {
  return Consumer<OrdersController>(
    builder: (context, controller, child) {
      List<ClientOrder> orders;
      
      if (statusId == null) {
        orders = controller.orders;
      } else {
        orders = controller.orders.where((o) => o.statusId == statusId).toList();
      }

      if (controller.isLoading && orders.isEmpty) {
        return Center(child: CircularProgressIndicator());
      }

      if (controller.errorMessage != null && orders.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 60, color: Colors.red),
              SizedBox(height: 16),
              Text(controller.errorMessage!),
              ElevatedButton(
                onPressed: () => controller.fetchOrders(),
                child: Text('Retry'),
              ),
            ],
          ),
        );
      }

      if (orders.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_bag_outlined, size: 60, color: Colors.grey),
              SizedBox(height: 16),
              Text('No orders found', style: TextStyle(color: Colors.grey)),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () => controller.refreshOrders(),
        child: ListView.builder(
          itemCount: orders.length,
          itemBuilder: (ctx, i) => OrderCard(order: orders[i]),
        ),
      );
    },
  );
}
```

**Step 3: Remove hardcoded methods (if they exist):**
- Delete `_buildHardcodedPendingList()`
- Delete `_buildHardcodedDeliveredList()`
- Delete `_buildHardcodedCanceledList()`

✅ **Done!** Test all 4 tabs.

---

## Fix #4: Start Delivery Endpoint (1 hour)

### File: `lib/features/orders/presentation/pages/order_details.dart`

**Line:** ~194-206 (inside `_handleStartDelivery` method)

**Replace this:**
```dart
final response = await dio.post(
  'https://nartawi.smartvillageqatar.com/api/v1/client/orders/${widget.clientOrder.id}/ChangeStatus',
  data: {
    'statusId': 3,
    'notes': 'Driver started delivery',
  },
  options: Options(
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  ),
);
```

**With this:**
```dart
final response = await dio.post(
  'https://nartawi.smartvillageqatar.com/api/v1/delivery/orders/${widget.clientOrder.id}/start',
  options: Options(
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  ),
);
```

**Key Changes:**
- ✅ New endpoint: `/delivery/orders/{id}/start`
- ✅ No data payload needed
- ✅ Backend handles status automatically

✅ **Done!** Test start delivery flow.

---

## Fix #5: OTP Verification (1-2 hours)

### File: `lib/features/auth/presentation/screens/verification_screen.dart`

**Step 1: Update verify button onPressed:**

```dart
onPressed: () async {
  if (_otpController.text.length != 6) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Enter 6-digit OTP'), backgroundColor: Colors.red),
    );
    return;
  }
  await _verifyOTP();
}
```

**Step 2: Add _verifyOTP method to State class:**

```dart
bool _isLoading = false;

Future<void> _verifyOTP() async {
  try {
    setState(() => _isLoading = true);

    final dio = Dio();
    final response = await dio.post(
      'https://nartawi.smartvillageqatar.com/api/v1/auth/verify-otp',
      data: {
        'email': widget.email,
        'otp': _otpController.text,
      },
    );

    setState(() => _isLoading = false);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verified!'), backgroundColor: Colors.green),
      );

      Navigator.pushNamed(
        context,
        '/resetPassword',
        arguments: {
          'email': widget.email,
          'verificationToken': response.data['verificationToken'],
        },
      );
    }
  } catch (e) {
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Invalid OTP'), backgroundColor: Colors.red),
    );
  }
}
```

**Step 3: Update constructor to receive email:**

```dart
class VerificationScreen extends StatefulWidget {
  final String email;
  
  const VerificationScreen({Key? key, required this.email}) : super(key: key);
  
  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}
```

**Step 4: Show loading in UI:**

```dart
@override
Widget build(BuildContext context) {
  if (_isLoading) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
  
  return Scaffold(
    // ... existing UI
  );
}
```

### Imports:
```dart
import 'package:dio/dio.dart';
```

✅ **Done!** Test OTP verification.

---

## Fix #6: Password Reset (1-2 hours)

### File: `lib/features/auth/presentation/screens/reset_password.dart`

**Step 1: Update reset button onPressed:**

```dart
onPressed: () async {
  if (_passwordController.text != _confirmPasswordController.text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Passwords do not match'), backgroundColor: Colors.red),
    );
    return;
  }
  
  if (_passwordController.text.length < 8) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Min 8 characters'), backgroundColor: Colors.red),
    );
    return;
  }
  
  await _resetPassword();
}
```

**Step 2: Add _resetPassword method:**

```dart
bool _isLoading = false;

Future<void> _resetPassword() async {
  try {
    setState(() => _isLoading = true);

    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final email = args['email'];
    final verificationToken = args['verificationToken'];

    final dio = Dio();
    final response = await dio.post(
      'https://nartawi.smartvillageqatar.com/api/v1/auth/reset-password',
      data: {
        'email': email,
        'verificationToken': verificationToken,
        'newPassword': _passwordController.text,
      },
    );

    setState(() => _isLoading = false);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password reset! Please login.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );

      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (r) => false);
      });
    }
  } catch (e) {
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed: ${e.toString()}'), backgroundColor: Colors.red),
    );
  }
}
```

**Step 3: Show loading:**

```dart
@override
Widget build(BuildContext context) {
  if (_isLoading) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
  
  return Scaffold(
    // ... existing UI
  );
}
```

### Imports:
```dart
import 'package:dio/dio.dart';
```

✅ **Done!** Test password reset flow.

---

## 🧪 TESTING CHECKLIST

### Quick Test Script

```bash
# Test 1: Logout
1. Login to app
2. Go to Profile
3. Click "Log Out"
4. Confirm dialog
5. ✅ Should navigate to login screen

# Test 2: Clear Cart
1. Add items to cart
2. Click "Clear Cart"
3. Confirm dialog
4. ✅ Cart should be empty

# Test 3: Order Filtering
1. Go to Orders screen
2. Click "Pending" tab
3. ✅ Should show only pending orders
4. Click "Delivered" tab
5. ✅ Should show only delivered orders

# Test 4: Start Delivery
1. Login as delivery driver
2. View assigned order
3. Click "Start Delivery"
4. ✅ Status should change to "On The Way"

# Test 5: OTP Verification
1. Click "Forgot Password"
2. Enter email
3. Enter OTP
4. ✅ Should navigate to reset password

# Test 6: Password Reset
1. After OTP verification
2. Enter new password
3. Confirm password
4. ✅ Should reset and navigate to login
```

---

## 🚨 COMMON ERRORS & SOLUTIONS

### Error: "Navigator operation requested with a context that does not include a Navigator"
**Solution:** Ensure you're using the correct BuildContext. Use Navigator.of(context) or check mounted state.

### Error: "Dio is not defined"
**Solution:** Add import: `import 'package:dio/dio.dart';`

### Error: "AuthService.deleteToken() not found"
**Solution:** Verify method exists in `auth_service.dart`:
```dart
static Future<void> deleteToken() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('auth_token');
}
```

### Error: "setState() called after dispose()"
**Solution:** Check `mounted` before calling setState:
```dart
if (mounted) {
  setState(() { ... });
}
```

---

## 📦 REQUIRED DEPENDENCIES

Verify these are in `pubspec.yaml`:

```yaml
dependencies:
  dio: ^5.0.0
  shared_preferences: ^2.0.0
  provider: ^6.0.0
```

If missing, run:
```bash
flutter pub get
```

---

## ⏱️ TIME ESTIMATES

| Fix | Estimated | Actual | Notes |
|-----|-----------|--------|-------|
| Logout | 30min | ___ | Simple |
| Clear Cart | 30min | ___ | Simple |
| Order Filtering | 2-3h | ___ | Medium complexity |
| Start Delivery | 1h | ___ | API update |
| OTP Verification | 1-2h | ___ | Requires testing |
| Password Reset | 1-2h | ___ | Requires testing |
| **TOTAL** | **6-8h** | ___ | |

---

## 📞 NEED HELP?

**Stuck on a fix?** Check:
1. `SPRINT_1_FIX_PLAN.md` - Detailed explanations
2. `MOBILE_FRONTEND_SSOT.md` - Architecture reference
3. Existing similar code in codebase
4. QA reports for context

**API errors?** Verify:
- Backend v1.0.21 is deployed
- Auth token is valid
- Endpoint URLs are correct

---

**Ready to start? Pick the easiest wins first:**
1. ✅ Fix Logout (30min)
2. ✅ Fix Clear Cart (30min)
3. ✅ Then tackle the rest!

**Good luck! 🚀**
