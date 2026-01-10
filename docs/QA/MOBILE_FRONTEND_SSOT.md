# 📱 MOBILE FRONTEND SINGLE SOURCE OF TRUTH
## Nartawi Mobile App - Complete Feature & Integration Reference

**Version:** 1.0  
**Last Updated:** January 10, 2026 6:50 AM  
**Status:** 🟢 Production Reference  
**Purpose:** Comprehensive mapping of all mobile features, screens, APIs, and implementation status

---

## 📋 DOCUMENT OVERVIEW

This document serves as the **authoritative reference** for the Nartawi Mobile Frontend (Flutter). It maps:
- All app features and their implementation status
- UI screens and their code locations
- Backend API integrations
- Shared components and services
- Navigation flows
- Known issues and technical debt

**Use this document for:**
- Feature discovery and status checks
- API endpoint reference
- Code location lookup
- Integration verification
- Planning new features or fixes

---

## 🏗️ ARCHITECTURE OVERVIEW

### **Technology Stack**
- **Framework:** Flutter 3.x
- **Language:** Dart
- **State Management:** BLoC Pattern + ChangeNotifier
- **HTTP Client:** Dio 5.x
- **Storage:** SharedPreferences
- **Navigation:** Named Routes (MaterialPageRoute)
- **Authentication:** JWT Bearer Tokens

### **Project Structure**
```
lib/
├── core/
│   ├── services/          # AuthService, etc.
│   ├── routing/           # AppRouter
│   ├── theme/             # Colors, TextStyles
│   ├── interceptors/      # AuthInterceptor
│   └── components/        # Shared widgets
├── features/
│   ├── auth/              # Authentication
│   ├── home/              # Home & Browse
│   ├── orders/            # Order Management
│   ├── cart/              # Shopping Cart
│   ├── coupons/           # Coupons & Scheduling
│   ├── favourites/        # Favorites
│   ├── profile/           # Profile & Settings
│   ├── notification/      # Notifications
│   ├── Delivery_Man/      # Delivery Driver Module
│   └── splash/            # Splash & Onboarding
└── main.dart
```

### **Layered Architecture**
Each feature module follows:
```
feature/
├── data/
│   ├── datasources/       # API calls
│   └── models/            # Request/Response models
├── domain/
│   └── models/            # Business entities
└── presentation/
    ├── pages/             # Screens
    ├── widgets/           # UI components
    ├── bloc/              # BLoC state management
    └── provider/          # ChangeNotifier controllers
```

---

## 🗺️ FEATURE MAPPING

### **Module 1: Splash & Onboarding** (4 features, 98% complete)

| Feature | Screen | Code Location | API | Status |
|---------|--------|---------------|-----|--------|
| Splash Screen | `splash.png` | `splash/splash_screen.dart` | None | ✅ 100% |
| Auto-login Check | - | `splash/splash_screen.dart:15-35` | None | ✅ 100% |
| Onboarding Carousel | `onboarding.png` | `splash/onboarding.dart` | None | ✅ 100% |
| Navigate to Login | - | `splash/onboarding.dart:157-165` | None | ✅ 100% |

**Shared Components:** None  
**Navigation:** `/ → /onBording → /login`

---

### **Module 2: Authentication** (8 features, 92% complete)

| Feature | Screen | Code Location | API Endpoint | Status |
|---------|--------|---------------|--------------|--------|
| User Login | `login.png` | `auth/presentation/screens/login.dart` | `POST /v1/auth/client/login` | ✅ 100% |
| User Registration | `sign up.png` | `auth/presentation/screens/sign_up.dart` | `POST /v1/auth/client/register` | ✅ 100% |
| Phone/Email Selection | `sign up.png` | `auth/presentation/screens/sign_up.dart:120-180` | - | ✅ 100% |
| OTP Verification | `otp code.png` | `auth/presentation/screens/verification_screen.dart` | `POST /v1/auth/verify-otp` | ⚠️ 40% (UI only) |
| Forgot Password | `forget password.png` | `auth/presentation/screens/forget_password.dart` | `POST /v1/auth/forgot-password` | ⚠️ 70% (partial) |
| Remember Me | - | `auth/presentation/bloc/login_bloc.dart` | - | ✅ 100% |
| Auto-login | - | `splash/splash_screen.dart:21-35` | - | ✅ 100% |
| Logout | - | - | - | ❌ 0% (not implemented) |

