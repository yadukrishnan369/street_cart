import 'package:equatable/equatable.dart';
import 'package:street_cart/features/customer/profile/data/models/address_model.dart';

abstract class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object?> get props => [];
}

class FetchOrders extends OrdersEvent {}

class CancelOrderEvent extends OrdersEvent {
  final String orderId;

  const CancelOrderEvent(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class UpdateOrderAddressEvent extends OrdersEvent {
  final String orderId;
  final AddressModel address;

  const UpdateOrderAddressEvent(this.orderId, this.address);

  @override
  List<Object?> get props => [orderId, address];
}
