abstract class SalesAnalyticsEvent {}

// Fetch Sales Analytics Data Event
class FetchSalesAnalyticsData extends SalesAnalyticsEvent {
  final String shopId;

  FetchSalesAnalyticsData(this.shopId);
}

// Change Time frame Filter Event
class ChangeTimeframeFilter extends SalesAnalyticsEvent {
  final String timeframe;

  ChangeTimeframeFilter(this.timeframe);
}

// Change Custom Date Range Filter Event
class ChangeCustomDateRangeFilter extends SalesAnalyticsEvent {
  final DateTime startDate;
  final DateTime endDate;

  ChangeCustomDateRangeFilter(this.startDate, this.endDate);
}

// Change Category Filter Event
class ChangeCategoryFilter extends SalesAnalyticsEvent {
  final String category;

  ChangeCategoryFilter(this.category);
}