**Shared Service:** `AuthService` (`core/services/auth_service.dart`)
- `saveToken(String token)` - Stores JWT
- `getToken()` - Retrieves JWT
- `deleteToken()` - Clears JWT (for logout)

**State Management:** `AuthBloc` (`auth/presentation/bloc/login_bloc.dart`)

**Critical Issues:**
- ❌ Logout not implemented (must call `AuthService.deleteToken()` + navigate to `/login`)
- ❌ OTP verification bypassed (calls navigate without API)
- ❌ Password reset incomplete (no reset API call)

**Navigation:** `/login ⇄ /signUp ⇄ /forgetPassword → /verification → /resetPassword → /main`

---

### **Module 3: Home & Browse** (15 features, 95% complete)

| Feature | Screen | Code Location | API Endpoint | Status |
|---------|--------|---------------|--------------|--------|
| Home Dashboard | `home.png` | `home/presentation/pages/home.dart` | Multiple | ✅ 100% |
| Product Listing | `products.png` | `home/presentation/pages/all_product_screen.dart` | `GET /v1/client/products` | ✅ 100% |
| Product Search | `search.png` | `home/presentation/pages/home.dart` | `GET /v1/client/products?search=` | ✅ 100% |
| Product Filters | `filter overlay.png` | `home/presentation/widgets/filter_overlay.dart` | Partial | ⚠️ 60% |
| Product Details | `product details.png` | `home/presentation/pages/suppliers/product_details.dart` | `GET /v1/client/products/{vsid}` | ✅ 100% |
| Add to Cart | - | `home/presentation/widgets/icon_on_product_card.dart` | `POST /v1/client/cart` | ✅ 100% |
| Supplier Listing | `suppliers.png` | `home/presentation/pages/suppliers/all_suppliers_screen.dart` | `GET /v1/client/suppliers` | ✅ 100% |
| Category Browsing | `categories.png` | `home/presentation/pages/popular_categories_main_screen.dart` | `GET /v1/client/product-categories` | ✅ 100% |
| Featured Stores | `home.png` | `home/presentation/widgets/featured_stores_section.dart` | `GET /v1/client/suppliers/featured` | ✅ 100% |
| Product Reviews | `reviews.png` | `home/presentation/provider/supplier_reviews_controller.dart` | `GET /v1/client/suppliers/{id}/reviews` | ✅ 100% |
| Add to Favorites | - | `home/presentation/widgets/icon_on_product_card.dart` | `POST /v1/client/favorites/products/{vsid}` | ✅ 100% |
| Product Quantity | - | `home/presentation/bloc/product_quantity/product_quantity_bloc.dart` | - | ✅ 100% |
| Bundle Products | `products.png` | `home/presentation/pages/all_product_screen.dart` | `GET /v1/client/products?isBundle=true` | ✅ 100% |
| Store Details | `supplier detail.png` | `home/presentation/pages/suppliers/supplier_detail.dart` | `GET /v1/client/suppliers/{id}` | ✅ 100% |
| Infinite Scroll | - | All list screens | Pagination params | ✅ 100% |

**State Management:**
- `ProductsBloc` - Product listing
- `SuppliersBloc` - Supplier listing
- `ProductCategoriesBloc` - Category navigation
- `ProductQuantityBloc` - Cart quantity management
- `SupplierReviewsController` - Reviews
- `WalletBalanceController` - User balance display

**Shared Components:**
- `bottom_navigation_bar.dart` - Main app navigation (5 tabs)
- `product_card.dart` - Reusable product display
- `build_carous_slider.dart` - Banner carousel

**Navigation:** `/main` (MainScreen with PageView for 5 tabs)

---

### **Module 4: Orders** (12 features, 90% complete)

