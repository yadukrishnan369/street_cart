import 'package:street_cart/features/admin/products/domain/repositories/admin_product_repository.dart';

class AdminDeleteProduct {
  final IAdminProductRepository _repository;

  AdminDeleteProduct(this._repository);

  Future<void> call(String productId) async {
    await _repository.deleteProduct(productId);
  }
}
