import 'package:street_cart/features/customer/notification/domain/repositories/i_customer_notifications_repository.dart';

class MarkAllCustomerNotificationsAsRead {
  final ICustomerNotificationsRepository _repository;

  MarkAllCustomerNotificationsAsRead(this._repository);

  Future<void> call(String userId) async {
    await _repository.markAllAsRead(userId);
  }
}
