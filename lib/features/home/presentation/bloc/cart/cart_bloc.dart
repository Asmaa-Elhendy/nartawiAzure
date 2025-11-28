import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartState.initial()) {
    on<CartAddItem>(_onAdd);
    on<CartRemoveItem>(_onRemove);
    on<CartClear>(_onClear);
  }

  void _onAdd(CartAddItem event, Emitter<CartState> emit) {
    final updated = List<Object>.from(state.cartProducts)..add(event.item);
    emit(state.copyWith(cartProducts: updated));
  }

  void _onRemove(CartRemoveItem event, Emitter<CartState> emit) {
    final updated = List<Object>.from(state.cartProducts)..remove(event.item);
    emit(state.copyWith(cartProducts: updated));
  }

  void _onClear(CartClear event, Emitter<CartState> emit) {
    emit(state.copyWith(cartProducts: []));
  }
}
