import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/admin/revenue/domain/usecases/get_revenue_customers.dart';
import 'package:street_cart/features/admin/revenue/domain/usecases/get_revenue_orders.dart';
import 'package:street_cart/features/admin/revenue/domain/usecases/get_revenue_products.dart';
import 'package:street_cart/features/admin/revenue/domain/usecases/get_revenue_shops.dart';
import 'package:street_cart/features/admin/revenue/presentation/utils/admin_revenue_helper.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'admin_revenue_event.dart';
import 'admin_revenue_state.dart';

class AdminRevenueBloc extends Bloc<AdminRevenueEvent, AdminRevenueState> {
  final GetRevenueOrders _getOrders;
  final GetRevenueShops _getShops;
  final GetRevenueProducts _getProducts;
  final GetRevenueCustomers _getCustomers;

  static const int _perPage = 8;

  AdminRevenueBloc({
    required GetRevenueOrders getOrders,
    required GetRevenueShops getShops,
    required GetRevenueProducts getProducts,
    required GetRevenueCustomers getCustomers,
  }) : _getOrders = getOrders,
       _getShops = getShops,
       _getProducts = getProducts,
       _getCustomers = getCustomers,
       super(AdminRevenueInitial()) {
    on<LoadAdminRevenueData>(_onLoad);
    on<ResetRevenueFilters>(_onResetFilters);
    on<RevenueFilterChanged>(_onFilterChanged);
    on<RevenueSearchChanged>(_onSearchChanged);
    on<RevenuePageChanged>(_onPageChanged);
  }

  // Load Initial Revenue Data
  FutureOr<void> _onLoad(
    LoadAdminRevenueData event,
    Emitter<AdminRevenueState> emit,
  ) async {
    emit(AdminRevenueLoading());
    try {
      // Fetch all data
      final results = await Future.wait([
        _getOrders(),
        _getShops(),
        _getProducts(),
        _getCustomers(),
      ]);

      final orders = results[0] as List<OrderModel>;
      final shops = results[1] as dynamic;
      final products = results[2] as dynamic;
      final customers = results[3] as dynamic;

      // Keep only delivered orders
      final completedOrders = AdminRevenueHelper.filterCompletedOrdersOnly(
        orders,
      );
      // Dropdown category options from fetched data
      final businessCats = AdminRevenueHelper.getBusinessCategories(shops);
      final productCats = AdminRevenueHelper.getProductCategories(products);

      // Default All filters on the initial load
      final filtered = AdminRevenueHelper.applyFilters(
        orders: completedOrders,
        shops: shops,
        products: products,
        customers: customers,
        businessCategory: 'All',
        productCategory: 'All',
        timeframe: 'All Time',
        searchQuery: '',
      );

      final totalPages = _calcPages(filtered.length);

      emit(
        AdminRevenueLoaded(
          allOrders: completedOrders,
          filteredOrders: filtered,
          paginatedOrders: _paginate(filtered, 1),
          shops: shops,
          products: products,
          customers: customers,
          businessCategories: businessCats,
          productCategories: productCats,
          selectedBusinessCategory: 'All',
          selectedProductCategory: 'All',
          selectedTimeframe: 'All Time',
          searchQuery: '',
          currentPage: 1,
          totalPages: totalPages,
          totalRevenue: AdminRevenueHelper.computeTotalRevenue(filtered),
          todayRevenue: AdminRevenueHelper.computeTodayRevenue(completedOrders),
          lastMonthRevenue: AdminRevenueHelper.computeLastMonthRevenue(
            completedOrders,
          ),
          isSearching: false,
        ),
      );
    } catch (e) {
      emit(AdminRevenueError(e.toString()));
    }
  }

  // Reset Filters back to defaults
  FutureOr<void> _onResetFilters(
    ResetRevenueFilters event,
    Emitter<AdminRevenueState> emit,
  ) {
    if (state is! AdminRevenueLoaded) return null;
    final current = state as AdminRevenueLoaded;

    // Reset dropdown selections back to default
    final filtered = AdminRevenueHelper.applyFilters(
      orders: current.allOrders,
      shops: current.shops,
      products: current.products,
      customers: current.customers,
      businessCategory: 'All',
      productCategory: 'All',
      timeframe: 'All Time',
      searchQuery: current.searchQuery,
    );

    final totalPages = _calcPages(filtered.length);
    emit(
      current.copyWith(
        filteredOrders: filtered,
        paginatedOrders: _paginate(filtered, 1),
        selectedBusinessCategory: 'All',
        selectedProductCategory: 'All',
        selectedTimeframe: 'All Time',
        clearCustomStart: true,
        clearCustomEnd: true,
        currentPage: 1,
        totalPages: totalPages,
        totalRevenue: AdminRevenueHelper.computeTotalRevenue(filtered),
      ),
    );
  }

