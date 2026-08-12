import 'package:equatable/equatable.dart';
import 'package:street_cart/features/customer/notification/data/models/customer_notification_model.dart';

abstract class CustomerNotificationsEvent extends Equatable {
  const CustomerNotificationsEvent();

  @override
  List<Object?> get props => [];
}

// Load Notifications Event
class LoadNotificationsEvent extends CustomerNotificationsEvent {
  final String userId;

  const LoadNotificationsEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

// Notifications Updated Event
class NotificationsUpdatedEvent extends CustomerNotificationsEvent {
  final List<CustomerNotificationModel> notifications;

  const NotificationsUpdatedEvent(this.notifications);

  @override
  List<Object?> get props => [notifications];
}

// Mark As Read Event
class MarkAsReadEvent extends CustomerNotificationsEvent {
  final String userId;
  final String notificationId;

  const MarkAsReadEvent({required this.userId, required this.notificationId});

  @override
  List<Object?> get props => [userId, notificationId];
}

// Mark All As Read Event
class MarkAllAsReadEvent extends CustomerNotificationsEvent {
  final String userId;

  const MarkAllAsReadEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

// Get Order Details Event
class GetOrderDetailsEvent extends CustomerNotificationsEvent {
  final String orderId;
  final String notificationId;

  const GetOrderDetailsEvent({
    required this.orderId,
    required this.notificationId,
  });

  @override
  List<Object?> get props => [orderId, notificationId];
}

// Clear Selected Order Event
class ClearSelectedOrderEvent extends CustomerNotificationsEvent {
  const ClearSelectedOrderEvent();
}

// Get Product Details Event
class GetProductDetailsEvent extends CustomerNotificationsEvent {
  final String productId;
  final String notificationId;

  const GetProductDetailsEvent({
    required this.productId,
    required this.notificationId,
  });

  @override
  List<Object?> get props => [productId, notificationId];
}

// Clear Selected Product Event
class ClearSelectedProductEvent extends CustomerNotificationsEvent {
  const ClearSelectedProductEvent();
}

// Customer Notifications Error Event
class CustomerNotificationsErrorEvent extends CustomerNotificationsEvent {
  final String errorMessage;

  const CustomerNotificationsErrorEvent(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
