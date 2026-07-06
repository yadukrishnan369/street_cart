import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/shop/products/data/models/variant_image_draft.dart';
import 'package:street_cart/features/shop/products/domain/repositories/i_shop_products_repository.dart';

class UpdateProduct {
  final IShopProductsRepository _repository;

  UpdateProduct(this._repository);

  Future<void> call(
    ProductModel product,
    List<VariantImageDraft> variantDrafts,
  ) async {
    return await _repository.updateProduct(product, variantDrafts);
  }
}
