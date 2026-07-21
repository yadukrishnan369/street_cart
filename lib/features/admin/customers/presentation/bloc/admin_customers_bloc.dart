import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/admin/customers/domain/usecases/get_admin_customers.dart';
import 'package:street_cart/features/admin/customers/domain/usecases/toggle_customer_status.dart';
import 'admin_customers_event.dart';
import 'admin_customers_state.dart';

class AdminCustomersBloc
    extends Bloc<AdminCustomersEvent, AdminCustomersState> {
  final GetAdminCustomers _getAdminCustomers;
  final ToggleCustomerBlockStatus _toggleCustomerBlockStatus;

  String _searchQuery = '';
  String _statusFilter = 'All';
  int _currentPage = 1;
  int _limit = 7;

  AdminCustomersBloc({
    required GetAdminCustomers getAdminCustomers,
    required ToggleCustomerBlockStatus toggleCustomerBlockStatus,
  }) : _getAdminCustomers = getAdminCustomers,
       _toggleCustomerBlockStatus = toggleCustomerBlockStatus,
       super(AdminCustomersInitial()) {
    on<LoadAdminCustomers>(_onLoadAdminCustomers);
    on<SearchCustomersQueryChanged>(_onSearchCustomersQueryChanged);
    on<FilterCustomersStatusChanged>(_onFilterCustomersStatusChanged);
    on<ToggleCustomerBlockRequested>(_onToggleCustomerBlockRequested);
  }

  // Fetching the list of customers
  Future<void> _onLoadAdminCustomers(
    LoadAdminCustomers event,
    Emitter<AdminCustomersState> emit,
  ) async {
    _currentPage = event.page;
    _limit = event.limit;
    emit(AdminCustomersLoading());
    try {
      final response = await _getAdminCustomers(
        GetAdminCustomersParams(
          page: _currentPage,
          limit: _limit,
          searchQuery: _searchQuery,
          statusFilter: _statusFilter,
        ),
      );

      final totalPages = (response.totalMatchingCount / _limit).ceil();

      emit(
        AdminCustomersLoaded(
          customers: response.customers,
          totalMatchingCount: response.totalMatchingCount,
          totalCustomers: response.totalCustomers,
          activeCustomers: response.activeCustomers,
          blockedCustomers: response.blockedCustomers,
          currentPage: _currentPage,
          totalPages: totalPages < 1 ? 1 : totalPages,
          searchQuery: _searchQuery,
          statusFilter: _statusFilter,
        ),
      );
    } catch (e) {
      emit(AdminCustomersError(e.toString()));
    }
  }

  // Refetches list of customer by search
  Future<void> _onSearchCustomersQueryChanged(
    SearchCustomersQueryChanged event,
    Emitter<AdminCustomersState> emit,
  ) async {
    _searchQuery = event.query;
    _currentPage = 1;
    add(LoadAdminCustomers(page: _currentPage, limit: _limit));
  }

  // Refetches list of customer by Filter
  Future<void> _onFilterCustomersStatusChanged(
    FilterCustomersStatusChanged event,
    Emitter<AdminCustomersState> emit,
  ) async {
    _statusFilter = event.status;
    _currentPage = 1;
    add(LoadAdminCustomers(page: _currentPage, limit: _limit));
  }

  // Updates a customer block state
  Future<void> _onToggleCustomerBlockRequested(
    ToggleCustomerBlockRequested event,
    Emitter<AdminCustomersState> emit,
  ) async {
    emit(AdminCustomersLoading());
    try {
      await _toggleCustomerBlockStatus(
        ToggleCustomerBlockStatusParams(
          uid: event.uid,
          isBlocked: event.isBlocked,
        ),
      );
      emit(
        AdminCustomersActionSuccess(
          event.isBlocked
              ? 'Customer blocked successfully'
              : 'Customer unblocked successfully',
        ),
      );
      final response = await _getAdminCustomers(
        GetAdminCustomersParams(
          page: _currentPage,
          limit: _limit,
          searchQuery: _searchQuery,
          statusFilter: _statusFilter,
        ),
      );
      final totalPages = (response.totalMatchingCount / _limit).ceil();
      emit(
        AdminCustomersLoaded(
          customers: response.customers,
          totalMatchingCount: response.totalMatchingCount,
          totalCustomers: response.totalCustomers,
          activeCustomers: response.activeCustomers,
          blockedCustomers: response.blockedCustomers,
          currentPage: _currentPage,
          totalPages: totalPages < 1 ? 1 : totalPages,
          searchQuery: _searchQuery,
          statusFilter: _statusFilter,
        ),
      );
    } catch (e) {
      emit(AdminCustomersError(e.toString()));
    }
  }
}
