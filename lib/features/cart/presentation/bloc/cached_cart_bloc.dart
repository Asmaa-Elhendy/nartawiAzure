import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/cart_cache_service.dart';
import '../../../home/presentation/bloc/cart/cart_event.dart';
import '../../../home/presentation/bloc/cart/cart_state.dart';

class CachedCartBloc extends Bloc<CartEvent, CartState> {
  CachedCartBloc() : super(CartState.initial()) {
    on<CartAddItem>(_onAdd);
    on<CartRemoveItem>(_onRemove);
    on<CartClear>(_onClear);
    on<CartUpdateQuantity>(_onUpdateQuantity);
    
    // Initialize cart from cache on startup
    _initializeFromCache();
  }

  Future<void> _initializeFromCache() async {
    try {
      final cachedItems = await CartCacheService.getCartItems();
      if (cachedItems.isNotEmpty) {
        final cartProducts = cachedItems.map((item) => item.toMap()).toList();
        final quantities = <String, int>{};
        
        for (final item in cachedItems) {
          quantities['product_${item.id}'] = item.quantity;
        }
        
        emit(CartState(
          cartProducts: cartProducts,
          productQuantities: quantities,
        ));
        
        print('🛒 Cart loaded from cache: ${cachedItems.length} items');
      }
    } catch (e) {
      print('🛒 Error loading cart from cache: $e');
    }
  }

  Future<void> _onAdd(CartAddItem event, Emitter<CartState> emit) async {
    try {
      // Convert event item to CartItem
      CartItem cartItem;
      if (event.item is Map<String, dynamic>) {
        cartItem = CartItem.fromProductMap(event.item as Map<String, dynamic>);
      } else {
        cartItem = CartItem(
          id: 0,
          name: 'Unknown',
          price: 0.0,
          quantity: 1,
        );
      }

      // Add to cache
      await CartCacheService.addItem(cartItem);
      
      // Update state
      final updated = List<Object>.from(state.cartProducts)..add(event.item);
      final productKey = _getProductKey(event.item);
      final quantities = Map<String, int>.from(state.productQuantities ?? {});
      
      if (!quantities.containsKey(productKey)) {
        quantities[productKey] = cartItem.quantity;
      }
      
      emit(state.copyWith(cartProducts: updated, productQuantities: quantities));
      
      print('✅ Item added to cart and cache: ${cartItem.name}');
    } catch (e) {
      print('🛒 Error adding item to cart: $e');
    }
  }

  Future<void> _onRemove(CartRemoveItem event, Emitter<CartState> emit) async {
    try {
      // Remove from cache
      final productId = _getProductIdFromItem(event.item);
      if (productId != null) {
        await CartCacheService.removeItem(productId);
      }
      
      // Update state
      final updated = List<Object>.from(state.cartProducts)..remove(event.item);
      final productKey = _getProductKey(event.item);
      final quantities = Map<String, int>.from(state.productQuantities ?? {});
      quantities.remove(productKey);
      
      emit(state.copyWith(cartProducts: updated, productQuantities: quantities));
      
      print('✅ Item removed from cart and cache: $productId');
    } catch (e) {
      print('🛒 Error removing item from cart: $e');
    }
  }

  Future<void> _onClear(CartClear event, Emitter<CartState> emit) async {
    try {
      // Clear cache
      await CartCacheService.clearCart();
      
      // Clear state
      emit(state.copyWith(cartProducts: [], productQuantities: {}));
      
      print('✅ Cart cleared from cache and state');
    } catch (e) {
      print('🛒 Error clearing cart: $e');
    }
  }

  Future<void> _onUpdateQuantity(CartUpdateQuantity event, Emitter<CartState> emit) async {
    try {
      // Update quantity in cache
      final productId = _getProductIdFromItem(event.item);
      if (productId != null) {
        await CartCacheService.updateQuantity(productId, event.quantity);
      }
      
      // Update state
      final quantities = Map<String, int>.from(state.productQuantities ?? {});
      quantities['product_$productId'] = event.quantity;
      
      emit(state.copyWith(productQuantities: quantities));
      
      print('✅ Item quantity updated in cache and state: $productId -> ${event.quantity}');
    } catch (e) {
      print('🛒 Error updating item quantity: $e');
    }
  }

  String _getProductKey(Object item) {
    if (item is Map<String, dynamic>) {
      final id = item['id'] as int?;
      return id != null ? 'product_$id' : 'product_0';
    }
    return 'product_0';
  }

  int? _getProductIdFromItem(Object item) {
    if (item is Map<String, dynamic>) {
      return item['id'] as int?;
    }
    return null;
  }

  // Sync cart with server
  Future<void> syncWithServer(List<Object> serverCartItems) async {
    try {
      await CartCacheService.syncWithServer(serverCartItems);
      
      // Convert server items to cart format
      final cartProducts = serverCartItems.map((item) => item).toList();
      final quantities = <String, int>{};
      
      for (final item in serverCartItems) {
        if (item is Map<String, dynamic>) {
          final id = item['id'] as int? ?? 0;
          quantities['product_$id'] = 1; // Default quantity
        }
      }
      
      emit(CartState(
        cartProducts: cartProducts,
        productQuantities: quantities,
      ));
      
      print('✅ Cart synced with server: ${serverCartItems.length} items');
    } catch (e) {
      print('🛒 Error syncing cart with server: $e');
    }
  }

  // Check if cache needs refresh
  Future<bool> needsRefresh() async {
    return await CartCacheService.isCacheStale();
  }

  // Get cart statistics
  Future<Map<String, dynamic>> getCartStats() async {
    final itemCount = await CartCacheService.getItemCount();
    final totalPrice = await CartCacheService.getTotalPrice();
    final lastSync = await CartCacheService.getLastSyncTime();
    
    return {
      'itemCount': itemCount,
      'totalPrice': totalPrice,
      'lastSync': lastSync?.toIso8601String(),
      'needsRefresh': await needsRefresh(),
    };
  }
}
