import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';

abstract class IAdminOrdersRepository {
  Stream<List<OrderModel>> watchAllOrders();
  Future<Map<String, String>> fetchShopNamesMap();
  Future<Map<String, ShopProfileModel>> fetchShopProfilesMap();
  Future<Map<String, String>> fetchCustomerNamesMap();
  Future<Map<String, String>> fetchCustomerEmailsMap();
}
