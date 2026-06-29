import 'package:street_cart/features/admin/products/domain/repositories/admin_product_repository.dart';

class GetAdminProductsParams {
  final int page;
  final int limit;
  final String? searchQuery;
  final String? statusFilter;
  final String? categoryFilter;

  GetAdminProductsParams({
    required this.page,
    required this.limit,
    this.searchQuery,
    this.statusFilter,
    this.categoryFilter,
  });
}

class GetAdminProducts {
  final IAdminProductRepository _repository;

  GetAdminProducts(this._repository);

  Future<AdminProductResponse> call(GetAdminProductsParams params) async {
    return await _repository.getProducts(
      page: params.page,
      limit: params.limit,
      searchQuery: params.searchQuery,
      statusFilter: params.statusFilter,
      categoryFilter: params.categoryFilter,
    );
  }
}
