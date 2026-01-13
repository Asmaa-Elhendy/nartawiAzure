# Backend API Request - Delivery Profile Endpoint

**Date:** January 13, 2026  
**Requested By:** Mobile Team  
**Priority:** High  
**Status:** ⏳ Pending Implementation

---

## 📋 Overview

The Flutter mobile app's Delivery module requires dedicated profile endpoints for delivery personnel. Currently, delivery users receive **403 Forbidden** errors when accessing profile screens because they use client-only endpoints.

---

## 🎯 Required Endpoints

### **1. GET /v1/delivery/profile**
**Purpose:** Fetch delivery person's profile information

**Authentication:** Bearer token (delivery role required)

**Response Example:**
```json
{
  "id": 22,
  "username": "delivery.john",
  "fullName": "John Delivery",
  "email": "john.delivery@nartawi.com",
  "mobile": "+97412345678",
  "role": "Delivery",
  "isActive": true,
  "profileImageUrl": "https://...",
  "deliveryMetrics": {
    "totalDeliveries": 150,
    "completedToday": 8,
    "rating": 4.8,
    "activeOrders": 3
  },
  "createdAt": "2025-01-01T10:00:00Z"
}
```

**Status Codes:**
- `200 OK` - Profile retrieved successfully
- `401 Unauthorized` - Invalid/missing token
- `403 Forbidden` - User is not a delivery person
- `404 Not Found` - Profile not found

---

### **2. PUT /v1/delivery/profile**
**Purpose:** Update delivery person's profile information

**Authentication:** Bearer token (delivery role required)

**Request Body:**
```json
{
  "fullName": "John Delivery Updated",
  "email": "john.updated@nartawi.com",
  "mobile": "+97412345679",
  "profileImageUrl": "https://..."
}
```

**Response:** Same as GET response (updated profile)

**Status Codes:**
- `200 OK` - Profile updated successfully
- `400 Bad Request` - Invalid input data
- `401 Unauthorized` - Invalid/missing token
- `403 Forbidden` - User is not a delivery person
- `422 Unprocessable Entity` - Validation errors

---

## 📱 Mobile Implementation Status

### **Current Issue:**
- Screen: `lib/features/Delivery_Man/profile/presentation/screens/delivery_profile.dart`
- Uses: `ProfileController` with `/v1/client/profile` endpoint
- Result: **403 Forbidden** for delivery users

### **Temporary Workaround:**
Mobile app will use placeholder/mock data until backend endpoints are ready.

### **Implementation Plan (Post-Backend):**
1. Create `DeliveryProfileController` similar to `ProfileController`
2. Use `/v1/delivery/profile` endpoints
3. Update `delivery_profile.dart` to use new controller
4. Test with real delivery accounts

---

## 🔄 Related Orders Endpoints

**Note:** Orders endpoints are already role-aware:
- Client: `/v1/client/orders`
- Delivery: `/v1/delivery/orders` ✅ (Already implemented)

The profile endpoints should follow the same pattern.

---

## ✅ Acceptance Criteria

- [ ] GET /v1/delivery/profile returns delivery person's profile
- [ ] PUT /v1/delivery/profile updates profile successfully
- [ ] Endpoints return 403 for non-delivery users
- [ ] Response schema matches proposed structure
- [ ] All status codes handled correctly
- [ ] API documented in Swagger/OpenAPI

---

## 📝 Notes

**Database Consideration:**
- Delivery-specific fields (metrics, ratings, active orders) may need to be computed or fetched from related tables
- Consider using the same `ACCOUNT` table with role-based filtering
- Add delivery metrics views/stored procedures if needed

**Security:**
- Ensure delivery users can only access/update their own profile
- Validate role claims in JWT token
- Apply rate limiting as per other profile endpoints

---

**Contact:** Mobile Development Team  
**Expected Completion:** TBD by Backend Team
