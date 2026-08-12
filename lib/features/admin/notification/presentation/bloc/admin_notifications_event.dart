import 'package:equatable/equatable.dart';
import 'package:street_cart/features/admin/notification/data/models/admin_notification_model.dart';

abstract class AdminNotificationsEvent extends Equatable {
  const AdminNotificationsEvent();

  @override
  List<Object?> get props => [];
}

// Load Admin Notifications Event
class LoadAdminNotificationsEvent extends AdminNotificationsEvent {
  final String adminId;

  const LoadAdminNotificationsEvent(this.adminId);

  @override
  List<Object?> get props => [adminId];
}

// Admin Notifications Updated Event
class AdminNotificationsUpdatedEvent extends AdminNotificationsEvent {
  final List<AdminNotificationModel> notifications;

  const AdminNotificationsUpdatedEvent(this.notifications);

  @override
  List<Object?> get props => [notifications];
}

// Mark Admin As Read Event
class MarkAdminAsReadEvent extends AdminNotificationsEvent {
  final String adminId;
  final String notificationId;

  const MarkAdminAsReadEvent({
    required this.adminId,
    required this.notificationId,
  });

  @override
  List<Object?> get props => [adminId, notificationId];
}

// Mark All Admin As Read Event
class MarkAllAdminAsReadEvent extends AdminNotificationsEvent {
  final String adminId;

  const MarkAllAdminAsReadEvent(this.adminId);

  @override
  List<Object?> get props => [adminId];
}

// Admin Notifications Error Event
class AdminNotificationsErrorEvent extends AdminNotificationsEvent {
  final String errorMessage;

  const AdminNotificationsErrorEvent(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
