import 'package:street_cart/features/admin/products/domain/repositories/admin_product_repository.dart';

abstract class AdminProductState {}

// Product Initial State
class AdminProductInitial extends AdminProductState {}

// Product Loading State
class AdminProductLoading extends AdminProductState {}

// Product Loaded State
class AdminProductLoaded extends AdminProductState {
  final List<AdminProductItem> products;
  final int totalMatchingCount;
  final int totalProducts;
  final int activeItems;
  final int outOfStock;
  final int disabledItems;
  final List<String> availableCategories;

  final int currentPage;
  final int limit;
  final String searchQuery;
  final String statusFilter;
  final String? categoryFilter;

  AdminProductLoaded({
    required this.products,
    required this.totalMatchingCount,
    required this.totalProducts,
    required this.activeItems,
    required this.outOfStock,
    required this.disabledItems,
    required this.availableCategories,
    required this.currentPage,
    required this.limit,
    required this.searchQuery,
    required this.statusFilter,
    this.categoryFilter,
  });

  AdminProductLoaded copyWith({
    List<AdminProductItem>? products,
    int? totalMatchingCount,
    int? totalProducts,
    int? activeItems,
    int? outOfStock,
    int? disabledItems,
    List<String>? availableCategories,
    int? currentPage,
    int? limit,
    String? searchQuery,
    String? statusFilter,
    String? categoryFilter,
  }) {
    return AdminProductLoaded(
      products: products ?? this.products,
      totalMatchingCount: totalMatchingCount ?? this.totalMatchingCount,
      totalProducts: totalProducts ?? this.totalProducts,
      activeItems: activeItems ?? this.activeItems,
      outOfStock: outOfStock ?? this.outOfStock,
      disabledItems: disabledItems ?? this.disabledItems,
      availableCategories: availableCategories ?? this.availableCategories,
      currentPage: currentPage ?? this.currentPage,
      limit: limit ?? this.limit,
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: statusFilter ?? this.statusFilter,
      categoryFilter: categoryFilter ?? this.categoryFilter,
    );
  }
}

// Product Error State
class AdminProductError extends AdminProductState {
  final String message;

  AdminProductError(this.message);
}