  // Category and Timeframe Filter Selection
  FutureOr<void> _onFilterChanged(
    RevenueFilterChanged event,
    Emitter<AdminRevenueState> emit,
  ) {
    if (state is! AdminRevenueLoaded) return null;
    final current = state as AdminRevenueLoaded;

    final bizCat = event.businessCategory ?? current.selectedBusinessCategory;
    final prodCat = event.productCategory ?? current.selectedProductCategory;
    final timeframe = event.timeframe ?? current.selectedTimeframe;
    final customStart = event.customStart ?? current.customStart;
    final customEnd = event.customEnd ?? current.customEnd;

    // Filter orders list based on selected dropdown options
    final filtered = AdminRevenueHelper.applyFilters(
      orders: current.allOrders,
      shops: current.shops,
      products: current.products,
      customers: current.customers,
      businessCategory: bizCat,
      productCategory: prodCat,
      timeframe: timeframe,
      customStart: customStart,
      customEnd: customEnd,
      searchQuery: current.searchQuery,
    );

    final totalPages = _calcPages(filtered.length);
    emit(
      current.copyWith(
        filteredOrders: filtered,
        paginatedOrders: _paginate(filtered, 1),
        selectedBusinessCategory: bizCat,
        selectedProductCategory: prodCat,
        selectedTimeframe: timeframe,
        customStart: customStart,
        customEnd: customEnd,
        currentPage: 1,
        totalPages: totalPages,
        // Recalculate total revenue based on the newly filtered list
        totalRevenue: AdminRevenueHelper.computeTotalRevenue(filtered),
      ),
    );
  }

  // Table Search Query Changes
  FutureOr<void> _onSearchChanged(
    RevenueSearchChanged event,
    Emitter<AdminRevenueState> emit,
  ) async {
    if (state is! AdminRevenueLoaded) return null;
    final current = state as AdminRevenueLoaded;

    // Show linear loading indicator
    emit(current.copyWith(isSearching: true));
    await Future.delayed(const Duration(milliseconds: 300));

    final filtered = AdminRevenueHelper.applyFilters(
      orders: current.allOrders,
      shops: current.shops,
      products: current.products,
      customers: current.customers,
      businessCategory: current.selectedBusinessCategory,
      productCategory: current.selectedProductCategory,
      timeframe: current.selectedTimeframe,
      customStart: current.customStart,
      customEnd: current.customEnd,
      searchQuery: event.query,
    );

    final totalPages = _calcPages(filtered.length);
    emit(
      current.copyWith(
        filteredOrders: filtered,
        paginatedOrders: _paginate(filtered, 1),
        searchQuery: event.query,
        currentPage: 1,
        totalPages: totalPages,
        totalRevenue: AdminRevenueHelper.computeTotalRevenue(filtered),
        isSearching: false,
      ),
    );
  }

  // Table Pagination Page Change
  FutureOr<void> _onPageChanged(
    RevenuePageChanged event,
    Emitter<AdminRevenueState> emit,
  ) {
    if (state is! AdminRevenueLoaded) return null;
    final current = state as AdminRevenueLoaded;
    if (event.page < 1 || event.page > current.totalPages) return null;

    emit(
      current.copyWith(
        paginatedOrders: _paginate(current.filteredOrders, event.page),
        currentPage: event.page,
      ),
    );
  }

  // Paginate
  List<OrderModel> _paginate(List<OrderModel> list, int page) {
    final start = (page - 1) * _perPage;
    if (start >= list.length) return [];
    final end = start + _perPage;
    return list.sublist(start, end > list.length ? list.length : end);
  }

  // Calculate total number of pages
  int _calcPages(int total) {
    final pages = (total / _perPage).ceil();
    return pages == 0 ? 1 : pages;
  }
}
