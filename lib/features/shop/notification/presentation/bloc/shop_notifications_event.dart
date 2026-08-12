import 'package:equatable/equatable.dart';
import 'package:street_cart/features/shop/notification/data/models/shop_notification_model.dart';

abstract class ShopNotificationsEvent extends Equatable {
  const ShopNotificationsEvent();

  @override
  List<Object?> get props => [];
}

// Load Shop Notifications Event
class LoadShopNotificationsEvent extends ShopNotificationsEvent {
  final String shopId;

  const LoadShopNotificationsEvent(this.shopId);

  @override
  List<Object?> get props => [shopId];
}

// Shop Notifications Updated Event
class ShopNotificationsUpdatedEvent extends ShopNotificationsEvent {
  final List<ShopNotificationModel> notifications;

  const ShopNotificationsUpdatedEvent(this.notifications);

  @override
  List<Object?> get props => [notifications];
}

// Mark Shop  AsRead Event
class MarkShopAsReadEvent extends ShopNotificationsEvent {
  final String shopId;
  final String notificationId;

  const MarkShopAsReadEvent({
    required this.shopId,
    required this.notificationId,
  });

  @override
  List<Object?> get props => [shopId, notificationId];
}

// Mark All Shop As Read Event
class MarkAllShopAsReadEvent extends ShopNotificationsEvent {
  final String shopId;

  const MarkAllShopAsReadEvent(this.shopId);

  @override
  List<Object?> get props => [shopId];
}

// Get Shop Order Details Event
class GetShopOrderDetailsEvent extends ShopNotificationsEvent {
  final String orderId;
  final bool isReturnOrder;
  final String notificationId;

  const GetShopOrderDetailsEvent(
    this.orderId, {
    this.isReturnOrder = false,
    required this.notificationId,
  });

  @override
  List<Object?> get props => [orderId, isReturnOrder, notificationId];
}

// Clear Shop Selected Order Event
class ClearShopSelectedOrderEvent extends ShopNotificationsEvent {
  const ClearShopSelectedOrderEvent();
}

// Get Shop Product Details Event
class GetShopProductDetailsEvent extends ShopNotificationsEvent {
  final String productId;
  final String notificationId;

  const GetShopProductDetailsEvent(
    this.productId, {
    required this.notificationId,
  });

  @override
  List<Object?> get props => [productId, notificationId];
}

// Clear Shop Selected Product Event
class ClearShopSelectedProductEvent extends ShopNotificationsEvent {
  const ClearShopSelectedProductEvent();
}

// Delete Shop Notification Event
class DeleteShopNotificationEvent extends ShopNotificationsEvent {
  final String shopId;
  final String notificationId;

  const DeleteShopNotificationEvent({
    required this.shopId,
    required this.notificationId,
  });

  @override
  List<Object?> get props => [shopId, notificationId];
}

// Shop Notifications Error Event
class ShopNotificationsErrorEvent extends ShopNotificationsEvent {
  final String errorMessage;

  const ShopNotificationsErrorEvent(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
