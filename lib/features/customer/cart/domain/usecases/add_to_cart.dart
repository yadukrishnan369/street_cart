import 'package:street_cart/features/customer/cart/data/models/cart_item_model.dart';
import 'package:street_cart/features/customer/cart/domain/repositories/i_cart_repository.dart';

class AddToCart {
  final ICartRepository repository;

  AddToCart({required this.repository});

  Future<void> call(CartItem item) async {
    await repository.addToCart(item);
  }
}
