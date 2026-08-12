import 'package:street_cart/features/admin/notification/domain/repositories/i_admin_notifications_repository.dart';

class MarkAllAdminNotificationsAsRead {
  final IAdminNotificationsRepository _repository;

  MarkAllAdminNotificationsAsRead(this._repository);

  Future<void> call(String adminId) async {
    await _repository.markAllAsRead(adminId);
  }
}
