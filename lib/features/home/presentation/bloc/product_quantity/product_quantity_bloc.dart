import 'package:flutter_bloc/flutter_bloc.dart';
import 'product_quantity_event.dart';
import 'product_quantity_state.dart';

class CalculateProductPrice {
  double call(int quantity, {double basePrice = 100.0}) {
    return basePrice * quantity;
  }
}

class ProductQuantityBloc extends Bloc<ProductQuantityEvent, ProductQuantityState> {
  final CalculateProductPrice calculateProductPrice;
  final double basePrice;

  ProductQuantityBloc({
    required this.calculateProductPrice,
    this.basePrice = 100.0,
  }) : super(ProductQuantityState.initial()) {
    on<IncreaseQuantity>(_onIncreaseQuantity);
    on<DecreaseQuantity>(_onDecreaseQuantity);
    on<QuantityChanged>(_onQuantityChanged);
    on<QuantityEditingComplete>(_onQuantityEditingComplete);
  }

  void _onIncreaseQuantity(
    IncreaseQuantity event,
    Emitter<ProductQuantityState> emit,
  ) {
    final current = int.tryParse(state.quantity) ?? 1;
    final newQuantity = (current + 1).toString();
    _updateQuantity(emit, newQuantity);
  }

  void _onDecreaseQuantity(
    DecreaseQuantity event,
    Emitter<ProductQuantityState> emit,
  ) {
    final current = int.tryParse(state.quantity) ?? 1;
    if (current > 1) {
      final newQuantity = (current - 1).toString();
      _updateQuantity(emit, newQuantity);
    }
  }

  void _onQuantityChanged(
    QuantityChanged event,
    Emitter<ProductQuantityState> emit,
  ) {
    if (event.value.isNotEmpty) {
      _updateQuantity(emit, event.value);
    }
  }

  void _onQuantityEditingComplete(
    QuantityEditingComplete event,
    Emitter<ProductQuantityState> emit,
  ) {
    if (state.quantity.isEmpty) {
      _updateQuantity(emit, '1');
    }
  }

  void _updateQuantity(Emitter<ProductQuantityState> emit, String newQuantity) {
    final quantity = int.tryParse(newQuantity) ?? 1;
    final price = calculateProductPrice(quantity, basePrice: basePrice);
    emit(state.copyWith(
      quantity: quantity.toString(),
      price: price,
    ));
  }
}
