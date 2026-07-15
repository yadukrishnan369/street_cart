import 'package:equatable/equatable.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';

abstract class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object?> get props => [];
}

class OrdersInitial extends OrdersState {}

class OrdersLoading extends OrdersState {}

class OrdersLoaded extends OrdersState {
  final List<OrderModel> orders;

  const OrdersLoaded(this.orders);

  @override
  List<Object?> get props => [orders];
}

class OrdersFailure extends OrdersState {
  final String message;

  const OrdersFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class OrderCancelling extends OrdersState {}

class OrderCancelledSuccess extends OrdersState {}

class OrderItemCancelling extends OrdersState {}

class OrderItemCancelledSuccess extends OrdersState {}

class OrderAddressUpdating extends OrdersState {}

class OrderAddressUpdateSuccess extends OrdersState {}
