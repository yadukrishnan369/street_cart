import 'package:street_cart/features/customer/cart/data/models/cart_item_model.dart';
import 'package:street_cart/features/customer/profile/data/models/address_model.dart';

abstract class IPaymentRemoteDataSource {
  Future<String> placeOrder({
    required List<CartItem> items,
    required AddressModel address,
    required String paymentMethod,
    required String paymentStatus,
    required double totalAmount,
  });
}
