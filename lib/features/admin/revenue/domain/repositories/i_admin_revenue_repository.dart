import 'package:street_cart/features/admin/customers/data/models/customer_model.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';

abstract class IAdminRevenueRepository {
  Future<List<OrderModel>> getAllOrders();
  Future<List<ShopProfileModel>> getAllShops();
  Future<List<ProductModel>> getAllProducts();
  Future<List<CustomerModel>> getAllCustomers();
}
