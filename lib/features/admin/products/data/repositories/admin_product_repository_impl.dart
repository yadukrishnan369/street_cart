import 'package:street_cart/core/constants/shop_constants.dart';
import 'package:street_cart/features/admin/products/domain/repositories/admin_product_repository.dart';
import 'package:street_cart/features/admin/products/data/datasources/admin_product_remote_datasource.dart';

class AdminProductRepositoryImpl implements IAdminProductRepository {
  final IAdminProductRemoteDataSource _remoteDataSource;

  AdminProductRepositoryImpl({
    required IAdminProductRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<AdminProductResponse> getProducts({
    required int page,
    required int limit,
    String? searchQuery,
    String? statusFilter,
    String? categoryFilter,
  }) async {
    final allProducts = await _remoteDataSource.getAllProducts();
    final allShops = await _remoteDataSource.getAllShops();

    final shopNameMap = {for (var shop in allShops) shop.uid: shop.shopName};
    final shopLocationMap = {
      for (var shop in allShops)
        shop.uid: shop.landmark.isNotEmpty
            ? '${shop.landmark}, ${shop.city}'
            : shop.city,
    };
    final shopSuspendedMap = {
      for (var shop in allShops) shop.uid: shop.isSuspended,
    };
    final commissionRate = await _remoteDataSource.getPlatformCommission();

    final totalProducts = allProducts.length;
    final activeItems = allProducts
        .where((p) => p.isActive && p.stockQuantity > 0)
        .length;
    final outOfStock = allProducts.where((p) => p.stockQuantity == 0).length;
    final disabledItems = allProducts.where((p) => p.disabledByAdmin).length;

    // Compile categories
    final configuredProductCategories = await _remoteDataSource
        .getProductCategoryNames();
    final uniqueCategoriesSet = <String>{};
    if (configuredProductCategories.isNotEmpty) {
      uniqueCategoriesSet.addAll(configuredProductCategories);
    } else {
      uniqueCategoriesSet.addAll(ShopConstants.defaultProductCategories);
    }
    for (final p in allProducts) {
      if (p.category.isNotEmpty) {
        uniqueCategoriesSet.add(p.category);
      }
    }
    final uniqueCategories = uniqueCategoriesSet.toList();
    uniqueCategories.sort();

    // Map to AdminProductItem
    var items = allProducts.map((p) {
      final shopName = shopNameMap[p.shopId] ?? 'Unknown Shop';
      final shopLoc = shopLocationMap[p.shopId] ?? 'Unknown Location';
      final isShopSuspended = shopSuspendedMap[p.shopId] ?? false;
      return AdminProductItem(
        product: p,
        shopName: shopName,
        shopLocation: shopLoc,
        commissionRate: commissionRate,
        isShopSuspended: isShopSuspended,
      );
    }).toList();

    // Apply search filter product name or shop name
    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final query = searchQuery.trim().toLowerCase();
      items = items
          .where(
            (item) =>
                item.product.name.toLowerCase().contains(query) ||
                item.shopName.toLowerCase().contains(query),
          )
          .toList();
    }

    // Apply status/category filters
    if (statusFilter == 'Active') {
      items = items
          .where(
            (item) => item.product.isActive && item.product.stockQuantity > 0,
          )
          .toList();
    } else if (statusFilter == 'Out of Stock') {
      items = items.where((item) => item.product.stockQuantity == 0).toList();
    } else if (statusFilter == 'Category' &&
        categoryFilter != null &&
        categoryFilter.isNotEmpty) {
      items = items
          .where((item) => item.product.category == categoryFilter)
          .toList();
    }

    // Sort by createdAt descending
    items.sort((a, b) {
      if (a.product.createdAt == null && b.product.createdAt == null) return 0;
      if (a.product.createdAt == null) return 1;
      if (b.product.createdAt == null) return -1;
      return b.product.createdAt!.compareTo(a.product.createdAt!);
    });

    final totalMatchingCount = items.length;

    // Pagination
    final startIndex = (page - 1) * limit;
    List<AdminProductItem> paginatedItems = [];
    if (startIndex < totalMatchingCount) {
      final endIndex = startIndex + limit > totalMatchingCount
          ? totalMatchingCount
          : startIndex + limit;
      paginatedItems = items.sublist(startIndex, endIndex);
    }

    return AdminProductResponse(
      products: paginatedItems,
      totalMatchingCount: totalMatchingCount,
      totalProducts: totalProducts,
      activeItems: activeItems,
      outOfStock: outOfStock,
      disabledItems: disabledItems,
      availableCategories: uniqueCategories,
    );
  }

  @override
  Future<AdminProductItem> getProductDetails(String productId) async {
    final product = await _remoteDataSource.getProductById(productId);
    final allShops = await _remoteDataSource.getAllShops();
    final shopNameMap = {for (var shop in allShops) shop.uid: shop.shopName};
    final shopLocationMap = {
      for (var shop in allShops)
        shop.uid: shop.landmark.isNotEmpty
            ? '${shop.landmark}, ${shop.city}'
            : shop.city,
    };
    final shopSuspendedMap = {
      for (var shop in allShops) shop.uid: shop.isSuspended,
    };
    final shopName = shopNameMap[product.shopId] ?? 'Unknown Shop';
    final shopLoc = shopLocationMap[product.shopId] ?? 'Unknown Location';
    final isShopSuspended = shopSuspendedMap[product.shopId] ?? false;
    final commissionRate = await _remoteDataSource.getPlatformCommission();
    return AdminProductItem(
      product: product,
      shopName: shopName,
      shopLocation: shopLoc,
      commissionRate: commissionRate,
      isShopSuspended: isShopSuspended,
    );
  }

  @override
  Future<void> disableProduct(String productId, bool disable) async {
    await _remoteDataSource.updateProductDisabledStatus(productId, disable);
  }

  @override
  Future<void> deleteProduct(String productId) async {
    await _remoteDataSource.deleteProduct(productId);
  }
}
