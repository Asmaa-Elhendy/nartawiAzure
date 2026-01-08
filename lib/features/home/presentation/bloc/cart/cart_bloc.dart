import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartState.initial()) {
    on<CartAddItem>(_onAdd);
    on<CartRemoveItem>(_onRemove);
    on<CartClear>(_onClear);
    on<CartUpdateQuantity>(_onUpdateQuantity);
  }

  void _onAdd(CartAddItem event, Emitter<CartState> emit) {
    final updated = List<Object>.from(state.cartProducts)..add(event.item);
    final productKey = _getProductKey(event.item);
    final quantities = Map<String, int>.from(state.productQuantities ?? {});
    
    // Check if this is the first time adding this item, set quantity to 1
    if (!quantities.containsKey(productKey)) {
      quantities[productKey] = 1;
    }
    
    emit(state.copyWith(cartProducts: updated, productQuantities: quantities));
  }

  void _onRemove(CartRemoveItem event, Emitter<CartState> emit) {
    final updated = List<Object>.from(state.cartProducts)..remove(event.item);
    final productKey = _getProductKey(event.item);
    final quantities = Map<String, int>.from(state.productQuantities ?? {});
    quantities.remove(productKey);
    emit(state.copyWith(cartProducts: updated, productQuantities: quantities));
  }

  void _onClear(CartClear event, Emitter<CartState> emit) {
    emit(state.copyWith(cartProducts: [], productQuantities: {}));
  }

  void _onUpdateQuantity(CartUpdateQuantity event, Emitter<CartState> emit) {
    final productKey = _getProductKey(event.item);
    final quantities = Map<String, int>.from(state.productQuantities ?? {});
    quantities[productKey] = event.quantity;
    emit(state.copyWith(productQuantities: quantities));
  }

  String _getProductKey(Object item) {
    if (item is Map<String, dynamic>) {
      return 'product_${item['id'] ?? 0}';
    } else if (item.toString().contains('Product')) {
      return item.toString();
    }
    return 'unknown_${item.hashCode}';
  }
}
