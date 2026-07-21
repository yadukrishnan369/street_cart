abstract class AdminProductEvent {}

// Load Products EventEvent
class LoadAdminProducts extends AdminProductEvent {
  final int page;
  final int limit;

  LoadAdminProducts({required this.page, required this.limit});
}

// Search Query Changed Event
class SearchQueryChanged extends AdminProductEvent {
  final String query;

  SearchQueryChanged(this.query);
}

// Filter Changed Event
class FilterChanged extends AdminProductEvent {
  final String statusFilter;
  final String? categoryFilter;

  FilterChanged({required this.statusFilter, this.categoryFilter});
}

// UI pagination event Event
class PageChanged extends AdminProductEvent {
  final int page;
  PageChanged(this.page);
}
