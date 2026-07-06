import 'package:street_cart/features/admin/shops/data/datasources/i_admin_shop_remote_datasource.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/admin/shops/domain/repositories/admin_shop_repository.dart';

class AdminShopRepositoryImpl implements IAdminShopRepository {
  final IAdminShopRemoteDataSource _remoteDataSource;

  AdminShopRepositoryImpl({
    required IAdminShopRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<AdminShopResponse> getShops({
    required int page,
    required int limit,
    String? searchQuery,
    String? statusFilter,
    String? categoryFilter,
  }) async {
    final allShops = await _remoteDataSource.getAllApprovedShops();

    final totalShops = allShops.length;
    final activeShops = allShops.where((shop) => !shop.isSuspended).length;
    final suspendedShops = allShops.where((shop) => shop.isSuspended).length;

    final configuredCategories = await _remoteDataSource
        .getBusinessCategoryNames();
    final uniqueCategoriesSet = <String>{};
    uniqueCategoriesSet.addAll(configuredCategories);

    for (final shop in allShops) {
      if (shop.category.isNotEmpty) {
        uniqueCategoriesSet.add(shop.category);
      }
    }

    final uniqueCategories = uniqueCategoriesSet.toList();
    uniqueCategories.sort();

    var filteredShops = allShops;

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final query = searchQuery.trim().toLowerCase();
      filteredShops = filteredShops
          .where((shop) => shop.shopName.toLowerCase().contains(query))
          .toList();
    }

    if (statusFilter == 'Active') {
      filteredShops = filteredShops.where((shop) => !shop.isSuspended).toList();
    } else if (statusFilter == 'Suspended') {
      filteredShops = filteredShops.where((shop) => shop.isSuspended).toList();
    } else if (statusFilter == 'Category' &&
        categoryFilter != null &&
        categoryFilter.isNotEmpty) {
      filteredShops = filteredShops
          .where((shop) => shop.category == categoryFilter)
          .toList();
    }

    filteredShops.sort((a, b) {
      if (a.createdAt == null && b.createdAt == null) return 0;
      if (a.createdAt == null) return 1;
      if (b.createdAt == null) return -1;
      return b.createdAt!.compareTo(a.createdAt!);
    });

    final totalMatchingCount = filteredShops.length;

    final startIndex = (page - 1) * limit;
    List<ShopProfileModel> paginatedShops = [];
    if (startIndex < totalMatchingCount) {
      final endIndex = startIndex + limit > totalMatchingCount
          ? totalMatchingCount
          : startIndex + limit;
      paginatedShops = filteredShops.sublist(startIndex, endIndex);
    }

    return AdminShopResponse(
      shops: paginatedShops,
      totalMatchingCount: totalMatchingCount,
      totalShops: totalShops,
      activeShops: activeShops,
      suspendedShops: suspendedShops,
      availableCategories: uniqueCategories,
    );
  }

  @override
  Future<void> toggleShopSuspension({
    required String shopId,
    required bool isSuspended,
  }) async {
    await _remoteDataSource.updateShopSuspensionStatus(shopId, isSuspended);
  }

  @override
  Future<ShopProfileModel> getShopById(String shopId) async {
    return await _remoteDataSource.getShopById(shopId);
  }

  @override
  Future<void> deleteShop(String shopId) async {
    await _remoteDataSource.deleteShop(shopId);
  }

  @override
  Future<List<ProductModel>> getShopProducts(String shopId) async {
    return await _remoteDataSource.getProductsByShopId(shopId);
  }
}
