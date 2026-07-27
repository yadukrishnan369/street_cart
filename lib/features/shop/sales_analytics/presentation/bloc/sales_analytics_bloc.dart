import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/shop/sales_analytics/domain/usecases/get_sales_analytics.dart';
import 'package:street_cart/features/shop/sales_analytics/presentation/utils/sales_analytics_helper.dart';
import 'sales_analytics_event.dart';
import 'sales_analytics_state.dart';

class SalesAnalyticsBloc
    extends Bloc<SalesAnalyticsEvent, SalesAnalyticsState> {
  final GetSalesAnalytics getSalesAnalytics;
  late String _shopId;

  SalesAnalyticsBloc({required this.getSalesAnalytics})
    : super(SalesAnalyticsInitial()) {
    on<FetchSalesAnalyticsData>(_onFetchSalesAnalyticsData);
    on<ChangeTimeframeFilter>(_onChangeTimeframeFilter);
    on<ChangeCustomDateRangeFilter>(_onChangeCustomDateRangeFilter);
    on<ChangeCategoryFilter>(_onChangeCategoryFilter);
  }
  // Fetch Sales Analytics Data
  Future<void> _onFetchSalesAnalyticsData(
    FetchSalesAnalyticsData event,
    Emitter<SalesAnalyticsState> emit,
  ) async {
    _shopId = event.shopId;
    emit(SalesAnalyticsLoading());
    try {
      final (allOrders, allProducts) = await getSalesAnalytics(_shopId);

      // Map productId to its category
      final Map<String, String> productCategories = {};
      final Set<String> categoriesSet = {};
      for (final p in allProducts) {
        if (p.category.isNotEmpty) {
          productCategories[p.id] = p.category;
          categoriesSet.add(p.category);
        }
      }

      final List<String> availableCategories = [
        'All',
        ...categoriesSet.toList()..sort(),
      ];

      // Default filter Today and All
      final double todayEarnings = _calculateFixedEarnings(
        allOrders,
        productCategories,
        'All',
        'Today',
      );
      final double weekEarnings = _calculateFixedEarnings(
        allOrders,
        productCategories,
        'All',
        'Week',
      );
      final double monthEarnings = _calculateFixedEarnings(
        allOrders,
        productCategories,
        'All',
        'Month',
      );

      final categoryFilteredOrders =
          SalesAnalyticsHelper.filterOrdersByCategory(
            allOrders,
            _shopId,
            productCategories,
            'All',
          );
      final filteredOrders = SalesAnalyticsHelper.filterOrdersByTimeframe(
        categoryFilteredOrders,
        'Today',
      );
      final totalEarnings = SalesAnalyticsHelper.calculateTotalEarnings(
        filteredOrders,
        _shopId,
        productCategories,
        'All',
      );
      final orderSummary = SalesAnalyticsHelper.calculateOrderSummary(
        filteredOrders,
      );
      final recentTransactions = SalesAnalyticsHelper.getRecentTransactions(
        filteredOrders,
        _shopId,
        productCategories,
        'All',
      );

      emit(
        SalesAnalyticsLoaded(
          allOrders: allOrders,
          filteredOrders: filteredOrders,
          productCategories: productCategories,
          availableCategories: availableCategories,
          selectedTimeframe: 'Today',
          selectedCategory: 'All',
          totalEarnings: totalEarnings,
          todayEarnings: todayEarnings,
          weekEarnings: weekEarnings,
          monthEarnings: monthEarnings,
          orderSummary: orderSummary,
          recentTransactions: recentTransactions,
        ),
      );
    } catch (e) {
      emit(SalesAnalyticsError(message: e.toString()));
    }
  }

  // Change Time frame Filter
  void _onChangeTimeframeFilter(
    ChangeTimeframeFilter event,
    Emitter<SalesAnalyticsState> emit,
  ) {
    if (state is SalesAnalyticsLoaded) {
      final current = state as SalesAnalyticsLoaded;

      final categoryFilteredOrders =
          SalesAnalyticsHelper.filterOrdersByCategory(
            current.allOrders,
            _shopId,
            current.productCategories,
            current.selectedCategory,
          );

      final filteredOrders = SalesAnalyticsHelper.filterOrdersByTimeframe(
        categoryFilteredOrders,
        event.timeframe,
      );

      final totalEarnings = SalesAnalyticsHelper.calculateTotalEarnings(
        filteredOrders,
        _shopId,
        current.productCategories,
        current.selectedCategory,
      );

      final orderSummary = SalesAnalyticsHelper.calculateOrderSummary(
        filteredOrders,
      );

      final recentTransactions = SalesAnalyticsHelper.getRecentTransactions(
        filteredOrders,
        _shopId,
        current.productCategories,
        current.selectedCategory,
      );

      emit(
        current.copyWith(
          filteredOrders: filteredOrders,
          selectedTimeframe: event.timeframe,
          customStartDate: null,
          customEndDate: null,
          totalEarnings: totalEarnings,
          orderSummary: orderSummary,
          recentTransactions: recentTransactions,
        ),
      );
    }
  }

  // Change Custom Date Range Filter
  void _onChangeCustomDateRangeFilter(
    ChangeCustomDateRangeFilter event,
    Emitter<SalesAnalyticsState> emit,
  ) {
    if (state is SalesAnalyticsLoaded) {
      final current = state as SalesAnalyticsLoaded;

      final categoryFilteredOrders =
          SalesAnalyticsHelper.filterOrdersByCategory(
            current.allOrders,
            _shopId,
            current.productCategories,
            current.selectedCategory,
          );

      final filteredOrders = SalesAnalyticsHelper.filterOrdersByDateRange(
        categoryFilteredOrders,
        event.startDate,
        event.endDate,
      );

      final totalEarnings = SalesAnalyticsHelper.calculateTotalEarnings(
        filteredOrders,
        _shopId,
        current.productCategories,
        current.selectedCategory,
      );

      final orderSummary = SalesAnalyticsHelper.calculateOrderSummary(
        filteredOrders,
      );

      final recentTransactions = SalesAnalyticsHelper.getRecentTransactions(
        filteredOrders,
        _shopId,
        current.productCategories,
        current.selectedCategory,
      );

      emit(
        current.copyWith(
          filteredOrders: filteredOrders,
          selectedTimeframe: 'Custom',
          customStartDate: event.startDate,
          customEndDate: event.endDate,
          totalEarnings: totalEarnings,
          orderSummary: orderSummary,
          recentTransactions: recentTransactions,
        ),
      );
    }
  }

  // Change Category Filter
  void _onChangeCategoryFilter(
    ChangeCategoryFilter event,
    Emitter<SalesAnalyticsState> emit,
  ) {
    if (state is SalesAnalyticsLoaded) {
      final current = state as SalesAnalyticsLoaded;

      // Recalculate Today, Week, Month static earnings for new category
      final double todayEarnings = _calculateFixedEarnings(
        current.allOrders,
        current.productCategories,
        event.category,
        'Today',
      );
      final double weekEarnings = _calculateFixedEarnings(
        current.allOrders,
        current.productCategories,
        event.category,
        'Week',
      );
      final double monthEarnings = _calculateFixedEarnings(
        current.allOrders,
        current.productCategories,
        event.category,
        'Month',
      );

      // Filter all orders by the new selected category
      final categoryFilteredOrders =
          SalesAnalyticsHelper.filterOrdersByCategory(
            current.allOrders,
            _shopId,
            current.productCategories,
            event.category,
          );

      // Reapply timeframe/date range filter
      List<OrderModel> filteredOrders;
      if (current.selectedTimeframe == 'Custom' &&
          current.customStartDate != null &&
          current.customEndDate != null) {
        filteredOrders = SalesAnalyticsHelper.filterOrdersByDateRange(
          categoryFilteredOrders,
          current.customStartDate!,
          current.customEndDate!,
        );
      } else {
        filteredOrders = SalesAnalyticsHelper.filterOrdersByTimeframe(
          categoryFilteredOrders,
          current.selectedTimeframe,
        );
      }

      final totalEarnings = SalesAnalyticsHelper.calculateTotalEarnings(
        filteredOrders,
        _shopId,
        current.productCategories,
        event.category,
      );

      final orderSummary = SalesAnalyticsHelper.calculateOrderSummary(
        filteredOrders,
      );

      final recentTransactions = SalesAnalyticsHelper.getRecentTransactions(
        filteredOrders,
        _shopId,
        current.productCategories,
        event.category,
      );

      emit(
        current.copyWith(
          filteredOrders: filteredOrders,
          selectedCategory: event.category,
          totalEarnings: totalEarnings,
          todayEarnings: todayEarnings,
          weekEarnings: weekEarnings,
          monthEarnings: monthEarnings,
          orderSummary: orderSummary,
          recentTransactions: recentTransactions,
        ),
      );
    }
  }

  // Calculate Fixed Earnings
  double _calculateFixedEarnings(
    List<OrderModel> orders,
    Map<String, String> productCategories,
    String category,
    String type,
  ) {
    final now = DateTime.now();
    DateTime start;
    if (type == 'Today') {
      start = DateTime(now.year, now.month, now.day);
    } else if (type == 'Week') {
      start = now.subtract(const Duration(days: 7));
    } else {
      start = now.subtract(const Duration(days: 30));
    }

    return SalesAnalyticsHelper.calculateTimeframeEarnings(
      orders: orders,
      shopId: _shopId,
      productCategories: productCategories,
      selectedCategory: category,
      start: start,
      end: now,
    );
  }
}
