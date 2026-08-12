import 'package:street_cart/features/customer/notification/domain/repositories/i_customer_notifications_repository.dart';

class MarkCustomerNotificationAsRead {
  final ICustomerNotificationsRepository _repository;

  MarkCustomerNotificationAsRead(this._repository);

  Future<void> call({
    required String userId,
    required String notificationId,
  }) async {
    await _repository.markAsRead(userId, notificationId);
  }
}
