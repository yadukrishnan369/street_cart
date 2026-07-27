import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/shop/sales_analytics/presentation/utils/sales_analytics_helper.dart';

abstract class SalesAnalyticsState {}

// Sales Analytics Initial State
class SalesAnalyticsInitial extends SalesAnalyticsState {}

// Sales Analytics Loading State
class SalesAnalyticsLoading extends SalesAnalyticsState {}

// Sales Analytics Loaded State
class SalesAnalyticsLoaded extends SalesAnalyticsState {
  final List<OrderModel> allOrders;
  final List<OrderModel> filteredOrders;
  final Map<String, String> productCategories;
  final List<String> availableCategories;
  final String selectedTimeframe;
  final String selectedCategory;
  final DateTime? customStartDate;
  final DateTime? customEndDate;
  final double totalEarnings;
  final double todayEarnings;
  final double weekEarnings;
  final double monthEarnings;
  final Map<String, int> orderSummary;
  final List<AnalyticsTransactionItem> recentTransactions;

  SalesAnalyticsLoaded({
    required this.allOrders,
    required this.filteredOrders,
    required this.productCategories,
    required this.availableCategories,
    required this.selectedTimeframe,
    required this.selectedCategory,
    this.customStartDate,
    this.customEndDate,
    required this.totalEarnings,
    required this.todayEarnings,
    required this.weekEarnings,
    required this.monthEarnings,
    required this.orderSummary,
    required this.recentTransactions,
  });

  SalesAnalyticsLoaded copyWith({
    List<OrderModel>? allOrders,
    List<OrderModel>? filteredOrders,
    Map<String, String>? productCategories,
    List<String>? availableCategories,
    String? selectedTimeframe,
    String? selectedCategory,
    DateTime? customStartDate,
    DateTime? customEndDate,
    double? totalEarnings,
    double? todayEarnings,
    double? weekEarnings,
    double? monthEarnings,
    Map<String, int>? orderSummary,
    List<AnalyticsTransactionItem>? recentTransactions,
  }) {
    return SalesAnalyticsLoaded(
      allOrders: allOrders ?? this.allOrders,
      filteredOrders: filteredOrders ?? this.filteredOrders,
      productCategories: productCategories ?? this.productCategories,
      availableCategories: availableCategories ?? this.availableCategories,
      selectedTimeframe: selectedTimeframe ?? this.selectedTimeframe,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      customStartDate: customStartDate ?? this.customStartDate,
      customEndDate: customEndDate ?? this.customEndDate,
      totalEarnings: totalEarnings ?? this.totalEarnings,
      todayEarnings: todayEarnings ?? this.todayEarnings,
      weekEarnings: weekEarnings ?? this.weekEarnings,
      monthEarnings: monthEarnings ?? this.monthEarnings,
      orderSummary: orderSummary ?? this.orderSummary,
      recentTransactions: recentTransactions ?? this.recentTransactions,
    );
  }
}

// Sales Analytics Error State
class SalesAnalyticsError extends SalesAnalyticsState {
  final String message;

  SalesAnalyticsError({required this.message});
}
