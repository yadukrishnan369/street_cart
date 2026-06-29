import 'package:street_cart/features/admin/products/domain/repositories/admin_product_repository.dart';

class DisableProduct {
  final IAdminProductRepository _repository;

  DisableProduct(this._repository);

  Future<void> call(String productId, bool disable) async {
    await _repository.disableProduct(productId, disable);
  }
}
