import 'package:equatable/equatable.dart';

abstract class SuppliersEvent extends Equatable {
  const SuppliersEvent();

  @override
  List<Object> get props => [];
}

class FetchSuppliers extends SuppliersEvent {
  const FetchSuppliers();
}

class FetchFeaturedSuppliers extends SuppliersEvent {
  const FetchFeaturedSuppliers();
}

class FetchSupplierById extends SuppliersEvent {
  final int supplierId;

  const FetchSupplierById(this.supplierId);

  @override
  List<Object> get props => [supplierId];
}
