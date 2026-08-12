import 'package:street_cart/features/customer/notification/data/models/customer_notification_model.dart';
import 'package:street_cart/features/customer/notification/domain/repositories/i_customer_notifications_repository.dart';

class WatchCustomerNotifications {
  final ICustomerNotificationsRepository _repository;

  WatchCustomerNotifications(this._repository);

  Stream<List<CustomerNotificationModel>> call(String userId) {
    return _repository.watchNotifications(userId);
  }
}
