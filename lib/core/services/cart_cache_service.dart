import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CartItem {
  final int id;
  final String name;
  final double price;
  final int quantity;
  final String? imageUrl;
  final int? supplierId;
  final String? supplierName;
  final DateTime createdAt;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    this.imageUrl,
    this.supplierId,
    this.supplierName,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
      'supplierId': supplierId,
      'supplierName': supplierName,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory CartItem.fromProductMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'] as int,
      name: map['name'] as String,
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      quantity: map['quantity'] as int? ?? 1,
      imageUrl: map['imageUrl'] as String?,
      supplierId: map['supplierId'] as int?,
      supplierName: map['supplierName'] as String?,
    );
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'] as int,
      name: map['name'] as String,
      price: (map['price'] as num).toDouble(),
      quantity: map['quantity'] as int,
      imageUrl: map['imageUrl'] as String?,
      supplierId: map['supplierId'] as int?,
      supplierName: map['supplierName'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}

class CartCacheService {
  static const String _cartKey = 'cached_cart_items';
  static const String _lastSyncKey = 'cart_last_sync';

  // Initialize cache service
  static Future<void> init() async {
    // No initialization needed for SharedPreferences
  }

  // Add item to cart cache
  static Future<void> addItem(CartItem item) async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = await getCartItems();
    
    // Check if item already exists
    final existingIndex = cartData.indexWhere((cartItem) => cartItem.id == item.id);
    
    if (existingIndex != -1) {
      // Update quantity if exists
      cartData[existingIndex] = CartItem(
        id: cartData[existingIndex].id,
        name: cartData[existingIndex].name,
        price: cartData[existingIndex].price,
        quantity: cartData[existingIndex].quantity + item.quantity,
        imageUrl: cartData[existingIndex].imageUrl,
        supplierId: cartData[existingIndex].supplierId,
        supplierName: cartData[existingIndex].supplierName,
        createdAt: cartData[existingIndex].createdAt,
      );
    } else {
      // Add new item
      cartData.add(item);
    }
    
    await saveCartItems(cartData);
    await updateLastSyncTime();
  }

  // Get all cached cart items
  static Future<List<CartItem>> getCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = prefs.getString(_cartKey) ?? '[]';
    
    try {
      final List<dynamic> cartList = json.decode(cartJson);
      return cartList.map((item) => CartItem.fromMap(item)).toList();
    } catch (e) {
      print('🛒 Error loading cart from cache: $e');
      return [];
    }
  }

  // Save cart items to cache
  static Future<void> saveCartItems(List<CartItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = json.encode(items.map((item) => item.toMap()).toList());
    await prefs.setString(_cartKey, cartJson);
  }

  // Update item quantity
  static Future<void> updateQuantity(int itemId, int quantity) async {
    final cartData = await getCartItems();
    final itemIndex = cartData.indexWhere((item) => item.id == itemId);
    
    if (itemIndex != -1) {
      cartData[itemIndex] = CartItem(
        id: cartData[itemIndex].id,
        name: cartData[itemIndex].name,
        price: cartData[itemIndex].price,
        quantity: quantity,
        imageUrl: cartData[itemIndex].imageUrl,
        supplierId: cartData[itemIndex].supplierId,
        supplierName: cartData[itemIndex].supplierName,
        createdAt: cartData[itemIndex].createdAt,
      );
      await saveCartItems(cartData);
      await updateLastSyncTime();
    }
  }

  // Remove item from cart
  static Future<void> removeItem(int itemId) async {
    final cartData = await getCartItems();
    cartData.removeWhere((item) => item.id == itemId);
    await saveCartItems(cartData);
    await updateLastSyncTime();
  }

  // Clear entire cart
  static Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cartKey);
    await updateLastSyncTime();
  }

  // Get item count
  static Future<int> getItemCount() async {
    final cartData = await getCartItems();
    int totalCount = 0;
    for (final item in cartData) {
      totalCount += item.quantity;
    }
    return totalCount;
  }

  // Get total price
  static Future<double> getTotalPrice() async {
    final cartData = await getCartItems();
    double totalPrice = 0.0;
    for (final item in cartData) {
      totalPrice += (item.price * item.quantity);
    }
    return totalPrice;
  }

  // Update last sync time
  static Future<void> updateLastSyncTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastSyncKey, DateTime.now().toIso8601String());
  }

  // Get last sync time
  static Future<DateTime?> getLastSyncTime() async {
    final prefs = await SharedPreferences.getInstance();
    final syncTimeStr = prefs.getString(_lastSyncKey);
    return syncTimeStr != null ? DateTime.parse(syncTimeStr!) : null;
  }

  // Sync with server (to be called when user logs in)
  static Future<void> syncWithServer(List<Object> serverCartItems) async {
    final List<CartItem> serverItems = serverCartItems.map((item) {
      if (item is Map<String, dynamic>) {
        return CartItem.fromProductMap(item);
      }
      return CartItem(
        id: 0,
        name: 'Unknown',
        price: 0.0,
        quantity: 0,
      );
    }).toList();
    
    await saveCartItems(serverItems);
    await updateLastSyncTime();
  }

  // Check if cache is stale (older than 1 hour)
  static Future<bool> isCacheStale() async {
    final lastSync = await getLastSyncTime();
    if (lastSync == null) return true;
    
    final now = DateTime.now();
    final difference = now.difference(lastSync!);
    return difference.inHours > 1;
  }
}
