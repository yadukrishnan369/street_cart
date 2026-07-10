import 'package:street_cart/features/customer/orders/data/models/order_model.dart';

abstract class AdminOrdersEvent {}

class LoadAdminOrders extends AdminOrdersEvent {}

class OrdersUpdated extends AdminOrdersEvent {
  final List<OrderModel> orders;
  final Map<String, String> shopNames;
  final Map<String, String> customerNames;
  final Map<String, String> customerEmails;

  OrdersUpdated({
    required this.orders,
    required this.shopNames,
    required this.customerNames,
    required this.customerEmails,
  });
}

class SearchQueryChanged extends AdminOrdersEvent {
  final String query;
  SearchQueryChanged(this.query);
}

class FilterTabChanged extends AdminOrdersEvent {
  final int tabIndex;
  FilterTabChanged(this.tabIndex);
}