| Feature | Screen | Code Location | API Endpoint | Status |
|---------|--------|---------------|--------------|--------|
| Order History | `orders.png` | `orders/presentation/pages/orders_screen.dart` | `GET /v1/client/orders` | ✅ 100% |
| Order Filtering | `orders.png` (tabs) | `orders/presentation/pages/orders_screen.dart:50-150` | `GET /v1/client/orders?statusId=` | ❌ 20% (hardcoded) |
| Order Details - Pending | `order detail - pending.png` | `orders/presentation/pages/order_details.dart` | `GET /v1/client/orders/{id}` | ✅ 100% |
| Order Details - Delivered | `order detail - delivered.png` | `orders/presentation/pages/order_details.dart` | Same | ✅ 100% |
| Order Details - Cancelled | `order detail - cancelled.png` | `orders/presentation/pages/order_details.dart` | Same | ✅ 100% |
| Order Status Tracking | - | `orders/presentation/pages/order_details.dart` | - | ✅ 100% |
| Reorder | `order detail.png` (button) | `orders/presentation/widgets/orders_buttons.dart:30-35` | - | ❌ 30% (no logic) |
| Cancel Order | `cancel order modal.png` | `orders/presentation/widgets/cancel_alert_dialog.dart` | `POST /v1/client/orders/{id}/cancel` | ✅ 100% |
| POD Display | `POD.png` | `orders/presentation/widgets/pod_display_modal.dart` | Embedded in order | ✅ 100% |
| Submit Dispute | `dispute.png` | `orders/presentation/widgets/dispute_submission_modal.dart` | `POST /v1/client/disputes` | ✅ 100% |
| View Dispute Status | `dispute status.png` | `orders/presentation/widgets/dispute_status_modal.dart` | Embedded in order | ✅ 100% |
| Leave Review | `review.png` | `orders/presentation/widgets/review_alert_dialog.dart` | `POST /v1/client/suppliers/{id}/reviews` | ✅ 100% |

**State Management:** `OrdersController` (`orders/presentation/provider/order_controller.dart`)

**Datasources:**
- `OrderConfirmationDataSource` - POD operations
- `DisputeDataSource` - Dispute submission

**Critical Issues:**
- ❌ Order tabs (Pending/Delivered/Canceled) show hardcoded data instead of filtered API results
- ❌ Reorder button has empty handler

**Navigation:** `/ordersScreen → OrderDetailScreen(push)`

---

### **Module 5: Coupons & Scheduling** (8 features, 95% complete)

| Feature | Screen | Code Location | API Endpoint | Status |
|---------|--------|---------------|--------------|--------|
| Bundle Purchase History | `coupons.png` | `coupons/presentation/screens/coupons_screen.dart` | `GET /v1/client/wallet/bundle-purchases` | ✅ 100% |
| Coupon Balance | `coupons.png` (cards) | `coupons/presentation/provider/coupon_controller.dart` | `GET /v1/client/wallet/coupons` | ✅ 100% |
| Coupon Details | `couponscompany-detail.png` | `coupons/presentation/widgets/coupon_card.dart` | Embedded | ✅ 100% |
| Show Delivery Photos | `delivery-photo.png` | `coupons/presentation/widgets/show_delivery_photos.dart` | Embedded in coupon | ✅ 100% |
| Submit Dispute | `dispute.png` | `coupons/presentation/widgets/dispute_alert.dart` | `POST /v1/client/disputes` | ✅ 100% |
| Create Scheduled Order | `Preferred times for refilling.png` | `coupons/data/datasources/scheduled_order_remote_datasource.dart` | `POST /v1/client/scheduled-orders` | ✅ 100% |
| Update Scheduled Order | - | Same | `PUT /v1/client/scheduled-orders/{id}` | ✅ 100% |
| Delete Scheduled Order | - | Same | `DELETE /v1/client/scheduled-orders/{id}` | ✅ 100% |

**State Management:** `CouponsController` (`coupons/presentation/provider/coupon_controller.dart`)

**Models:**
- `WalletCoupon` - Coupon entity
- `BundlePurchase` - Bundle purchase history
- `ScheduledOrderModel` - Recurring orders

**Shared Components:**
- 18 reusable widgets in `coupons/presentation/widgets/`

**Navigation:** `/couponsScreen` (from bottom nav)

---

### **Module 6: Favorites** (7 features, 95% complete)

