import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';

abstract class AdminShopState {}

class AdminShopInitial extends AdminShopState {}

class AdminShopLoading extends AdminShopState {}

class AdminShopLoaded extends AdminShopState {
  final List<ShopProfileModel> shops;
  final int totalMatchingCount;
  final int totalShops;
  final int activeShops;
  final int suspendedShops;
  final List<String> availableCategories;

  final int currentPage;
  final int limit;
  final String searchQuery;
  final String statusFilter;
  final String? categoryFilter;

  int get totalPages => (totalMatchingCount / limit).ceil() == 0 ? 1 : (totalMatchingCount / limit).ceil();

  AdminShopLoaded({
    required this.shops,
    required this.totalMatchingCount,
    required this.totalShops,
    required this.activeShops,
    required this.suspendedShops,
    required this.availableCategories,
    required this.currentPage,
    required this.limit,
    required this.searchQuery,
    required this.statusFilter,
    this.categoryFilter,
  });

  AdminShopLoaded copyWith({
    List<ShopProfileModel>? shops,
    int? totalMatchingCount,
    int? totalShops,
    int? activeShops,
    int? suspendedShops,
    List<String>? availableCategories,
    int? currentPage,
    int? limit,
    String? searchQuery,
    String? statusFilter,
    String? categoryFilter,
  }) {
    return AdminShopLoaded(
      shops: shops ?? this.shops,
      totalMatchingCount: totalMatchingCount ?? this.totalMatchingCount,
      totalShops: totalShops ?? this.totalShops,
      activeShops: activeShops ?? this.activeShops,
      suspendedShops: suspendedShops ?? this.suspendedShops,
      availableCategories: availableCategories ?? this.availableCategories,
      currentPage: currentPage ?? this.currentPage,
      limit: limit ?? this.limit,
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: statusFilter ?? this.statusFilter,
      categoryFilter: categoryFilter ?? this.categoryFilter,
    );
  }
}

class AdminShopError extends AdminShopState {
  final String message;

  AdminShopError(this.message);
}

class AdminShopActionSuccess extends AdminShopState {
  final String message;

  AdminShopActionSuccess(this.message);
}
