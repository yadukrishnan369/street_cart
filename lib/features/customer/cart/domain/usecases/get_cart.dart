import 'package:street_cart/features/customer/cart/data/models/cart_item_model.dart';
import 'package:street_cart/features/customer/cart/domain/repositories/i_cart_repository.dart';

class GetCart {
  final ICartRepository repository;

  GetCart({required this.repository});

  Future<List<CartItem>> call() async {
    return await repository.getCartItems();
  }
}
