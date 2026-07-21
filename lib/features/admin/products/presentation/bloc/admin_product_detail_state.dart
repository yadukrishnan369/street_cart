import 'package:equatable/equatable.dart';
import 'package:street_cart/features/admin/products/domain/repositories/admin_product_repository.dart';

abstract class AdminProductDetailState extends Equatable {
  const AdminProductDetailState();

  @override
  List<Object?> get props => [];
}

// Product Detail Initial State
class AdminProductDetailInitial extends AdminProductDetailState {}

// Product Detail Loading State
class AdminProductDetailLoading extends AdminProductDetailState {}

// Product Detail Action InProgress State
class AdminProductDetailActionInProgress extends AdminProductDetailState {}

// Product Detail Loaded State
class AdminProductDetailLoaded extends AdminProductDetailState {
  final AdminProductItem item;

  const AdminProductDetailLoaded(this.item);

  @override
  List<Object?> get props => [item];
}

// Product Detail Action Success State
class AdminProductDetailActionSuccess extends AdminProductDetailState {
  final String message;

  const AdminProductDetailActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

// Product Detail Error State
class AdminProductDetailError extends AdminProductDetailState {
  final String message;

  const AdminProductDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
