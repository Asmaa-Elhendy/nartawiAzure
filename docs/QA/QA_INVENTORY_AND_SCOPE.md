# 📋 QA INVENTORY & SCOPE
## Mobile Frontend Feature Inventory and Testing Scope

**Created:** January 9, 2026 10:16 PM  
**Phase:** Phase A - Quick Scan  
**Purpose:** Complete inventory of features from UI designs for QA validation

---

## 🎯 INVENTORY OVERVIEW

### **Module Summary**

| # | Module | UI Screens | Features Identified | Priority | Status |
|---|--------|------------|---------------------|----------|--------|
| 1 | Splash & Onboarding | 4 | 4 | P1 | ✅ Implemented |
| 2 | Authentication | 5 | 8 | P1 | ✅ Implemented |
| 3 | Home & Browse | 12 | 15 | P1 | ✅ Implemented |
| 4 | Orders | 5 | 12 | P1 | ✅ Implemented |
| 5 | Coupons & Scheduling | 10 | 8 | P2 | ⚠️ Partial |
| 6 | Favorites | 2 | 3 | P2 | ✅ Implemented |
| 7 | Profile & Settings | 9 | 12 | P2 | ✅ Implemented |
| 8 | Cart & Notifications | 4 | 6 | P1 | ✅ Implemented |
| 9 | Delivery Module | 18 | 15 | P1 | ✅ Implemented |

**Total Screens:** 69 UI design files  
**Total Features:** 83 identified features  
**Implementation Status:** ~85% complete (estimated)

---

## 📱 MODULE 1: SPLASH & ONBOARDING

**Priority:** P1 (Core User Flow)  
**UI Screens Folder:** `1-splash screen/`  
**Screen Count:** 4

### **UI Design Files**
1. `splash.png` - Main splash screen
2. `splash 1.png` - Splash screen variant 1
3. `splash 2.png` - Splash screen variant 2
4. `splash 3.png` - Splash screen variant 3

### **Features Identified**

| Feature ID | Feature Name | Description | UI Reference | Implementation Status |
|------------|--------------|-------------|--------------|----------------------|
| SP-001 | App Launch Splash | Initial app loading screen | splash.png | ✅ To Verify |
| SP-002 | Onboarding Flow | Multi-step onboarding slides | splash 1-3.png | ✅ To Verify |
| SP-003 | First-Time User Detection | Detect and show onboarding only once | N/A | ✅ To Verify |
| SP-004 | Skip Onboarding | Allow users to skip onboarding | N/A | ✅ To Verify |

### **Validation Checklist**
- [ ] Splash screen displays correctly on launch
- [ ] Onboarding slides show for first-time users
- [ ] Onboarding can be skipped
- [ ] Navigation to login/home works correctly
- [ ] Animations and transitions smooth
- [ ] Branding elements match design

---

## 🔐 MODULE 2: AUTHENTICATION

**Priority:** P1 (Core User Flow)  
**UI Screens Folder:** `2-login/`  
**Screen Count:** 5

### **UI Design Files**
1. `login.png` - Login screen
2. `signup.png` - Main signup screen
3. `signup-1.png` - Signup variant
4. `forget password.png` - Password recovery
5. `Verification.png` - OTP verification

### **Features Identified**

| Feature ID | Feature Name | Description | UI Reference | Implementation Status |
|------------|--------------|-------------|--------------|----------------------|
| AUTH-001 | User Login | Email/phone + password login | login.png | ✅ To Verify |
| AUTH-002 | User Registration | New user signup | signup.png | ✅ To Verify |
| AUTH-003 | Phone/Email Selection | Choose auth method | signup-1.png | ✅ To Verify |
| AUTH-004 | OTP Verification | Verify phone/email with code | Verification.png | ✅ To Verify |
| AUTH-005 | Forgot Password | Password recovery flow | forget password.png | ✅ To Verify |
| AUTH-006 | Remember Me | Persistent login option | login.png | ✅ To Verify |
| AUTH-007 | Auto-login | Stored credentials auto-login | N/A | ✅ To Verify |
| AUTH-008 | Logout | User logout functionality | N/A | ✅ To Verify |

### **Validation Checklist**
- [ ] Login with valid credentials succeeds
- [ ] Login with invalid credentials shows error
- [ ] Signup flow completes successfully
- [ ] OTP sent and verified correctly
- [ ] Forgot password flow works end-to-end
- [ ] Remember me persists session
- [ ] Input validation works (email format, password strength)
- [ ] Error messages clear and helpful

