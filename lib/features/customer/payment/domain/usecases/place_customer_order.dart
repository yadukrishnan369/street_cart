import 'package:street_cart/features/customer/cart/data/models/cart_item_model.dart';
import 'package:street_cart/features/customer/profile/data/models/address_model.dart';
import 'package:street_cart/features/customer/payment/domain/repositories/i_payment_repository.dart';

class PlaceCustomerOrder {
  final IPaymentRepository repository;

  PlaceCustomerOrder({required this.repository});

  Future<String> call({
    required List<CartItem> items,
    required AddressModel address,
    required String paymentMethod,
    required String paymentStatus,
    required double totalAmount,
  }) async {
    return await repository.placeOrder(
      items: items,
      address: address,
      paymentMethod: paymentMethod,
      paymentStatus: paymentStatus,
      totalAmount: totalAmount,
    );
  }
}