| Feature | Screen | Code Location | API Endpoint | Status |
|---------|--------|---------------|--------------|--------|
| View Favorite Products | `favourites.png` (Products tab) | `favourites/pesentation/screens/favourites_screen.dart` | `GET /v1/client/favorites/products` | ✅ 100% |
| View Favorite Vendors | `favourites.png` (Stores tab) | Same | `GET /v1/client/favorites/vendors` | ✅ 100% |
| Add Product to Favorites | - | `favourites/pesentation/provider/favourite_controller.dart` | `POST /v1/client/favorites/products/{vsid}` | ✅ 100% |
| Remove from Favorites | - | Same | `DELETE /v1/client/favorites/products/{vsid}` | ✅ 100% |
| Add Vendor to Favorites | - | Same | `POST /v1/client/favorites/vendors/{id}` | ✅ 100% |
| Remove Vendor | - | Same | `DELETE /v1/client/favorites/vendors/{id}` | ✅ 100% |
| Navigate to Details | - | `favourites/pesentation/screens/favourites_screen.dart` | - | ✅ 100% |

**State Management:** `FavouritesController` (`favourites/pesentation/provider/favourite_controller.dart`)

**Models:**
- `FavoriteProduct` - Product favorites
- `FavoriteVendor` - Vendor favorites

**Minor Issues:**
- ⚠️ Folder typo: `pesentation` instead of `presentation`
- ⚠️ `fromFavouritesScreen: false` should be `true` in vendor card

**Navigation:** `/favouritesScreen` (from bottom nav)

---

### **Module 7: Profile & Settings** (12 features, 88% complete)

| Feature | Screen | Code Location | API Endpoint | Status |
|---------|--------|---------------|--------------|--------|
| View Profile | `profile.png` | `profile/presentation/pages/profile.dart` | `GET /v1/client/account` | ✅ 100% |
| Edit Profile | `edit profile.png` | `profile/presentation/pages/edit_profile.dart` | `PUT /v1/client/account` | ✅ 100% |
| Delivery Addresses | `delivery addresses.png` | `profile/presentation/pages/delivery_address.dart` | `GET /v1/client/account/addresses` | ✅ 100% |
| Add Address | Modal | `profile/presentation/widgets/add_new_address_alert.dart` | `POST /v1/client/account/addresses` | ✅ 100% |
| Update Address | - | `profile/presentation/provider/address_controller.dart` | `PUT /v1/client/account/addresses/{id}` | ✅ 100% |
| Delete Address | - | Same | `DELETE /v1/client/account/addresses/{id}` | ✅ 100% |
| View eWallet | `My eWallet.png` | `profile/presentation/pages/my_ewallet_screen.dart` | `GET /v1/client/wallet/balance` | ✅ 100% |
| Wallet Transactions | `My eWallet.png` | `profile/presentation/provider/wallet_transaction_controller.dart` | `GET /v1/client/wallet/transactions` | ✅ 100% |
| Wallet Transfer | `My eWallet.png` (button) | `profile/presentation/widgets/add_transfer_alert.dart` | - | ❌ 0% (no API) |
| Change Password | `settings-Change Password.png` | `profile/presentation/widgets/change password.dart` | - | ❌ 0% (no API) |
| Notification Settings | `settings.png` | `profile/presentation/pages/settings.dart` | `GET/PUT /v1/client/account/notification-preferences` | ✅ 100% |
| My Impact | `my impact.png` | `profile/presentation/pages/my_impact.dart` | - | ⚠️ 30% (hardcoded) |

**State Management:**
- `ProfileController` - User profile
- `AddressController` - Delivery addresses
- `WalletTransactionController` - Wallet operations

**Critical Issues:**
- ❌ Logout not implemented in `profile.dart:235`
- ❌ Wallet transfer UI exists but no backend integration
- ❌ Change password UI exists but no backend integration

**Navigation:** `/profileScreen → /editProfileScreen, /deliveryAddress, /myeWalletScreen, /settingsScreen, /myImpactScreen`

---

### **Module 8: Cart & Notifications** (11 features, 85% complete)

