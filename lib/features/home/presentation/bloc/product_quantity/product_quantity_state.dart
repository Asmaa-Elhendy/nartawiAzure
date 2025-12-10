import 'package:equatable/equatable.dart';

class ProductQuantityState extends Equatable {
  final String quantity;
  final double price;

  const ProductQuantityState({
    required this.quantity,
    required this.price,
  });

  factory ProductQuantityState.initial(double price) {
    return ProductQuantityState(
      quantity: '1',
      price: price,
    );
  }

  ProductQuantityState copyWith({
    String? quantity,
    double? price,
  }) {
    return ProductQuantityState(
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
    );
  }

  @override
  List<Object?> get props => [quantity, price];
}
