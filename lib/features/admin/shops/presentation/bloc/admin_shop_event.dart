// Base class
abstract class AdminShopEvent {}

// Load Shop Event
class LoadAdminShop extends AdminShopEvent {
  final int page;
  final int limit;

  LoadAdminShop({required this.page, required this.limit});
}

// Search Query Event for search bar
class SearchQueryChanged extends AdminShopEvent {
  final String query;

  SearchQueryChanged(this.query);
}

// Filter Changed Event
class FilterChanged extends AdminShopEvent {
  final String statusFilter;
  final String? categoryFilter;

  FilterChanged({required this.statusFilter, this.categoryFilter});
}

// Toggle Suspension Requested Event
class ToggleSuspensionRequested extends AdminShopEvent {
  final String shopId;
  final bool isSuspended;

  ToggleSuspensionRequested({required this.shopId, required this.isSuspended});
}