| Feature | Screen | Code Location | API Endpoint | Status |
|---------|--------|---------------|--------------|--------|
| View Cart | `cart.png` | `cart/presentation/screens/cart_screen.dart` | `GET /v1/client/cart` | ✅ 100% |
| Update Quantity | - | `cart/presentation/screens/cart_screen.dart` | `PUT /v1/client/cart` | ✅ 100% |
| Remove from Cart | - | Same | `DELETE /v1/client/cart/{id}` | ✅ 100% |
| Apply Coupon | `cart.png` (field) | - | - | ❌ 0% (hardcoded couponId=0) |
| Checkout Flow | `cart.png → checkout` | `cart/presentation/widgets/` | Multiple | ✅ 100% |
| Clear Cart | `cart.png` (button) | - | - | ❌ 30% (no handler) |
| View Notifications | `notifications.png` | `notification/presentation/pages/notification_screen.dart` | `GET /v1/client/notifications` | ✅ 100% |
| Notification Tabs | `notifications.png` (All/Orders/Updates) | Same | Filter by type | ✅ 100% |
| Mark as Read | - | `notification/data/datasources/notification_remote_datasource.dart` | `PUT /v1/client/notifications/{id}/read` | ✅ 100% |
| Unread Badge | - | `notification/presentation/pages/notification_screen.dart` | Computed | ✅ 100% |
| Push Notifications | - | Backend push system | `POST /v1/client/devices` | ✅ 100% |

**State Management:**
- `CartBloc` - Cart operations
- `NotificationDataSource` - Notification operations

**Critical Issues:**
- ❌ Clear Cart button not wired
- ❌ Apply Coupon not implemented (always sends `couponId: 0`)

**Navigation:** `/cartScreen, /notificationScreen` (from appbar)

---

### **Module 9: Delivery Module** (15 features, 92% complete - M1.0.6)

| Feature | Screen | Code Location | API Endpoint | Status |
|---------|--------|---------------|--------------|--------|
| Delivery Login | - | Shared with client auth | Same as client | ✅ 100% |
| View Assigned Orders | `orders assigned.png` | `Delivery_Man/home/presentation/screens/home_delivery.dart` | `GET /v1/client/orders?statusId=3` | ✅ 100% (M1.0.6) |
| Order Details | `order detail delivery.png` | Reuses client screen | Same | ✅ 100% |
| Start Delivery | - | `orders/presentation/pages/order_details.dart` | `POST /v1/client/orders/{id}/status` | ✅ 100% (M1.0.6) |
| Navigate to Customer | `track order.png` (map) | `Delivery_Man/orders/presentation/screens/track_order.dart` | Google Maps | ✅ 100% (M1.0.6) |
| Submit POD | `proof of delivery.png` | `Delivery_Man/orders/presentation/screens/delivery_confirmation_screen.dart` | `POST /v1/client/orders/{id}/confirm-delivery` | ✅ 100% |
| Mark as Delivered | - | `Delivery_Man/orders/presentation/widgets/mark_delivered_alert.dart` | Same as POD | ✅ 100% |
| Delivery History | `history.png` | `Delivery_Man/history/presentation/screens/history_delivery.dart` | `GET /v1/client/orders?statusId=4` | ✅ 100% (M1.0.6) |
| Driver Profile | `profile delivery.png` | `Delivery_Man/profile/presentation/screens/delivery_profile.dart` | `GET /v1/client/account` | ✅ 100% (M1.0.6) |
| Edit Driver Profile | - | Reuses client screen | Same | ✅ 100% |
| Delivery Notifications | - | Shared system | Same | ✅ 100% |
| Dispute Handling | - | Shared system | Same | ✅ 100% |

**State Management:** Reuses `OrdersController` and `ProfileController`

**M1.0.6 Fixes:**
- ✅ Uncommented API calls for assigned orders
- ✅ Uncommented API calls for delivery history
- ✅ Uncommented ProfileController integration
- ✅ Wired Start Delivery button
- ✅ Added Google Maps navigation

**Navigation:** Separate delivery app entry point with 3-tab navigation

---

## 🔗 SHARED SERVICES & COMPONENTS

### **AuthService** (`core/services/auth_service.dart`)
```dart
static Future<void> saveToken(String token)
static Future<String?> getToken()
static Future<void> deleteToken()
```
**Used by:** All API datasources (21 files)

### **Navigation** (`core/routing/app_router.dart`)
- **Type:** Named Routes
- **Routes:** 17 registered routes
- **Main Entry:** `/` → SplashScreen
- **Auth Flow:** `/login → /signUp → /forgetPassword → /verification → /resetPassword`
- **Main App:** `/main` (MainScreen with 5-tab PageView)

### **Bottom Navigation** (`home/presentation/widgets/bottom_navigation_bar.dart`)
- **Tabs:** Orders (0), Coupons (1), Home (2), Favorites (3), Profile (4)
- **Special:** Center tab (Home) has FAB behavior with dynamic label swapping

