import 'package:street_cart/features/customer/cart/domain/repositories/i_cart_repository.dart';

class RemoveFromCart {
  final ICartRepository repository;

  RemoveFromCart({required this.repository});

  Future<void> call(String itemId) async {
    await repository.removeFromCart(itemId);
  }
}
