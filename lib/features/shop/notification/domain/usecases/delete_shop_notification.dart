import 'package:street_cart/features/shop/notification/domain/repositories/i_shop_notifications_repository.dart';

class DeleteShopNotification {
  final IShopNotificationsRepository _repository;

  DeleteShopNotification(this._repository);

  Future<void> call({
    required String shopId,
    required String notificationId,
  }) async {
    await _repository.deleteNotification(shopId, notificationId);
  }
}
