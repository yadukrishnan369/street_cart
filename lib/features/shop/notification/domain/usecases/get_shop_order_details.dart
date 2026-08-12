import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/shop/notification/domain/repositories/i_shop_notifications_repository.dart';

class GetShopOrderDetails {
  final IShopNotificationsRepository _repository;

  GetShopOrderDetails(this._repository);

  Future<OrderModel?> call(String orderId) async {
    return _repository.getOrderById(orderId);
  }
}
