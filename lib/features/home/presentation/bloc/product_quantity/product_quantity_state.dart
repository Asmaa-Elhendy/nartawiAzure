import 'package:equatable/equatable.dart';
import '../../../domain/models/product_model.dart';

class ProductQuantityState extends Equatable {
  final String quantity;
  final double price;
  final ClientProduct? product;

  const ProductQuantityState({
    required this.quantity,
    required this.price,
    this.product,
  });

  factory ProductQuantityState.initial(double price, [ClientProduct? product]) {
    return ProductQuantityState(
      quantity: '1',
      price: price,
      product: product,
    );
  }

  ProductQuantityState copyWith({
    String? quantity,
    double? price,
    ClientProduct? product,
  }) {
    return ProductQuantityState(
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      product: product ?? this.product,
    );
  }

  @override
  List<Object?> get props => [quantity, price, product];
}
