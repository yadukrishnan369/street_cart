import 'package:street_cart/core/network/network_info.dart';
import 'package:street_cart/core/error/exceptions.dart';
import 'package:street_cart/features/admin/products/domain/repositories/admin_product_repository.dart';
import 'package:street_cart/features/admin/products/data/datasources/admin_product_remote_datasource.dart';

class AdminProductRepositoryImpl implements IAdminProductRepository {
  final IAdminProductRemoteDataSource _remoteDataSource;
  final INetworkInfo _networkInfo;

  AdminProductRepositoryImpl({
    required IAdminProductRemoteDataSource remoteDataSource,
    required INetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _networkInfo = networkInfo;

  Future<void> _checkConnection() async {
    if (!await _networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }
  }

  //  Get Products
  @override
  Future<AdminProductResponse> getProducts({
    required int page,
    required int limit,
    String? searchQuery,
    String? statusFilter,
    String? categoryFilter,
  }) async {
    await _checkConnection();
    final allProductsRaw = await _remoteDataSource.getAllProducts();
    final allShops = await _remoteDataSource.getAllShops();

    final existingShopIds = allShops.map((s) => s.uid).toSet();
    final allProducts = allProductsRaw
        .where((p) => existingShopIds.contains(p.shopId))
        .toList();

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

    // Get categories - only include categories where at least one product exists
    final uniqueCategoriesSet = <String>{};
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

  // Get Product Detail
  @override
  Future<AdminProductItem> getProductDetails(String productId) async {
    await _checkConnection();
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
    final orderCount = await _remoteDataSource.getProductOrderCount(productId);
    return AdminProductItem(
      product: product,
      shopName: shopName,
      shopLocation: shopLoc,
      commissionRate: commissionRate,
      isShopSuspended: isShopSuspended,
      orderCount: orderCount,
    );
  }

  // Disable Product
  @override
  Future<void> disableProduct(String productId, bool disable) async {
    await _checkConnection();
    await _remoteDataSource.updateProductDisabledStatus(productId, disable);
  }

  // Delete Product
  @override
  Future<void> deleteProduct(String productId) async {
    await _checkConnection();
    await _remoteDataSource.deleteProduct(productId);
  }
}
