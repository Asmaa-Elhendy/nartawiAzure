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

class FeaturedSuppliersLoading extends SuppliersState {}

class FeaturedSuppliersLoaded extends SuppliersState {
  final List<Supplier> featuredSuppliers;

  const FeaturedSuppliersLoaded(this.featuredSuppliers);

  @override
  List<Object> get props => [featuredSuppliers];
}

class FeaturedSuppliersError extends SuppliersState {
  final String message;

  const FeaturedSuppliersError(this.message);

  @override
  List<Object> get props => [message];
}

class SupplierDetailLoading extends SuppliersState {}

class SupplierDetailLoaded extends SuppliersState {
  final Supplier supplier;

  const SupplierDetailLoaded(this.supplier);

  @override
  List<Object> get props => [supplier];
}

class SupplierDetailError extends SuppliersState {
  final String message;

  const SupplierDetailError(this.message);

  @override
  List<Object> get props => [message];
}
