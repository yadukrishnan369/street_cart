part of 'shop_orders_bloc.dart';

// Base class
abstract class ShopOrdersEvent extends Equatable {
  const ShopOrdersEvent();

  @override
  List<Object?> get props => [];
}

// Fetch list of Orders of a Shop
class FetchShopOrdersEvent extends ShopOrdersEvent {
  final String shopId;

  const FetchShopOrdersEvent(this.shopId);

  @override
  List<Object?> get props => [shopId];
}

// Update Status of an Order
class UpdateOrderStatusEvent extends ShopOrdersEvent {
  final String shopId;
  final String orderId;
  final String newStatus;

  const UpdateOrderStatusEvent({
    required this.shopId,
    required this.orderId,
    required this.newStatus,
  });

  @override
  List<Object?> get props => [shopId, orderId, newStatus];
}

// Toggle state of the payment received checkbox
class TogglePaymentReceivedEvent extends ShopOrdersEvent {
  final bool isReceived;

  const TogglePaymentReceivedEvent(this.isReceived);

  @override
  List<Object?> get props => [isReceived];
}
