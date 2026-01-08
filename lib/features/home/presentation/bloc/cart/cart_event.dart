import 'package:equatable/equatable.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class CartAddItem extends CartEvent {
  final Object item;
  const CartAddItem(this.item);

  @override
  List<Object?> get props => [item];
}

class CartRemoveItem extends CartEvent {
  final Object item;
  const CartRemoveItem(this.item);

  @override
  List<Object?> get props => [item];
}

class CartClear extends CartEvent {
  const CartClear();
}

class CartUpdateQuantity extends CartEvent {
  final Object item;
  final int quantity;
  
  const CartUpdateQuantity(this.item, this.quantity);

  @override
  List<Object?> get props => [item, quantity];
}
