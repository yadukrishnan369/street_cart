import 'package:equatable/equatable.dart';
import 'package:street_cart/features/admin/notification/data/models/admin_notification_model.dart';

// Admin Notifications Status Enums
enum AdminNotificationsStatus { initial, loading, loaded, failure }

// Admin Notifications State
class AdminNotificationsState extends Equatable {
  final AdminNotificationsStatus status;
  final List<AdminNotificationModel> notifications;
  final String adminId;
  final String? errorMessage;

  const AdminNotificationsState({
    this.status = AdminNotificationsStatus.initial,
    this.notifications = const [],
    this.adminId = '',
    this.errorMessage,
  });

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  AdminNotificationsState copyWith({
    AdminNotificationsStatus? status,
    List<AdminNotificationModel>? notifications,
    String? adminId,
    String? errorMessage,
  }) {
    return AdminNotificationsState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      adminId: adminId ?? this.adminId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, notifications, adminId, errorMessage];
}