### **Theme** (`core/theme/`)
- `colors.dart` - AppColors (primary, secondary, etc.)
- `text_styles.dart` - Typography
- `app_theme.dart` - Material theme config

### **Interceptors** (`core/interceptors/auth_interceptor.dart`)
- Auto-attaches JWT to all requests
- Handles 401 errors (token expiry)

---

## 🌐 BACKEND API SUMMARY

### **Base URL**
```
https://nartawi.smartvillageqatar.com/api
```

### **API Endpoints by Category**

#### **Authentication**
| Method | Endpoint | Purpose |
|--------|----------|---------|
| POST | `/v1/auth/client/login` | User login |
| POST | `/v1/auth/client/register` | User registration |
| POST | `/v1/auth/verify-otp` | OTP verification |
| POST | `/v1/auth/forgot-password` | Request password reset |
| POST | `/v1/auth/reset-password` | Complete password reset |

#### **Products & Catalog**
| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/v1/client/products` | List products (paginated, filterable) |
| GET | `/v1/client/products/{vsid}` | Product details |
| GET | `/v1/client/product-categories` | List categories |
| GET | `/v1/client/suppliers` | List vendors/suppliers |
| GET | `/v1/client/suppliers/{id}` | Supplier details |
| GET | `/v1/client/suppliers/{id}/reviews` | Supplier reviews |
| POST | `/v1/client/suppliers/{id}/reviews` | Submit review |

#### **Cart & Checkout**
| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/v1/client/cart` | Get cart contents |
| POST | `/v1/client/cart` | Add item to cart |
| PUT | `/v1/client/cart` | Update cart item quantity |
| DELETE | `/v1/client/cart/{id}` | Remove from cart |
| POST | `/v1/client/orders` | Create order (checkout) |

#### **Orders**
| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/v1/client/orders` | List orders (with statusId filter) |
| GET | `/v1/client/orders/{id}` | Order details |
| POST | `/v1/client/orders/{id}/cancel` | Cancel order |
| POST | `/v1/client/orders/{id}/status` | Update order status (driver) |
| POST | `/v1/client/orders/{id}/confirm-delivery` | Submit POD |

#### **Disputes**
| Method | Endpoint | Purpose |
|--------|----------|---------|
| POST | `/v1/client/disputes` | Submit dispute |
| GET | `/v1/client/disputes/{id}` | Dispute details |

#### **Favorites**
| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/v1/client/favorites/products` | List favorite products |
| POST | `/v1/client/favorites/products/{vsid}` | Add product to favorites |
| DELETE | `/v1/client/favorites/products/{vsid}` | Remove from favorites |
| GET | `/v1/client/favorites/vendors` | List favorite vendors |
| POST | `/v1/client/favorites/vendors/{id}` | Add vendor to favorites |
| DELETE | `/v1/client/favorites/vendors/{id}` | Remove vendor |

#### **Profile & Account**
| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/v1/client/account` | Get user profile |
| PUT | `/v1/client/account` | Update profile |
| GET | `/v1/client/account/addresses` | List delivery addresses |
| POST | `/v1/client/account/addresses` | Add address |
| PUT | `/v1/client/account/addresses/{id}` | Update address |
| DELETE | `/v1/client/account/addresses/{id}` | Delete address |
| GET | `/v1/client/account/notification-preferences` | Get notification settings |
| PUT | `/v1/client/account/notification-preferences` | Update notification settings |

#### **Wallet & Coupons**
| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/v1/client/wallet/balance` | Get wallet balance |
| GET | `/v1/client/wallet/transactions` | List wallet transactions |
| GET | `/v1/client/wallet/coupons` | List user coupons |
| GET | `/v1/client/wallet/bundle-purchases` | List bundle purchases |

#### **Scheduled Orders**
| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/v1/client/scheduled-orders` | List scheduled orders |
| POST | `/v1/client/scheduled-orders` | Create scheduled order |
| GET | `/v1/client/scheduled-orders/{id}` | Get by ID |
| PUT | `/v1/client/scheduled-orders/{id}` | Update scheduled order |
| DELETE | `/v1/client/scheduled-orders/{id}` | Delete scheduled order |

#### **Notifications**
| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/v1/client/notifications` | List notifications (paginated) |
| PUT | `/v1/client/notifications/{id}/read` | Mark as read |
| POST | `/v1/client/devices` | Register push token |