---

## 🏠 MODULE 3: HOME & BROWSE

**Priority:** P1 (Core User Flow)  
**UI Screens Folder:** `3-Home/`  
**Screen Count:** 12

### **UI Design Files**
1. `Home.png` - Main home screen
2. `all products.png` - All products listing
3. `all products-1.png` - Products listing variant
4. `all water suppliers.png` - Suppliers listing
5. `Product Details.png` - Product details main
6. `Product Details-1.png` - Product details variant
7. `popular categories.png` - Categories grid
8. `popular categories-1.png` - Categories variant
9. `popular categories-filter.png` - Category filters
10. `featured stores-product1.png` - Store product listing
11. `featured stores-product1-1.png` - Store variant
12. `featured stores-product1-reviews.png` - Product reviews

### **Features Identified**

| Feature ID | Feature Name | Description | UI Reference | Implementation Status |
|------------|--------------|-------------|--------------|----------------------|
| HOME-001 | Home Dashboard | Main landing screen | Home.png | ✅ To Verify |
| HOME-002 | Product Listing | Browse all products | all products.png | ✅ To Verify |
| HOME-003 | Product Search | Search products by keyword | all products.png | ✅ To Verify |
| HOME-004 | Product Filters | Filter by category, price, etc. | popular categories-filter.png | ✅ To Verify |
| HOME-005 | Product Details | View product details | Product Details.png | ✅ To Verify |
| HOME-006 | Add to Cart | Add product to cart | Product Details.png | ✅ To Verify |
| HOME-007 | Supplier Listing | Browse water suppliers | all water suppliers.png | ✅ To Verify |
| HOME-008 | Category Browsing | Browse by category | popular categories.png | ✅ To Verify |
| HOME-009 | Featured Stores | View featured store products | featured stores-product1.png | ✅ To Verify |
| HOME-010 | Product Reviews | View customer reviews | featured stores-product1-reviews.png | ✅ To Verify |
| HOME-011 | Add to Favorites | Save products to favorites | Product Details.png | ✅ To Verify |
| HOME-012 | Product Quantity Selector | Select quantity before add | Product Details.png | ✅ To Verify |
| HOME-013 | Bundle Products | View and purchase bundles | N/A (Not in designs) | ⚠️ To Verify |
| HOME-014 | Store Details | View store information | featured stores-product1.png | ✅ To Verify |
| HOME-015 | Pagination/Infinite Scroll | Navigate product lists | all products.png | ✅ To Verify |

### **Validation Checklist**
- [ ] Home screen loads with all sections
- [ ] Product listing displays correctly
- [ ] Search works with keyword input
- [ ] Filters apply correctly
- [ ] Product details show all information
- [ ] Add to cart works and updates cart count
- [ ] Supplier listing displays correctly
- [ ] Categories display and navigate correctly
- [ ] Featured stores display correctly
- [ ] Reviews display with ratings
- [ ] Add to favorites works
- [ ] Quantity selector works
- [ ] Bundle products implemented (backend exists)

---

## 📦 MODULE 4: ORDERS

**Priority:** P1 (Core User Flow)  
**UI Screens Folder:** `4-orders/`  
**Screen Count:** 5

### **UI Design Files**
1. `orders.png` - Order list main
2. `orders-1.png` - Order list variant
3. `Order Details Pending.png` - Pending order details
4. `Order Details delivered.png` - Delivered order details
5. `Order Details cnceled.png` - Cancelled order details

### **Features Identified**

