import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';

class AdminShopResponse {
  final List<ShopProfileModel> shops;
  final int totalMatchingCount;
  final int totalShops;
  final int activeShops;
  final int suspendedShops;
  final List<String> availableCategories;

  AdminShopResponse({
    required this.shops,
    required this.totalMatchingCount,
    required this.totalShops,
    required this.activeShops,
    required this.suspendedShops,
    required this.availableCategories,
  });
}

abstract class IAdminShopRepository {
  Future<AdminShopResponse> getShops({
    required int page,
    required int limit,
    String? searchQuery,
    String? statusFilter,
    String? categoryFilter,
  });

  Future<void> toggleShopSuspension({
    required String shopId,
    required bool isSuspended,
  });

  Future<ShopProfileModel> getShopById(String shopId);

  Future<void> deleteShop(String shopId);
}
