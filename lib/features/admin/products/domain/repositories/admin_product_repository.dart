import 'package:street_cart/features/shop/products/data/models/product_model.dart';

class AdminProductItem {
  final ProductModel product;
  final String shopName;
  final String shopLocation;
  final double commissionRate;
  final bool isShopSuspended;
  final int orderCount;

  AdminProductItem({
    required this.product,
    required this.shopName,
    required this.shopLocation,
    required this.commissionRate,
    this.isShopSuspended = false,
    this.orderCount = 0,
  });
}

class AdminProductResponse {
  final List<AdminProductItem> products;
  final int totalMatchingCount;
  final int totalProducts;
  final int activeItems;
  final int outOfStock;
  final int disabledItems;
  final List<String> availableCategories;

  AdminProductResponse({
    required this.products,
    required this.totalMatchingCount,
    required this.totalProducts,
    required this.activeItems,
    required this.outOfStock,
    required this.disabledItems,
    required this.availableCategories,
  });
}

abstract class IAdminProductRepository {
  Future<AdminProductResponse> getProducts({
    required int page,
    required int limit,
    String? searchQuery,
    String? statusFilter,
    String? categoryFilter,
  });

  Future<AdminProductItem> getProductDetails(String productId);
  Future<void> disableProduct(String productId, bool disable);
  Future<void> deleteProduct(String productId);
}
