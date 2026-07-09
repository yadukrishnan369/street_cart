import 'package:equatable/equatable.dart';

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
