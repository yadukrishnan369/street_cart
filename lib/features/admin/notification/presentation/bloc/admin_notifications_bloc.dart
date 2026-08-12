import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/admin/notification/domain/usecases/watch_admin_notifications.dart';
import 'package:street_cart/features/admin/notification/domain/usecases/mark_admin_notification_as_read.dart';
import 'package:street_cart/features/admin/notification/domain/usecases/mark_all_admin_notifications_as_read.dart';
import 'admin_notifications_event.dart';
import 'admin_notifications_state.dart';

class AdminNotificationsBloc
    extends Bloc<AdminNotificationsEvent, AdminNotificationsState> {
  final WatchAdminNotifications _watchAdminNotifications;
  final MarkAdminNotificationAsRead _markAdminNotificationAsRead;
  final MarkAllAdminNotificationsAsRead _markAllAdminNotificationsAsRead;
  StreamSubscription? _notificationsSubscription;

  AdminNotificationsBloc({
    required WatchAdminNotifications watchAdminNotifications,
    required MarkAdminNotificationAsRead markAdminNotificationAsRead,
    required MarkAllAdminNotificationsAsRead markAllAdminNotificationsAsRead,
  }) : _watchAdminNotifications = watchAdminNotifications,
       _markAdminNotificationAsRead = markAdminNotificationAsRead,
       _markAllAdminNotificationsAsRead = markAllAdminNotificationsAsRead,
       super(const AdminNotificationsState()) {
    on<LoadAdminNotificationsEvent>(_onLoadNotifications);
    on<AdminNotificationsUpdatedEvent>(_onNotificationsUpdated);
    on<MarkAdminAsReadEvent>(_onMarkAsRead);
    on<MarkAllAdminAsReadEvent>(_onMarkAllAsRead);
    on<AdminNotificationsErrorEvent>(_onNotificationsError);
  }
  // Notifications Error
  void _onNotificationsError(
    AdminNotificationsErrorEvent event,
    Emitter<AdminNotificationsState> emit,
  ) {
    emit(
      state.copyWith(
        status: AdminNotificationsStatus.failure,
        errorMessage: event.errorMessage,
      ),
    );
  }

  // Load Notifications
  void _onLoadNotifications(
    LoadAdminNotificationsEvent event,
    Emitter<AdminNotificationsState> emit,
  ) {
    emit(
      state.copyWith(
        status: AdminNotificationsStatus.loading,
        adminId: event.adminId,
      ),
    );
    _notificationsSubscription?.cancel();
    _notificationsSubscription = _watchAdminNotifications(event.adminId).listen(
      (notifications) => add(AdminNotificationsUpdatedEvent(notifications)),
      onError: (error) {
        add(AdminNotificationsErrorEvent(error.toString()));
      },
    );
  }

  // Notifications Updated
  void _onNotificationsUpdated(
    AdminNotificationsUpdatedEvent event,
    Emitter<AdminNotificationsState> emit,
  ) {
    emit(
      state.copyWith(
        status: AdminNotificationsStatus.loaded,
        notifications: event.notifications,
      ),
    );
  }

  // Mark As Read
  Future<void> _onMarkAsRead(
    MarkAdminAsReadEvent event,
    Emitter<AdminNotificationsState> emit,
  ) async {
    try {
      await _markAdminNotificationAsRead(
        adminId: event.adminId,
        notificationId: event.notificationId,
      );
    } catch (_) {}
  }

  // Mark All As Read
  Future<void> _onMarkAllAsRead(
    MarkAllAdminAsReadEvent event,
    Emitter<AdminNotificationsState> emit,
  ) async {
    try {
      await _markAllAdminNotificationsAsRead(event.adminId);
    } catch (_) {}
  }

  @override
  Future<void> close() {
    _notificationsSubscription?.cancel();
    return super.close();
  }
}
