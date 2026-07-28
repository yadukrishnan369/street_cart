import 'package:street_cart/features/admin/customers/data/models/customer_model.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';

abstract class AdminRevenueState {
  const AdminRevenueState();
}

// Revenue Initial State
class AdminRevenueInitial extends AdminRevenueState {}

// Revenue Loading State
class AdminRevenueLoading extends AdminRevenueState {}

// Revenue Loaded State
class AdminRevenueLoaded extends AdminRevenueState {
  final List<OrderModel> allOrders;
  final List<OrderModel> filteredOrders;
  final List<OrderModel> paginatedOrders;
  final List<ShopProfileModel> shops;
  final List<ProductModel> products;
  final List<CustomerModel> customers;
  final List<String> businessCategories;
  final List<String> productCategories;
  final String selectedBusinessCategory;
  final String selectedProductCategory;
  final String selectedTimeframe;
  final DateTime? customStart;
  final DateTime? customEnd;
  final String searchQuery;
  final int currentPage;
  final int totalPages;
  final double totalRevenue;
  final double todayRevenue;
  final double lastMonthRevenue;
  final bool isSearching;

  const AdminRevenueLoaded({
    required this.allOrders,
    required this.filteredOrders,
    required this.paginatedOrders,
    required this.shops,
    required this.products,
    required this.customers,
    required this.businessCategories,
    required this.productCategories,
    required this.selectedBusinessCategory,
    required this.selectedProductCategory,
    required this.selectedTimeframe,
    this.customStart,
    this.customEnd,
    required this.searchQuery,
    required this.currentPage,
    required this.totalPages,
    required this.totalRevenue,
    required this.todayRevenue,
    required this.lastMonthRevenue,
    this.isSearching = false,
  });

  AdminRevenueLoaded copyWith({
    List<OrderModel>? filteredOrders,
    List<OrderModel>? paginatedOrders,
    String? selectedBusinessCategory,
    String? selectedProductCategory,
    String? selectedTimeframe,
    DateTime? customStart,
    bool clearCustomStart = false,
    DateTime? customEnd,
    bool clearCustomEnd = false,
    String? searchQuery,
    int? currentPage,
    int? totalPages,
    double? totalRevenue,
    double? todayRevenue,
    double? lastMonthRevenue,
    bool? isSearching,
  }) {
    return AdminRevenueLoaded(
      allOrders: allOrders,
      filteredOrders: filteredOrders ?? this.filteredOrders,
      paginatedOrders: paginatedOrders ?? this.paginatedOrders,
      shops: shops,
      products: products,
      customers: customers,
      businessCategories: businessCategories,
      productCategories: productCategories,
      selectedBusinessCategory:
          selectedBusinessCategory ?? this.selectedBusinessCategory,
      selectedProductCategory:
          selectedProductCategory ?? this.selectedProductCategory,
      selectedTimeframe: selectedTimeframe ?? this.selectedTimeframe,
      customStart: clearCustomStart ? null : (customStart ?? this.customStart),
      customEnd: clearCustomEnd ? null : (customEnd ?? this.customEnd),
      searchQuery: searchQuery ?? this.searchQuery,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      todayRevenue: todayRevenue ?? this.todayRevenue,
      lastMonthRevenue: lastMonthRevenue ?? this.lastMonthRevenue,
      isSearching: isSearching ?? this.isSearching,
    );
  }
}

// Revenue Error State
class AdminRevenueError extends AdminRevenueState {
  final String message;
  const AdminRevenueError(this.message);
}