| Feature ID | Feature Name | Description | UI Reference | Implementation Status |
|------------|--------------|-------------|--------------|----------------------|
| ORD-001 | Order History | View all past orders | orders.png | ✅ To Verify |
| ORD-002 | Order Filtering | Filter by status (All, Pending, etc.) | orders.png | ✅ To Verify |
| ORD-003 | Order Details - Pending | View pending order details | Order Details Pending.png | ✅ To Verify |
| ORD-004 | Order Details - Delivered | View delivered order details | Order Details delivered.png | ✅ To Verify |
| ORD-005 | Order Details - Cancelled | View cancelled order details | Order Details cnceled.png | ✅ To Verify |
| ORD-006 | Order Status Tracking | Track order progress | Order Details Pending.png | ✅ To Verify |
| ORD-007 | Reorder | Quickly reorder past orders | orders.png | ⚠️ To Verify |
| ORD-008 | Cancel Order | Cancel pending orders | Order Details Pending.png | ✅ Implemented (M1.0.5) |
| ORD-009 | POD Display | View proof of delivery photo | Order Details delivered.png | ✅ Implemented (M1.0.5) |
| ORD-010 | Submit Dispute | Dispute delivered order | Order Details delivered.png | ✅ Implemented (M1.0.5) |
| ORD-011 | View Dispute Status | Check dispute resolution | N/A | ✅ Implemented (M1.0.5) |
| ORD-012 | Leave Review | Rate and review order | Order Details delivered.png | ✅ To Verify |

### **Validation Checklist**
- [ ] Order history displays all orders
- [ ] Filtering by status works
- [ ] Order details show correct information per status
- [ ] Order status badges display correctly
- [ ] Payment status displays correctly
- [ ] Delivery information displays correctly
- [ ] Reorder functionality works
- [ ] Cancel order works with confirmation (M1.0.5)
- [ ] POD modal displays correctly (M1.0.5)
- [ ] Dispute submission works (M1.0.5)
- [ ] Dispute status displays correctly (M1.0.5)
- [ ] Leave review opens modal and submits

---

## 🎫 MODULE 5: COUPONS & SCHEDULING

**Priority:** P2 (Supporting Features)  
**UI Screens Folder:** `5-coupons/`  
**Screen Count:** 10

### **UI Design Files**
1. `coupons.png` - Coupons listing
2. `couponscompany-detail.png` - Coupon company details
3. `Preferred times for refilling.png` - Schedule preferences
4. `Frame 1171275551.png` - Schedule time slot selection
5. `Frame 1171275552.png` - Schedule confirmation
6. `Frame 1171275554.png` - Schedule success
7. `Frame 1171275557.png` - Schedule variant
8. `delivery-photo.png` - POD display (M1.0.5)
9. `dispute.png` - Dispute submission (M1.0.5)
10. `dispute resolved.png` - Dispute status (M1.0.5)

### **Features Identified**

| Feature ID | Feature Name | Description | UI Reference | Implementation Status |
|------------|--------------|-------------|--------------|----------------------|
| CPN-001 | View Coupons | Browse available coupons | coupons.png | ✅ To Verify |
| CPN-002 | Apply Coupon | Apply coupon to order | coupons.png | ✅ To Verify |
| CPN-003 | Coupon Company Details | View coupon provider info | couponscompany-detail.png | ✅ To Verify |
| CPN-004 | Schedule Refill Times | Set preferred delivery times | Preferred times for refilling.png | ⚠️ To Verify |
| CPN-005 | Select Time Slots | Choose specific time slots | Frame 1171275551.png | ⚠️ To Verify |
| CPN-006 | Confirm Schedule | Confirm scheduled order | Frame 1171275552.png | ⚠️ To Verify |
| CPN-007 | Schedule Success | View schedule confirmation | Frame 1171275554.png | ⚠️ To Verify |
| CPN-008 | Scheduled Orders List | View all scheduled orders | N/A | ⚠️ To Verify |

**Note:** POD and Dispute features (delivery-photo.png, dispute.png, dispute resolved.png) are documented in MODULE 4: ORDERS as M1.0.5 features.

### **Validation Checklist**
- [ ] Coupons display correctly
- [ ] Coupon filtering works
- [ ] Apply coupon reduces cart total
- [ ] Coupon company details display
- [ ] Schedule refill preferences can be set
- [ ] Time slot selection works
- [ ] Schedule confirmation displays correctly
- [ ] Scheduled orders created successfully

---

## ❤️ MODULE 6: FAVORITES

**Priority:** P2 (Supporting Features)  
**UI Screens Folder:** `6-favorite/`  
**Screen Count:** 2

### **UI Design Files**
1. `favorites.png` - Favorites list main
2. `favorites-1.png` - Favorites list variant

### **Features Identified**

| Feature ID | Feature Name | Description | UI Reference | Implementation Status |
|------------|--------------|-------------|--------------|----------------------|
| FAV-001 | View Favorites | Browse saved favorite products | favorites.png | ✅ To Verify |
| FAV-002 | Remove from Favorites | Unfavorite products | favorites.png | ✅ To Verify |
| FAV-003 | Add to Cart from Favorites | Quick add to cart | favorites.png | ✅ To Verify |

