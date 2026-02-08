# 🛒 Cart Caching System

A comprehensive local database caching system for the Flutter cart using SharedPreferences.

## 📁 Files Overview

### Core Services
- **`cart_cache_service.dart`** - Local storage and cache management
- **`cart_sync_service.dart`** - Server synchronization and merge logic
- **`cached_cart_bloc.dart`** - Enhanced BLoC with cache integration

## 🚀 Features

### ✅ Local Persistence
- Cart data survives app restarts
- Works offline with cached data
- Automatic cache initialization on app startup

### ✅ Server Synchronization
- Bidirectional sync between local cache and server
- Intelligent conflict resolution (local items override server)
- Automatic sync on user login

### ✅ Performance
- Instant local updates via BLoC
- Background sync operations
- Efficient SharedPreferences storage

### ✅ Reliability
- Error recovery with cache fallback
- Data validation and sanitization
- Comprehensive logging for debugging

## 📱 Usage

### Basic Setup
```dart
// Initialize cart cache on app startup
await CartSyncService.initializeCart();

// Use CachedCartBloc instead of CartBloc
context.read<CachedCartBloc>()
```

### Cart Operations
```dart
// Add item (auto-cached)
context.read<CachedCartBloc>().add(CartAddItem(item));

// Update quantity (auto-cached)
context.read<CachedCartBloc>().add(CartUpdateQuantity(item, quantity));

// Remove item (auto-cached)
context.read<CachedCartBloc>().add(CartRemoveItem(item));

// Clear cart (auto-cached)
context.read<CachedCartBloc>().add(CartClear());
```

### Server Sync
```dart
// Sync with server on login
await CartSyncService.syncCartWithServer();

// Upload local changes to server
await CartSyncService.uploadCartToServer();

// Merge server and local carts
final result = await CartSyncService.mergeServerAndLocalCart();

// Get sync status
final stats = await CartSyncService.getSyncStatus();
```

## 🔧 Integration

### Dependency Injection
The cart system is integrated into your app via dependency injection:

```dart
// In injection_container.dart
sl.registerFactory(() => CachedCartBloc());
```

### Existing UI Compatibility
All existing UI components automatically benefit from the cached system:
- Cart screens use `context.read<CartBloc>()` → Now uses `CachedCartBloc`
- Product cards add items → Instantly cached locally
- Cart operations persist → Survive app restarts

## 🎯 Benefits

1. **Offline Shopping** - Cart works without internet connection
2. **Data Persistence** - No lost cart items on app restart
3. **Automatic Sync** - Seamless server synchronization when online
4. **Conflict Resolution** - Local changes take priority over server
5. **Performance** - Instant local updates with background sync
6. **Error Recovery** - Graceful fallback to cached data

## 📝 Cache Storage Format

Cart items are stored in SharedPreferences as JSON:
```json
{
  "id": 1,
  "name": "Product Name",
  "price": 99.99,
  "quantity": 2,
  "imageUrl": "https://example.com/image.jpg",
  "supplierId": 123,
  "supplierName": "Supplier Name",
  "createdAt": "2024-01-01T00:00:00.000Z"
}
```

## 🔍 Debug Logging

All operations include comprehensive logging:
- `🛒` - Cache operations
- `🔄` - Sync operations  
- `✅` - Successful operations
- `🛒` - Error operations

## 🚀 Ready to Use

The cart caching system is fully implemented and ready for production use. All existing cart operations will automatically benefit from local caching and server synchronization capabilities.
