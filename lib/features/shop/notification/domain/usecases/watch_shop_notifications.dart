import 'package:street_cart/features/shop/notification/data/models/shop_notification_model.dart';
import 'package:street_cart/features/shop/notification/domain/repositories/i_shop_notifications_repository.dart';

class WatchShopNotifications {
  final IShopNotificationsRepository _repository;

  WatchShopNotifications(this._repository);

  Stream<List<ShopNotificationModel>> call(String shopId) {
    return _repository.watchNotifications(shopId);
  }
}
