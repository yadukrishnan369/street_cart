import '../../data/models/customer_model.dart';

abstract class AdminCustomersState {}

class AdminCustomersInitial extends AdminCustomersState {}

class AdminCustomersLoading extends AdminCustomersState {}

class AdminCustomersLoaded extends AdminCustomersState {
  final List<CustomerModel> customers;
  final int totalMatchingCount;
  final int totalCustomers;
  final int activeCustomers;
  final int blockedCustomers;
  final int currentPage;
  final int totalPages;
  final String searchQuery;
  final String statusFilter;

  AdminCustomersLoaded({
    required this.customers,
    required this.totalMatchingCount,
    required this.totalCustomers,
    required this.activeCustomers,
    required this.blockedCustomers,
    required this.currentPage,
    required this.totalPages,
    required this.searchQuery,
    required this.statusFilter,
  });
}

class AdminCustomersError extends AdminCustomersState {
  final String message;

  AdminCustomersError(this.message);
}

class AdminCustomersActionSuccess extends AdminCustomersState {
  final String message;

  AdminCustomersActionSuccess(this.message);
}
