import '../repositories/admin_customer_repository.dart';

class GetAdminCustomersParams {
  final int page;
  final int limit;
  final String? searchQuery;
  final String? statusFilter;

  GetAdminCustomersParams({
    required this.page,
    required this.limit,
    this.searchQuery,
    this.statusFilter,
  });
}

class GetAdminCustomers {
  final IAdminCustomerRepository _repository;

  GetAdminCustomers(this._repository);

  Future<AdminCustomerResponse> call(GetAdminCustomersParams params) async {
    return await _repository.getCustomers(
      page: params.page,
      limit: params.limit,
      searchQuery: params.searchQuery,
      statusFilter: params.statusFilter,
    );
  }
}
