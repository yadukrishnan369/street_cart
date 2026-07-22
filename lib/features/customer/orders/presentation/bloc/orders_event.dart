import 'package:equatable/equatable.dart';
import 'package:street_cart/features/customer/profile/data/models/address_model.dart';

abstract class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object?> get props => [];
}

// Fetch Orders Event
class FetchOrders extends OrdersEvent {}

// Cancel Order Event
class CancelOrderEvent extends OrdersEvent {
  final String orderId;

  const CancelOrderEvent(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

// Cancel Order Item Event
class CancelOrderItemEvent extends OrdersEvent {
  final String orderId;
  final String orderItemId;

  const CancelOrderItemEvent(this.orderId, this.orderItemId);

  @override
  List<Object?> get props => [orderId, orderItemId];
}

// Update Order Address Event
class UpdateOrderAddressEvent extends OrdersEvent {
  final String orderId;
  final AddressModel address;

  const UpdateOrderAddressEvent(this.orderId, this.address);

  @override
  List<Object?> get props => [orderId, address];
}

// Submit Return Request Event
class SubmitReturnRequestEvent extends OrdersEvent {
  final String orderId;
  final String itemId;
  final String reason;
  final String details;

  const SubmitReturnRequestEvent({
    required this.orderId,
    required this.itemId,
    required this.reason,
    required this.details,
  });

  @override
  List<Object?> get props => [orderId, itemId, reason, details];
}
