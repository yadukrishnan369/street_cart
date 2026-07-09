import 'package:equatable/equatable.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';

abstract class ShopOrdersState extends Equatable {
  const ShopOrdersState();

  @override
  List<Object?> get props => [];
}

class ShopOrdersInitial extends ShopOrdersState {}

class ShopOrdersLoading extends ShopOrdersState {}

class ShopOrdersLoaded extends ShopOrdersState {
  final List<OrderModel> orders;

  const ShopOrdersLoaded(this.orders);

  @override
  List<Object?> get props => [orders];
}

class ShopOrdersFailure extends ShopOrdersState {
  final String message;

  const ShopOrdersFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class ShopOrderStatusUpdating extends ShopOrdersState {}

class ShopOrderStatusUpdated extends ShopOrdersState {}