### **Validation Checklist**
- [ ] Favorites list displays correctly
- [ ] Remove from favorites works
- [ ] Add to cart from favorites works
- [ ] Empty state displays if no favorites
- [ ] Favorite sync across app

---

## 👤 MODULE 7: PROFILE & SETTINGS

**Priority:** P2 (Supporting Features)  
**UI Screens Folder:** `7-profile/`  
**Screen Count:** 9

### **UI Design Files**
1. `profile.png` - Profile main screen
2. `profile-1.png` - Profile variant
3. `edit profile.png` - Edit profile form
4. `settings.png` - Settings main
5. `settings-Change Password.png` - Change password form
6. `delivery addresses.png` - Manage delivery addresses
7. `My eWallet.png` - Wallet main screen
8. `My eWallet-1.png` - Wallet variant
9. `my impact.png` - Environmental impact tracker

### **Features Identified**

| Feature ID | Feature Name | Description | UI Reference | Implementation Status |
|------------|--------------|-------------|--------------|----------------------|
| PRF-001 | View Profile | Display user profile info | profile.png | ✅ To Verify |
| PRF-002 | Edit Profile | Update profile information | edit profile.png | ✅ To Verify |
| PRF-003 | Change Password | Update account password | settings-Change Password.png | ✅ To Verify |
| PRF-004 | Manage Addresses | Add/edit delivery addresses | delivery addresses.png | ✅ To Verify |
| PRF-005 | View Wallet | Display wallet balance | My eWallet.png | ✅ To Verify |
| PRF-006 | Wallet Transactions | View transaction history | My eWallet-1.png | ✅ To Verify |
| PRF-007 | Top Up Wallet | Add funds to wallet | My eWallet.png | ⚠️ To Verify |
| PRF-008 | My Impact | View environmental impact stats | my impact.png | ✅ To Verify |
| PRF-009 | Settings | App settings and preferences | settings.png | ✅ To Verify |
| PRF-010 | Notification Preferences | Manage notification settings | settings.png | ✅ To Verify |
| PRF-011 | Language Selection | Change app language | settings.png | ✅ To Verify |
| PRF-012 | Logout | Sign out of account | profile.png | ✅ To Verify |

### **Validation Checklist**
- [ ] Profile displays user information
- [ ] Edit profile updates successfully
- [ ] Change password works
- [ ] Add/edit/delete addresses works
- [ ] Wallet balance displays correctly
- [ ] Transaction history displays
- [ ] Top up wallet functionality works
- [ ] Environmental impact displays stats
- [ ] Settings save correctly
- [ ] Notification preferences save
- [ ] Language change works
- [ ] Logout clears session

---

## 🛒 MODULE 8: CART & NOTIFICATIONS

**Priority:** P1 (Core User Flow)  
**UI Screens Folder:** `8-cart & Notifications/`  
**Screen Count:** 4

### **UI Design Files**
1. `your cart.png` - Cart main screen
2. `your cart-1.png` - Cart variant
3. `Notifications.png` - Notifications main
4. `Notifications-1.png` - Notifications variant

### **Features Identified**

| Feature ID | Feature Name | Description | UI Reference | Implementation Status |
|------------|--------------|-------------|--------------|----------------------|
| CRT-001 | View Cart | Display cart items | your cart.png | ✅ To Verify |
| CRT-002 | Update Quantity | Change item quantities | your cart.png | ✅ To Verify |
| CRT-003 | Remove from Cart | Delete cart items | your cart.png | ✅ To Verify |
| CRT-004 | Apply Coupon | Add coupon to cart | your cart.png | ✅ To Verify |
| CRT-005 | Checkout | Proceed to payment | your cart.png | ✅ To Verify |
| CRT-006 | View Notifications | Display all notifications | Notifications.png | ✅ To Verify |

### **Validation Checklist**
- [ ] Cart displays all items
- [ ] Update quantity works
- [ ] Remove from cart works
- [ ] Cart total calculates correctly
- [ ] Coupon applies and updates total
- [ ] Checkout navigates correctly
- [ ] Notifications display correctly
- [ ] Notification badges update
- [ ] Mark as read works

