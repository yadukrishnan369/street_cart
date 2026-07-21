import 'package:street_cart/features/customer/profile/data/models/address_model.dart';
import 'package:street_cart/features/admin/customers/domain/repositories/admin_customer_repository.dart';
import 'package:street_cart/features/admin/customers/data/datasources/admin_customer_remote_datasource.dart';
import 'package:street_cart/features/admin/customers/data/models/customer_model.dart';

class AdminCustomerRepositoryImpl implements IAdminCustomerRepository {
  final IAdminCustomerRemoteDataSource _remoteDataSource;

  AdminCustomerRepositoryImpl({
    required IAdminCustomerRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<AdminCustomerResponse> getCustomers({
    required int page,
    required int limit,
    String? searchQuery,
    String? statusFilter,
  }) async {
    final allCustomers = await _remoteDataSource.getAllCustomers();

    final totalCustomers = allCustomers.length;
    final activeCustomers = allCustomers.where((c) => !c.isBlocked).length;
    final blockedCustomers = allCustomers.where((c) => c.isBlocked).length;

    var filteredCustomers = allCustomers;

    // Search filter
    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final query = searchQuery.trim().toLowerCase();
      filteredCustomers = filteredCustomers
          .where(
            (c) =>
                c.fullName.toLowerCase().contains(query) ||
                c.email.toLowerCase().contains(query),
          )
          .toList();
    }

    // Status filter
    if (statusFilter == 'Active') {
      filteredCustomers = filteredCustomers.where((c) => !c.isBlocked).toList();
    } else if (statusFilter == 'Blocked') {
      filteredCustomers = filteredCustomers.where((c) => c.isBlocked).toList();
    }

    final totalMatchingCount = filteredCustomers.length;

    // Pagination
    final startIndex = (page - 1) * limit;
    List<CustomerModel> paginatedCustomers = [];
    if (startIndex < totalMatchingCount) {
      final endIndex = startIndex + limit > totalMatchingCount
          ? totalMatchingCount
          : startIndex + limit;
      paginatedCustomers = filteredCustomers.sublist(startIndex, endIndex);
    }

    return AdminCustomerResponse(
      customers: paginatedCustomers,
      totalMatchingCount: totalMatchingCount,
      totalCustomers: totalCustomers,
      activeCustomers: activeCustomers,
      blockedCustomers: blockedCustomers,
    );
  }

  @override
  Future<void> toggleCustomerBlockStatus({
    required String uid,
    required bool isBlocked,
  }) async {
    await _remoteDataSource.updateCustomerBlockStatus(uid, isBlocked);
  }

  @override
  Future<CustomerModel> getCustomerById(String uid) async {
    return await _remoteDataSource.getCustomerById(uid);
  }

  @override
  Future<List<AddressModel>> getCustomerAddresses(String uid) async {
    return await _remoteDataSource.getCustomerAddresses(uid);
  }

  @override
  Future<void> deleteCustomer(String uid) async {
    await _remoteDataSource.deleteCustomer(uid);
  }
}
