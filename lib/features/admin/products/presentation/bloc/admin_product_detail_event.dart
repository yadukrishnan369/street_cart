import 'package:equatable/equatable.dart';

abstract class AdminProductDetailEvent extends Equatable {
  const AdminProductDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadProductDetailRequested extends AdminProductDetailEvent {
  final String productId;

  const LoadProductDetailRequested(this.productId);

  @override
  List<Object?> get props => [productId];
}

class ToggleDisableProductRequested extends AdminProductDetailEvent {
  final String productId;
  final bool disable;

  const ToggleDisableProductRequested({
    required this.productId,
    required this.disable,
  });

  @override
  List<Object?> get props => [productId, disable];
}

class DeleteProductRequested extends AdminProductDetailEvent {
  final String productId;

  const DeleteProductRequested(this.productId);

  @override
  List<Object?> get props => [productId];
}
