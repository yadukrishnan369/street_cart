import 'package:equatable/equatable.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';

abstract class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object?> get props => [];
}

// Orders Initial State
class OrdersInitial extends OrdersState {}

// Orders Loading State
class OrdersLoading extends OrdersState {}

// Orders Loaded State
class OrdersLoaded extends OrdersState {
  final List<OrderModel> orders;

  const OrdersLoaded(this.orders);

  @override
  List<Object?> get props => [orders];
}

// Orders Failure State
class OrdersFailure extends OrdersState {
  final String message;

  const OrdersFailure(this.message);

  @override
  List<Object?> get props => [message];
}

// Order Cancelling State
class OrderCancelling extends OrdersState {}

// Order Cancelled Success State
class OrderCancelledSuccess extends OrdersState {}

// Order Item Cancelling State
class OrderItemCancelling extends OrdersState {}

// Order Item Cancelled Success State
class OrderItemCancelledSuccess extends OrdersState {}

// Order Address Updating State
class OrderAddressUpdating extends OrdersState {}

// Order Address Update Success State
class OrderAddressUpdateSuccess extends OrdersState {}

// Return Request Submitting State
class ReturnRequestSubmitting extends OrdersState {}

// Return Request Submitted Success State
class ReturnRequestSubmittedSuccess extends OrdersState {}
