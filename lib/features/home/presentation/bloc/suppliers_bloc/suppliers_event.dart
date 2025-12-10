import 'package:equatable/equatable.dart';

abstract class SuppliersEvent extends Equatable {
  const SuppliersEvent();

  @override
  List<Object> get props => [];
}

class FetchSuppliers extends SuppliersEvent {
  const FetchSuppliers();
}
