# Nartawi App - API Endpoints Documentation

## Base URL
- `https://nartawi.smartvillageqatar.com/api`

## Authentication

### ✅ Implemented
- `POST /Auth/login` - User login
- `POST /Auth/register` - User registration
- `POST /Auth/otp/send` - Send OTP for verification

### ❌ Missing
- `POST /Auth/otp/verify` - Verify OTP
- `POST /Auth/refresh-token` - Refresh access token
- `POST /Auth/forgot-password` - Request password reset
- `POST /Auth/reset-password` - Reset password with token
- `POST /Auth/change-password` - Change password while logged in

## User Profile

### ✅ Implemented
- `GET /v1/client/account` - Get user profile
- `PUT /v1/client/account` - Update user profile
- `GET /v1/client/account/addresses` - Get user addresses
- `POST /v1/client/account/addresses` - Add new address
- `DELETE /v1/client/account/addresses/{id}` - Delete address

### ❌ Missing
- `PUT /v1/client/account/addresses/{id}` - Update address
- `GET /v1/client/account/notifications` - Get user notifications
- `PUT /v1/client/account/notifications/{id}/read` - Mark notification as read
- `GET /v1/client/account/payment-methods` - Get saved payment methods
- `POST /v1/client/account/payment-methods` - Add payment method
- `DELETE /v1/client/account/payment-methods/{id}` - Remove payment method

## Products

### ✅ Implemented
- `GET /v1/client/products` - Get products list with filters
- `GET /v1/client/products/{id}` - Get product details

### ❌ Missing
- `GET /v1/client/products/{id}/reviews` - Get product reviews
- `POST /v1/client/products/{id}/reviews` - Add product review
- `GET /v1/client/products/{id}/related` - Get related products
- `GET /v1/client/products/search` - Search products
- `GET /v1/client/products/categories` - Get all product categories

## Favorites

### ✅ Implemented
- `GET /v1/client/favorites/products` - Get favorite products
- `POST /v1/client/favorites/products/{productVsId}` - Add product to favorites
- `DELETE /v1/client/favorites/products/{productVsId}` - Remove product from favorites
- `GET /v1/client/favorites/vendors` - Get favorite vendors
- `POST /v1/client/favorites/vendors/{vendorId}` - Add vendor to favorites
- `DELETE /v1/client/favorites/vendors/{vendorId}` - Remove vendor from favorites

## Cart

### ❌ Missing (All endpoints)
- `GET /v1/client/cart` - Get cart contents
- `POST /v1/client/cart/items` - Add item to cart
- `PUT /v1/client/cart/items/{itemId}` - Update cart item quantity
- `DELETE /v1/client/cart/items/{itemId}` - Remove item from cart
- `POST /v1/client/cart/apply-coupon` - Apply coupon code
- `DELETE /v1/client/cart/coupon` - Remove coupon
- `GET /v1/client/cart/shipping-methods` - Get available shipping methods
- `POST /v1/client/cart/set-shipping` - Set shipping method

## Orders

### ✅ Implemented
- `GET /v1/client/orders` - Get order history
- `GET /v1/client/orders/{id}` - Get order details
- `POST /v1/client/orders/{id}/cancel` - Cancel order

### ❌ Missing
- `POST /v1/client/orders` - Create new order
- `POST /v1/client/orders/{id}/reorder` - Reorder previous order
- `GET /v1/client/orders/{id}/tracking` - Track order status
- `POST /v1/client/orders/{id}/return` - Request return
- `POST /v1/client/orders/{id}/review` - Add order review

## Payment

### ❌ Missing (All endpoints)
- `POST /v1/client/payments/initiate` - Initialize payment
- `POST /v1/client/payments/verify` - Verify payment
- `GET /v1/client/payments/methods` - Get available payment methods
- `POST /v1/client/payments/save-card` - Save card for future payments

## Notifications

### ❌ Missing (All endpoints)
- `GET /v1/client/notifications` - Get notifications
- `PUT /v1/client/notifications/{id}/read` - Mark as read
- `DELETE /v1/client/notifications/{id}` - Delete notification
- `POST /v1/client/notifications/preferences` - Update notification preferences

## Support

### ❌ Missing (All endpoints)
- `POST /v1/client/support/tickets` - Create support ticket
- `GET /v1/client/support/tickets` - Get support tickets
- `GET /v1/client/support/tickets/{id}` - Get ticket details
- `POST /v1/client/support/tickets/{id}/messages` - Send message in ticket
- `GET /v1/client/faqs` - Get FAQ list
- `GET /v1/client/contact-info` - Get contact information

## Additional Missing Functionality

1. **Search & Filter**
   - Advanced product search with filters
   - Search history
   - Recent searches

2. **Reviews & Ratings**
   - Product reviews listing
   - Review submission
   - Review with photos
   - Review helpfulness votes

3. **Wishlist**
   - Create multiple wishlists
   - Share wishlist
   - Move items between wishlist and cart

4. **Social Features**
   - Social login (Google, Apple, Facebook)
   - Share products on social media
   - Referral program

5. **Analytics**
   - Recently viewed products
   - Recommended products
   - Popular products
   - Browsing history

6. **Multi-language Support**
   - Language switching
   - RTL support
   - Translated content

## Implementation Priority

### High Priority (Core Functionality)
1. Complete cart functionality
2. Order creation and payment flow
3. Search functionality
4. Product reviews

### Medium Priority
1. User preferences
2. Notification system
3. Support tickets
4. Wishlist management

### Low Priority
1. Social features
2. Advanced analytics
3. Multi-language support
