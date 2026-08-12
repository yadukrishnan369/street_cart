import 'package:street_cart/features/shop/notification/domain/repositories/i_shop_notifications_repository.dart';

class MarkAllShopNotificationsAsRead {
  final IShopNotificationsRepository _repository;

  MarkAllShopNotificationsAsRead(this._repository);

  Future<void> call(String shopId) async {
    await _repository.markAllAsRead(shopId);
  }
}
