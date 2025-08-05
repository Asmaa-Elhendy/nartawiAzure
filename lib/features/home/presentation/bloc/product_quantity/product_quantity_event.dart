import 'package:equatable/equatable.dart';

abstract class ProductQuantityEvent extends Equatable {
  const ProductQuantityEvent();

  @override
  List<Object?> get props => [];
}

class IncreaseQuantity extends ProductQuantityEvent {}

class DecreaseQuantity extends ProductQuantityEvent {}

class QuantityChanged extends ProductQuantityEvent {
  final String value;

  const QuantityChanged(this.value);

  @override
  List<Object?> get props => [value];
}

class QuantityEditingComplete extends ProductQuantityEvent {}
