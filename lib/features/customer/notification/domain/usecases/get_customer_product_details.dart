import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/customer/notification/domain/repositories/i_customer_notifications_repository.dart';

class GetCustomerProductDetails {
  final ICustomerNotificationsRepository _repository;

  GetCustomerProductDetails(this._repository);

  Future<({ProductModel product, ShopProfileModel shop})?> call(
    String productId,
  ) async {
    return _repository.getProductWithShopById(productId);
  }
}
