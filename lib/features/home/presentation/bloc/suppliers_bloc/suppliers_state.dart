import 'package:equatable/equatable.dart';
import '../../../domain/models/supplier_model.dart';

abstract class SuppliersState extends Equatable {
  const SuppliersState();

  @override
  List<Object> get props => [];
}

class SuppliersInitial extends SuppliersState {}

class SuppliersLoading extends SuppliersState {}

class SuppliersLoaded extends SuppliersState {
  final List<Supplier> suppliers;

  const SuppliersLoaded(this.suppliers);

  @override
  List<Object> get props => [suppliers];
}

class SuppliersError extends SuppliersState {
  final String message;

  const SuppliersError(this.message);

  @override
  List<Object> get props => [message];
}