---

## 🚚 MODULE 9: DELIVERY MODULE (Driver Side)

**Priority:** P1 (Core Business Flow)  
**UI Screens Folder:** `9-Delivery Module/`  
**Screen Count:** 18

### **UI Design Files**
1. `1.login.png` - Delivery login
2. `2.forget password.png` - Delivery password recovery
3. `3.Verification.png` - Delivery OTP verification
4. `4.signup.png` - Delivery driver signup
5. `5.orders.png` - Delivery orders list
6. `6.1.Order Details pending.png` - Pending order (driver)
7. `6.2.Order Details delivered.png` - Delivered order (driver)
8. `6.3.Order Details canceled.png` - Cancelled order (driver)
9. `6.4.Order Details disputed.png` - Disputed order (driver)
10. `6.5.Order Details on the way.png` - In-transit order (driver)
11. `7.confirmation.png` - Delivery confirmation variant 1
12. `8.confirmation.png` - Delivery confirmation variant 2
13. `9.confirmation.png` - Delivery confirmation variant 3
14. `10.delivery confirmation.png` - POD submission screen
15. `11.delivery confirmation.png` - POD submission variant
16. `12.profile.png` - Delivery driver profile
17. `13.edit profile.png` - Edit driver profile
18. `14.History.png` - Delivery history
19. `15.Notifications.png` - Delivery notifications

### **Features Identified**

| Feature ID | Feature Name | Description | UI Reference | Implementation Status |
|------------|--------------|-------------|--------------|----------------------|
| DEL-001 | Delivery Login | Driver authentication | 1.login.png | ✅ To Verify |
| DEL-002 | Delivery Signup | Driver registration | 4.signup.png | ✅ To Verify |
| DEL-003 | Driver OTP Verification | Verify driver account | 3.Verification.png | ✅ To Verify |
| DEL-004 | View Assigned Orders | See orders to deliver | 5.orders.png | ✅ To Verify |
| DEL-005 | Order Details (All Statuses) | View order details by status | 6.1-6.5.png | ✅ To Verify |
| DEL-006 | Start Delivery | Change status to "On The Way" | 6.1.png | ✅ To Verify |
| DEL-007 | Navigate to Customer | Open maps for navigation | N/A | ✅ To Verify |
| DEL-008 | Submit POD | Capture delivery photo with GPS | 10-11.delivery confirmation.png | ✅ Implemented (M1.0.5) |
| DEL-009 | Delivery Confirmation | Confirm successful delivery | 7-9.confirmation.png | ✅ To Verify |
| DEL-010 | Mark as Delivered | Complete delivery process | 10.delivery confirmation.png | ✅ Implemented (M1.0.5) |
| DEL-011 | View Delivery History | See past deliveries | 14.History.png | ✅ To Verify |
| DEL-012 | Driver Profile | View driver information | 12.profile.png | ✅ To Verify |
| DEL-013 | Edit Driver Profile | Update driver info | 13.edit profile.png | ✅ To Verify |
| DEL-014 | Delivery Notifications | Receive order notifications | 15.Notifications.png | ✅ To Verify |
| DEL-015 | Dispute Handling | View disputed orders | 6.4.Order Details disputed.png | ✅ To Verify |

### **Validation Checklist**
- [ ] Delivery login works
- [ ] Driver signup completes
- [ ] OTP verification works
- [ ] Assigned orders display
- [ ] Order details show correctly per status
- [ ] Start delivery changes status
- [ ] Navigation to customer works
- [ ] POD submission with GPS works (M1.0.5)
- [ ] Delivery confirmation works
- [ ] Mark as delivered completes order (M1.0.5)
- [ ] Delivery history displays
- [ ] Driver profile displays
- [ ] Edit profile updates
- [ ] Notifications display
- [ ] Disputed orders viewable

---

## 🎯 TESTING SCOPE & PRIORITIES

### **Phase B: Deep Dive Priority 1 Modules**
**Estimated Time:** 8-12 hours

1. **MODULE 2: Authentication** (2-3 hours)
   - Critical for all user access
   - Must be rock-solid
   - Security validation required

2. **MODULE 3: Home & Browse** (3-4 hours)
   - Primary user experience
   - Most complex UI interactions
   - Search, filter, and navigation validation

3. **MODULE 4: Orders** (3-4 hours)
   - Core business functionality
   - Newly added M1.0.5 features
   - Multiple status states to validate

