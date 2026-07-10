import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';

abstract class AdminOrdersState {}

class AdminOrdersInitial extends AdminOrdersState {}

class AdminOrdersLoading extends AdminOrdersState {}

class AdminOrdersLoaded extends AdminOrdersState {
  final List<OrderModel> orders;
  final Map<String, String> shopNames;
  final Map<String, ShopProfileModel> shopProfiles;
  final Map<String, String> customerNames;
  final Map<String, String> customerEmails;
  final String searchQuery;
  final int activeTab;

  AdminOrdersLoaded({
    required this.orders,
    required this.shopNames,
    this.shopProfiles = const {},
    this.customerNames = const {},
    this.customerEmails = const {},
    this.searchQuery = '',
    this.activeTab = 0,
  });

  AdminOrdersLoaded copyWith({
    List<OrderModel>? orders,
    Map<String, String>? shopNames,
    Map<String, ShopProfileModel>? shopProfiles,
    Map<String, String>? customerNames,
    Map<String, String>? customerEmails,
    String? searchQuery,
    int? activeTab,
  }) {
    return AdminOrdersLoaded(
      orders: orders ?? this.orders,
      shopNames: shopNames ?? this.shopNames,
      shopProfiles: shopProfiles ?? this.shopProfiles,
      customerNames: customerNames ?? this.customerNames,
      customerEmails: customerEmails ?? this.customerEmails,
      searchQuery: searchQuery ?? this.searchQuery,
      activeTab: activeTab ?? this.activeTab,
    );
  }
}

class AdminOrdersFailure extends AdminOrdersState {
  final String message;
  AdminOrdersFailure({required this.message});
}
