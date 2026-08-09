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

// Update Order Return Status Event
class UpdateOrderReturnStatusEvent extends ShopOrdersEvent {
  final String shopId;
  final String orderId;
  final String newReturnStatus;
  final bool refundViaHand;
  final double refundAmount;

  const UpdateOrderReturnStatusEvent({
    required this.shopId,
    required this.orderId,
    required this.newReturnStatus,
    this.refundViaHand = false,
    this.refundAmount = 0.0,
  });

  @override
  List<Object?> get props => [
    shopId,
    orderId,
    newReturnStatus,
    refundViaHand,
    refundAmount,
  ];
}

// Initiate Refund Event
class InitiateRefundEvent extends ShopOrdersEvent {
  final String orderId;
  final double refundAmount;
  final String paymentMethod;

  const InitiateRefundEvent({
    required this.orderId,
    required this.refundAmount,
    required this.paymentMethod,
  });

  @override
  List<Object?> get props => [orderId, refundAmount, paymentMethod];
}

// Complete Refund Event
class CompleteRefundEvent extends ShopOrdersEvent {
  final String orderId;
  final double refundAmount;
  final String refundStatus;

  const CompleteRefundEvent({
    required this.orderId,
    required this.refundAmount,
    required this.refundStatus,
  });

  @override
  List<Object?> get props => [orderId, refundAmount, refundStatus];
}

// Refund Error Event
class RefundErrorEvent extends ShopOrdersEvent {
  final String errorMessage;

  const RefundErrorEvent(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

// Reset Refund Status Event
class ResetRefundStatusEvent extends ShopOrdersEvent {
  const ResetRefundStatusEvent();

  @override
  List<Object?> get props => [];
}

// Toggle Refund Via Hand Event
class ToggleRefundViaHandEvent extends ShopOrdersEvent {
  final bool isChecked;

  const ToggleRefundViaHandEvent(this.isChecked);

  @override
  List<Object?> get props => [isChecked];
}

// Check Products Status Event
class CheckProductsStatusEvent extends ShopOrdersEvent {
  final List<String> productIds;

  const CheckProductsStatusEvent(this.productIds);

  @override
  List<Object?> get props => [productIds];
}
