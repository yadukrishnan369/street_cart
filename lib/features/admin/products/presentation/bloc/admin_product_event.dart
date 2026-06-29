abstract class AdminProductEvent {}

class LoadAdminProducts extends AdminProductEvent {
  final int page;
  final int limit;

  LoadAdminProducts({
    required this.page,
    required this.limit,
  });
}

class SearchQueryChanged extends AdminProductEvent {
  final String query;

  SearchQueryChanged(this.query);
}

class FilterChanged extends AdminProductEvent {
  final String statusFilter;
  final String? categoryFilter;

  FilterChanged({
    required this.statusFilter,
    this.categoryFilter,
  });
}
