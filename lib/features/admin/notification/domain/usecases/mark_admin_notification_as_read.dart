import 'package:street_cart/features/admin/notification/domain/repositories/i_admin_notifications_repository.dart';

class MarkAdminNotificationAsRead {
  final IAdminNotificationsRepository _repository;

  MarkAdminNotificationAsRead(this._repository);

  Future<void> call({
    required String adminId,
    required String notificationId,
  }) async {
    await _repository.markAsRead(adminId, notificationId);
  }
}
