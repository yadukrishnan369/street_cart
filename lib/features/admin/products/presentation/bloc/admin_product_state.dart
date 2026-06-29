import 'package:street_cart/features/admin/products/domain/repositories/admin_product_repository.dart';

abstract class AdminProductState {}

class AdminProductInitial extends AdminProductState {}

class AdminProductLoading extends AdminProductState {}

class AdminProductLoaded extends AdminProductState {
  final List<AdminProductItem> products;
  final int totalMatchingCount;
  final int totalProducts;
  final int activeItems;
  final int outOfStock;
  final int disabledItems;
  final List<String> availableCategories;

  // Keep state track
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
}

class AdminProductError extends AdminProductState {
  final String message;

  AdminProductError(this.message);
}