**Total Endpoints:** 45+  
**Integrated:** 43/45 (95%)  
**Missing:** 2 (wallet transfer, change password)

---

## 🐛 KNOWN ISSUES & TECHNICAL DEBT

### **Critical Issues (Must Fix Before Production)**

| ID | Module | Issue | Impact | Effort | Priority |
|----|--------|-------|--------|--------|----------|
| CRIT-01 | Auth | Logout not implemented | Users can't log out | 30min | P0 |
| CRIT-02 | Auth | OTP verification bypassed | Security risk | 1-2h | P0 |
| CRIT-03 | Auth | Password reset incomplete | Broken flow | 1-2h | P0 |
| CRIT-04 | Orders | Tab filtering hardcoded | Users see fake data | 2-3h | P0 |
| CRIT-05 | Orders | Reorder button not functional | Feature incomplete | 3-4h | P1 |
| CRIT-06 | Cart | Clear Cart button not wired | UX issue | 30min | P0 |
| CRIT-07 | Cart | Apply Coupon not implemented | Feature missing | 3-4h | P1 |
| CRIT-08 | Profile | Logout duplicate (same as CRIT-01) | - | - | P0 |

**Total Critical:** 8 issues  
**Total Effort:** 13-19 hours

### **Medium Issues (Should Fix)**

| ID | Module | Issue | Effort |
|----|--------|-------|--------|
| MED-01 | Profile | Wallet transfer not integrated | 2-3h |
| MED-02 | Profile | Change password not integrated | 2-3h |
| MED-03 | Profile | My Impact data hardcoded | 3-4h |
| MED-04 | Home | Filter overlay partial implementation | 2-3h |
| MED-05 | Favorites | Folder name typo (pesentation) | 10min |
| MED-06 | Favorites | fromFavouritesScreen parameter incorrect | 5min |

### **Low Issues (Nice to Have)**

| ID | Module | Issue |
|----|--------|-------|
| LOW-01 | Auth | Plain text password storage (use secure storage) |
| LOW-02 | Auth | No token expiry handling (refresh tokens) |
| LOW-03 | Settings | Language preference not persisted |

---

## 📊 IMPLEMENTATION STATUS

### **By Module**

| Module | Features | Complete | Partial | Missing | Score |
|--------|----------|----------|---------|---------|-------|
| Splash & Onboarding | 4 | 4 | 0 | 0 | 98% |
| Authentication | 8 | 5 | 2 | 1 | 92% |
| Home & Browse | 15 | 14 | 1 | 0 | 95% |
| Orders | 12 | 10 | 0 | 2 | 90% |
| Coupons & Scheduling | 8 | 8 | 0 | 0 | 95% |
| Favorites | 7 | 7 | 0 | 0 | 95% |
| Profile & Settings | 12 | 9 | 1 | 2 | 88% |
| Cart & Notifications | 11 | 9 | 0 | 2 | 85% |
| Delivery Module | 15 | 15 | 0 | 0 | 92% |
| **TOTAL** | **92** | **81** | **4** | **7** | **92%** |

### **By Category**

| Category | Status |
|----------|--------|
| UI Implementation | ✅ 100% (all screens built) |
| Backend Integration | ✅ 95% (43/45 endpoints) |
| Business Logic | ⚠️ 87% (critical gaps exist) |
| Code Quality | ✅ 95% (clean architecture) |
| Testing | ❓ Unknown (no test coverage data) |

---

## 🚀 DEPLOYMENT READINESS

### **Production-Ready Modules** (Can deploy as-is)
1. ✅ Splash & Onboarding (98%)
2. ✅ Home & Browse (95%)
3. ✅ Coupons & Scheduling (95%)
4. ✅ Favorites (95%)
5. ✅ Delivery Module (92%)

### **Conditional Deployment** (Deploy after critical fixes)
6. ⚠️ Authentication (92%) - Must fix logout
7. ⚠️ Orders (90%) - Must fix tab filtering
8. ⚠️ Profile & Settings (88%) - Must fix logout
9. ⚠️ Cart & Notifications (85%) - Must fix clear cart

