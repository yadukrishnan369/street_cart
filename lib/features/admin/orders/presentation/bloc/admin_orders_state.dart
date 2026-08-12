import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';

abstract class AdminOrdersState {}

// Orders Initial State
class AdminOrdersInitial extends AdminOrdersState {}

// Orders Loading State
class AdminOrdersLoading extends AdminOrdersState {}

// Orders Loaded State
class AdminOrdersLoaded extends AdminOrdersState {
  final List<OrderModel> orders;
  final List<OrderModel> allOrders;
  final Map<String, String> shopNames;
  final Map<String, ShopProfileModel> shopProfiles;
  final Map<String, String> customerNames;
  final Map<String, String> customerEmails;
  final String searchQuery;
  final int activeTab;
  final int currentPage;

  AdminOrdersLoaded({
    required this.orders,
    required this.allOrders,
    required this.shopNames,
    this.shopProfiles = const {},
    this.customerNames = const {},
    this.customerEmails = const {},
    this.searchQuery = '',
    this.activeTab = 0,
    this.currentPage = 1,
  });

  AdminOrdersLoaded copyWith({
    List<OrderModel>? orders,
    List<OrderModel>? allOrders,
    Map<String, String>? shopNames,
    Map<String, ShopProfileModel>? shopProfiles,
    Map<String, String>? customerNames,
    Map<String, String>? customerEmails,
    String? searchQuery,
    int? activeTab,
    int? currentPage,
  }) {
    return AdminOrdersLoaded(
      orders: orders ?? this.orders,
      allOrders: allOrders ?? this.allOrders,
      shopNames: shopNames ?? this.shopNames,
      shopProfiles: shopProfiles ?? this.shopProfiles,
      customerNames: customerNames ?? this.customerNames,
      customerEmails: customerEmails ?? this.customerEmails,
      searchQuery: searchQuery ?? this.searchQuery,
      activeTab: activeTab ?? this.activeTab,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

// Orders Failure State
class AdminOrdersFailure extends AdminOrdersState {
  final String message;
  AdminOrdersFailure({required this.message});
}
