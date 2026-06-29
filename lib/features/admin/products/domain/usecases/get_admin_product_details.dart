import 'package:street_cart/features/admin/products/domain/repositories/admin_product_repository.dart';

class GetAdminProductDetails {
  final IAdminProductRepository _repository;

  GetAdminProductDetails(this._repository);

  Future<AdminProductItem> call(String productId) async {
    return await _repository.getProductDetails(productId);
  }
}
