import 'package:street_cart/features/shop/notification/domain/repositories/i_shop_notifications_repository.dart';

class MarkShopNotificationAsRead {
  final IShopNotificationsRepository _repository;

  MarkShopNotificationAsRead(this._repository);

  Future<void> call({
    required String shopId,
    required String notificationId,
  }) async {
    await _repository.markAsRead(shopId, notificationId);
  }
}
