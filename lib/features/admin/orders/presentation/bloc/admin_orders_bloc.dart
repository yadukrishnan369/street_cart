import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/admin/orders/domain/usecases/get_admin_orders.dart';
import 'package:street_cart/features/admin/orders/presentation/utils/admin_orders_helper.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'admin_orders_event.dart';
import 'admin_orders_state.dart';

class AdminOrdersBloc extends Bloc<AdminOrdersEvent, AdminOrdersState> {
  final GetAdminOrders _getAdminOrders;
  StreamSubscription? _subscription;

  List<OrderModel> _allOrders = [];
  Map<String, String> _shopNames = {};
  Map<String, ShopProfileModel> _shopProfiles = {};
  Map<String, String> _customerNames = {};
  Map<String, String> _customerEmails = {};
  String _currentQuery = '';
  int _activeTab = 0;

  AdminOrdersBloc({required GetAdminOrders getAdminOrders})
    : _getAdminOrders = getAdminOrders,
      super(AdminOrdersInitial()) {
    on<LoadAdminOrders>(_onLoadAdminOrders);
    on<OrdersUpdated>(_onOrdersUpdated);
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<FilterTabChanged>(_onFilterTabChanged);
  }

  Future<void> _onLoadAdminOrders(
    LoadAdminOrders event,
    Emitter<AdminOrdersState> emit,
  ) async {
    emit(AdminOrdersLoading());
    await _subscription?.cancel();

    try {
      _shopNames = await _getAdminOrders.fetchShopNames();
      _shopProfiles = await _getAdminOrders.fetchShopProfiles();
      _customerNames = await _getAdminOrders.fetchCustomerNames();
      _customerEmails = await _getAdminOrders.fetchCustomerEmails();
      _subscription = _getAdminOrders.execute().listen((orders) {
        add(
          OrdersUpdated(
            orders: orders,
            shopNames: _shopNames,
            customerNames: _customerNames,
            customerEmails: _customerEmails,
          ),
        );
      });
    } catch (e) {
      emit(AdminOrdersFailure(message: e.toString()));
    }
  }

  void _onOrdersUpdated(OrdersUpdated event, Emitter<AdminOrdersState> emit) {
    _allOrders = event.orders;
    _shopNames = event.shopNames;
    _customerNames = event.customerNames;
    _customerEmails = event.customerEmails;
    _emitFilteredState(emit);
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<AdminOrdersState> emit,
  ) async {
    _currentQuery = event.query;
    emit(AdminOrdersLoading());
    // Small delay to show the progress indicator
    await Future.delayed(const Duration(milliseconds: 300));
    _emitFilteredState(emit);
  }

  Future<void> _onFilterTabChanged(
    FilterTabChanged event,
    Emitter<AdminOrdersState> emit,
  ) async {
    _activeTab = event.tabIndex;
    emit(AdminOrdersLoading());
    // Small delay to show the progress indicator
    await Future.delayed(const Duration(milliseconds: 300));
    _emitFilteredState(emit);
  }

  void _emitFilteredState(Emitter<AdminOrdersState> emit) {
    final filtered = AdminOrdersHelper.getFilteredOrders(
      orders: _allOrders,
      shopNames: _shopNames,
      activeTab: _activeTab,
      query: _currentQuery,
    );

    emit(
      AdminOrdersLoaded(
        orders: filtered,
        shopNames: _shopNames,
        shopProfiles: _shopProfiles,
        customerNames: _customerNames,
        customerEmails: _customerEmails,
        searchQuery: _currentQuery,
        activeTab: _activeTab,
      ),
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
