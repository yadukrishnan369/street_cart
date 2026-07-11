import 'package:street_cart/features/customer/orders/domain/repositories/i_orders_repository.dart';
import 'package:street_cart/features/customer/profile/data/models/address_model.dart';

class UpdateOrderAddress {
  final IOrdersRepository repository;

  UpdateOrderAddress(this.repository);

  Future<void> call(String orderId, AddressModel address) async {
    return repository.updateOrderAddress(orderId, address);
  }
}
