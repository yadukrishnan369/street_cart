import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/shop/products/data/models/variant_image_draft.dart';
import 'package:street_cart/features/shop/products/domain/repositories/i_shop_products_repository.dart';
import 'package:street_cart/features/customer/notification/domain/usecases/send_customer_notification.dart';

class UpdateProduct {
  final IShopProductsRepository _repository;
  final SendCustomerNotification _sendCustomerNotification;

  UpdateProduct(this._repository, this._sendCustomerNotification);

  Future<void> call(
    ProductModel product,
    List<VariantImageDraft> variantDrafts,
  ) async {
    final result = await _repository.updateProduct(product, variantDrafts);

    final bool isPriceDrop = result['isPriceDrop'] ?? false;
    final bool isRestock = result['isRestock'] ?? false;
    final int percentOff = result['percentOff'] ?? 0;

    // Send price drop notification for wishlisted customers
    if (isPriceDrop) {
      try {
        await _sendCustomerNotification.notifyWishlisted(
          productId: product.id,
          productName: product.name,
          isPriceDrop: true,
          percentOff: percentOff,
        );
      } catch (_) {}
      // Send price drop notification for cart customers
      try {
        await _sendCustomerNotification.notifyCart(
          productId: product.id,
          productName: product.name,
          percentOff: percentOff,
        );
      } catch (_) {}
      // Send restock notification for wishlisted customers
    } else if (isRestock) {
      try {
        await _sendCustomerNotification.notifyWishlisted(
          productId: product.id,
          productName: product.name,
          isPriceDrop: false,
        );
      } catch (_) {}
      // Send restock notification for cart customers
      try {
        await _sendCustomerNotification.notifyCart(
          productId: product.id,
          productName: product.name,
          percentOff: 0,
        );
      } catch (_) {}
    }
  }
}
