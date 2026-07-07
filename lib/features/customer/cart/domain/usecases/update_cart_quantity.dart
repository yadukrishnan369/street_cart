import 'package:street_cart/features/customer/cart/domain/repositories/i_cart_repository.dart';

class UpdateCartQuantity {
  final ICartRepository repository;

  UpdateCartQuantity({required this.repository});

  Future<void> call(String itemId, int quantity) async {
    await repository.updateQuantity(itemId, quantity);
  }
}
