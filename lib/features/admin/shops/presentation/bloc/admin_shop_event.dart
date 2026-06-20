abstract class AdminShopEvent {}

class LoadAdminShop extends AdminShopEvent {
  final int page;
  final int limit;

  LoadAdminShop({required this.page, required this.limit});
}

class SearchQueryChanged extends AdminShopEvent {
  final String query;

  SearchQueryChanged(this.query);
}

class FilterChanged extends AdminShopEvent {
  final String statusFilter;
  final String? categoryFilter;

  FilterChanged({required this.statusFilter, this.categoryFilter});
}

class ToggleSuspensionRequested extends AdminShopEvent {
  final String shopId;
  final bool isSuspended;

  ToggleSuspensionRequested({required this.shopId, required this.isSuspended});
}
