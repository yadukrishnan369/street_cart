import 'package:street_cart/features/admin/notification/data/models/admin_notification_model.dart';
import 'package:street_cart/features/admin/notification/domain/repositories/i_admin_notifications_repository.dart';

class WatchAdminNotifications {
  final IAdminNotificationsRepository _repository;

  WatchAdminNotifications(this._repository);

  Stream<List<AdminNotificationModel>> call(String adminId) {
    return _repository.watchNotifications(adminId);
  }
}
