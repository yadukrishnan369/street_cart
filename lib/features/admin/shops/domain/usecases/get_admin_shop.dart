import 'package:street_cart/features/admin/shops/domain/repositories/admin_shop_repository.dart';

class GetAdminShopParams {
  final int page;
  final int limit;
  final String? searchQuery;
  final String? statusFilter;
  final String? categoryFilter;

  GetAdminShopParams({
    required this.page,
    required this.limit,
    this.searchQuery,
    this.statusFilter,
    this.categoryFilter,
  });
}

class GetAdminShop {
  final IAdminShopRepository _repository;

  GetAdminShop(this._repository);

  Future<AdminShopResponse> call(GetAdminShopParams params) async {
    return await _repository.getShops(
      page: params.page,
      limit: params.limit,
      searchQuery: params.searchQuery,
      statusFilter: params.statusFilter,
      categoryFilter: params.categoryFilter,
    );
  }
}

class ToggleShopSuspensionParams {
  final String shopId;
  final bool isSuspended;

  ToggleShopSuspensionParams({required this.shopId, required this.isSuspended});
}

class ToggleShopSuspension {
  final IAdminShopRepository _repository;

  ToggleShopSuspension(this._repository);

  Future<void> call(ToggleShopSuspensionParams params) async {
    return await _repository.toggleShopSuspension(
      shopId: params.shopId,
      isSuspended: params.isSuspended,
    );
  }
}
