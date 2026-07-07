import 'package:street_cart/features/customer/cart/domain/repositories/i_cart_repository.dart';

class ClearCart {
  final ICartRepository repository;

  ClearCart({required this.repository});

  Future<void> call() async {
    await repository.clearCart();
  }
}
