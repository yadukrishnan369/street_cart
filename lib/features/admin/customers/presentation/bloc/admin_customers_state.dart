import 'package:street_cart/features/admin/customers/data/models/customer_model.dart';

abstract class AdminCustomersState {}

// Admin Customers Initial State
class AdminCustomersInitial extends AdminCustomersState {}

// Admin Customers Loading State
class AdminCustomersLoading extends AdminCustomersState {}

// Admin Customers Loaded State
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

// Admin Customers Error State
class AdminCustomersError extends AdminCustomersState {
  final String message;

  AdminCustomersError(this.message);
}

// Admin Customers Action Success State
class AdminCustomersActionSuccess extends AdminCustomersState {
  final String message;

  AdminCustomersActionSuccess(this.message);
}
