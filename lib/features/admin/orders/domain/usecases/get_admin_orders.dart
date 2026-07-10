import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/admin/orders/domain/repositories/i_admin_orders_repository.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';

class GetAdminOrders {
  final IAdminOrdersRepository repository;

  GetAdminOrders(this.repository);

  Stream<List<OrderModel>> execute() {
    return repository.watchAllOrders();
  }

  Future<Map<String, String>> fetchShopNames() {
    return repository.fetchShopNamesMap();
  }

  Future<Map<String, ShopProfileModel>> fetchShopProfiles() {
    return repository.fetchShopProfilesMap();
  }

  Future<Map<String, String>> fetchCustomerNames() {
    return repository.fetchCustomerNamesMap();
  }

  Future<Map<String, String>> fetchCustomerEmails() {
    return repository.fetchCustomerEmailsMap();
  }
}