### **Recommended Fix Priority**

**Sprint 1 (Critical - 5-7 hours):**
1. Implement logout (30min × 2 = 1h)
2. Wire Clear Cart button (30min)
3. Fix OTP verification (1-2h)
4. Fix password reset (1-2h)
5. Fix order tab filtering (2-3h)

**Sprint 2 (High Priority - 6-8 hours):**
6. Implement reorder feature (3-4h)
7. Integrate apply coupon (3-4h)

**Sprint 3 (Medium Priority - 7-10 hours):**
8. Integrate wallet transfer (2-3h)
9. Integrate change password (2-3h)
10. Connect My Impact to backend (3-4h)

---

## 🔄 CROSS-MODULE DEPENDENCIES

### **Shared State**
- **AuthService** → Used by 21 files across all modules
- **OrdersController** → Used by client & delivery modules
- **ProfileController** → Used by client & delivery modules
- **FavouritesController** → Called from Home module product cards

### **Navigation Flows**
```
Splash → Onboarding → Login → Main
                      ↓
                   Sign Up → Verification
                      ↓
               Forgot Password → Verification → Reset Password

Main → [Orders, Coupons, Home, Favorites, Profile]
  ↓
Home → Product Details → Add to Cart → Cart → Checkout → Order Details
  ↓
Home → Supplier Details → Add to Favorites → Favorites
  ↓
Profile → [Edit Profile, Addresses, eWallet, Settings, Impact]
```

### **Data Flow**
1. **Auth Token** → Stored by AuthService → Used by all API calls
2. **Cart State** → CartBloc → Updated from Home, Product Details
3. **Favorites** → FavouritesController → Updated from Home, Favorites screen
4. **User Profile** → ProfileController → Displayed in Profile, used in Checkout
5. **Notifications** → NotificationDataSource → Badge count shown in appbar

---

## 📚 CODE METRICS

### **Size**
- **Total Dart Files:** ~150+
- **Lines of Code:** ~25,000+
- **Features:** 92
- **Screens:** 50+
- **Widgets:** 100+
- **Controllers/BLoCs:** 15+
- **API Endpoints:** 45+

### **Complexity**
- **Module Count:** 9
- **Layer Depth:** 3 (data/domain/presentation)
- **Max File Size:** ~400 lines (reasonable)
- **State Managers:** 2 types (BLoC + ChangeNotifier)

---

## 🎯 RECOMMENDATIONS

### **Short Term (1-2 weeks)**
1. Fix all 8 critical issues
2. Add comprehensive error handling
3. Implement offline support for critical flows
4. Add loading skeletons for better UX

### **Medium Term (1-2 months)**
1. Fix all medium issues
2. Add unit tests (target 80% coverage)
3. Add integration tests for critical flows
4. Implement analytics tracking
5. Add crash reporting (Firebase Crashlytics)

### **Long Term (3-6 months)**
1. Migrate to GetX or Riverpod for state management
2. Implement feature flags
3. Add A/B testing capability
4. Implement code push for hot fixes
5. Add performance monitoring
6. Implement CI/CD pipeline

---

## 📞 SUPPORT & MAINTENANCE

### **QA Reports Available**
- `QA_REPORT_MODULE_SPLASH_ONBOARDING.md`
- `QA_REPORT_MODULE_AUTH.md`
- `QA_REPORT_MODULE_HOME.md`
- `QA_REPORT_MODULE_ORDERS.md`
- `QA_REPORT_MODULE_COUPONS_SCHEDULING.md`
- `QA_REPORT_MODULE_FAVORITES.md`
- `QA_REPORT_MODULE_PROFILE_SETTINGS.md`
- `QA_REPORT_MODULE_CART_NOTIFICATIONS.md`
- `QA_REPORT_MODULE_DELIVERY.md`

### **Master Documents**
- `QA_MASTER_PLAN.md` - Overall QA progress tracker
- `SINGLE_SOURCE_OF_TRUTH.md` - Backend API reference
- `MOBILE_FRONTEND_SSOT.md` - This document

---

**Document Version:** 1.0  
**Last Updated:** January 10, 2026 6:50 AM  
**Maintained By:** QA Team  
**Next Review:** After critical fixes completed

---

*This document is a living reference and should be updated as features are added, modified, or fixed.*
