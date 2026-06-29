import 'package:street_cart/features/customer/shops/domain/repositories/i_customer_shops_repository.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';

class GetCustomerShopProducts {
  final ICustomerShopsRepository repository;

  GetCustomerShopProducts({required this.repository});

  Future<List<ProductModel>> call(String shopId) async {
    return await repository.getShopProducts(shopId);
  }
}
