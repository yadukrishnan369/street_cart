import 'package:equatable/equatable.dart';
import 'package:street_cart/features/admin/products/domain/repositories/admin_product_repository.dart';

abstract class AdminProductDetailState extends Equatable {
  const AdminProductDetailState();

  @override
  List<Object?> get props => [];
}

class AdminProductDetailInitial extends AdminProductDetailState {}

class AdminProductDetailLoading extends AdminProductDetailState {}

class AdminProductDetailActionInProgress extends AdminProductDetailState {}

class AdminProductDetailLoaded extends AdminProductDetailState {
  final AdminProductItem item;

  const AdminProductDetailLoaded(this.item);

  @override
  List<Object?> get props => [item];
}

class AdminProductDetailActionSuccess extends AdminProductDetailState {
  final String message;

  const AdminProductDetailActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class AdminProductDetailError extends AdminProductDetailState {
  final String message;

  const AdminProductDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
