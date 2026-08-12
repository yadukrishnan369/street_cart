import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/shop/products/data/models/variant_image_draft.dart';

abstract class IShopProductsRemoteDataSource {
  Stream<List<ProductModel>> getShopProducts(String shopId);

  Future<void> addProduct(
    ProductModel product,
    List<VariantImageDraft> variantDrafts,
  );

  Future<Map<String, dynamic>> updateProduct(
    ProductModel product,
    List<VariantImageDraft> variantDrafts,
  );

  Future<void> deleteProduct(String shopId, String productId);
  Future<Map<String, dynamic>> getShopProductConfig(String shopId);
  Future<void> saveShopProductConfig(
    String shopId,
    Map<String, dynamic> config,
  );
}