4. **MODULE 8: Cart & Notifications** (2-3 hours)
   - Critical for checkout flow
   - Payment integration validation

5. **MODULE 9: Delivery Module** (2-3 hours)
   - Business-critical for operations
   - GPS and POD validation (M1.0.5)

---

### **Phase C: Light Review Priority 2-3 Modules**
**Estimated Time:** 4-6 hours

6. **MODULE 1: Splash & Onboarding** (30 mins)
   - Simple screens, quick validation

7. **MODULE 5: Coupons & Scheduling** (2-3 hours)
   - Scheduled orders implementation status
   - Coupon application logic

8. **MODULE 6: Favorites** (30 mins)
   - Simple CRUD operations

9. **MODULE 7: Profile & Settings** (2-3 hours)
   - Multiple sub-features
   - Wallet functionality validation

---

## 📊 GAP ANALYSIS PREVIEW

### **Known Implementation Gaps**
Based on previous work and documentation:

1. **Scheduled Orders (Module 5)**
   - Backend API exists
   - Frontend implementation status unknown
   - **Action:** Validate in Phase C

2. **Bundle Products (Module 3)**
   - Backend API exists
   - No dedicated UI screens
   - Should use existing product listing with filters
   - **Action:** Validate in Phase B

3. **Reorder Functionality (Module 4)**
   - UI hint exists in designs
   - Implementation status unknown
   - **Action:** Validate in Phase B

4. **Wallet Top-Up (Module 7)**
   - UI exists
   - Payment gateway integration status unknown
   - **Action:** Validate in Phase C

5. **Real-time Features**
   - Order tracking real-time updates
   - Notification push system
   - **Action:** Validate in Phase B & C

---

## 📁 VALIDATION SOURCES

### **Documentation to Cross-Reference**

1. **UI Designs**
   - Location: `C:\Flutter Nartawi\Nartawi_Mobile\UI Screens\`
   - Status: ✅ Complete inventory

2. **Backend SSoT**
   - Location: `C:\Users\DELL\Downloads\SINGLE_SOURCE_OF_TRUTH.md`
   - Purpose: Validate API endpoints and data schemas

3. **Backend Responses**
   - Location: `C:\Flutter Nartawi\Nartawi_Mobile\docs\COMPREHENSIVE_BACKEND_INQUIRIES.md`
   - Purpose: Validate API response formats and business logic

4. **Architecture Docs**
   - `DUAL_ROLE_ARCHITECTURE.md` - Dual customer/delivery architecture
   - `M1.0.5_REVISED_IMPLEMENTATION_GUIDE.md` - Latest feature specs

5. **Code Implementation**
   - Location: `C:\Flutter Nartawi\Nartawi_Mobile\lib\features\`
   - Structure: Feature-based architecture

---

## 🚦 NEXT STEPS

### **Immediate Actions**

1. **Review & Approve Inventory**
   - User reviews this inventory
   - Confirms scope and priorities
   - Approves Phase B modules

2. **Start Phase B: Deep Dive**
   - Begin with MODULE 2: Authentication
   - Use detailed validation checklist
   - Create module report: `QA_REPORT_MODULE_AUTH.md`

3. **Continue Sequentially**
   - Complete Priority 1 modules first
   - Generate reports as we go
   - Identify critical issues immediately

---

## ✅ INVENTORY COMPLETION STATUS

**Phase A: COMPLETE** ✅

- [x] Scanned all UI screen folders
- [x] Identified 69 UI design files
- [x] Mapped to 9 major modules
- [x] Identified 83 features
- [x] Prioritized modules (P1/P2)
- [x] Created validation checklists
- [x] Identified known gaps
- [x] Ready for Phase B

**Total Time:** ~60 minutes

---

## 📞 READY TO PROCEED

**Awaiting user approval to begin Phase B: Deep Dive Priority 1 Modules**

Which module should we start with?
- **Recommended:** MODULE 2: Authentication (foundation for everything)
- **Alternative:** MODULE 4: Orders (validate M1.0.5 features)
- **Alternative:** MODULE 3: Home & Browse (primary user experience)

---

**Document Version:** 1.0  
**Status:** ✅ Phase A Complete - Ready for Phase B  
**Next Document:** `QA_REPORT_MODULE_[NAME].md`
