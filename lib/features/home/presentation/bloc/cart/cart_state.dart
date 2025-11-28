import 'package:equatable/equatable.dart';

class CartState extends Equatable {
  final List<Object> cartProducts;

  const CartState({required this.cartProducts});

  factory CartState.initial() => const CartState(cartProducts: []);

  CartState copyWith({List<Object>? cartProducts}) {
    return CartState(cartProducts: cartProducts ?? this.cartProducts);
  }

  @override
  List<Object?> get props => [cartProducts];
}
