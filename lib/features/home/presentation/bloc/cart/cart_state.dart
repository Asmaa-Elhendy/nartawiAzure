import 'package:equatable/equatable.dart';

class CartState extends Equatable {
  final List<Object> cartProducts;
  final Map<String, int>? productQuantities;

  const CartState({
    required this.cartProducts,
    this.productQuantities,
  });

  factory CartState.initial() => const CartState(
        cartProducts: [],
        productQuantities: {},
      );

  CartState copyWith({
    List<Object>? cartProducts,
    Map<String, int>? productQuantities,
  }) {
    return CartState(
      cartProducts: cartProducts ?? this.cartProducts,
      productQuantities: productQuantities ?? this.productQuantities,
    );
  }

  @override
  List<Object?> get props => [cartProducts, productQuantities];
}
