abstract class AdminRevenueEvent {
  const AdminRevenueEvent();
}

// Load Revenue Data Event
class LoadAdminRevenueData extends AdminRevenueEvent {
  const LoadAdminRevenueData();
}

// Reset Revenue Filters Event
class ResetRevenueFilters extends AdminRevenueEvent {
  const ResetRevenueFilters();
}

// Revenue Filter Changed Event
class RevenueFilterChanged extends AdminRevenueEvent {
  final String? businessCategory;
  final String? productCategory;
  final String? timeframe;
  final DateTime? customStart;
  final DateTime? customEnd;

  const RevenueFilterChanged({
    this.businessCategory,
    this.productCategory,
    this.timeframe,
    this.customStart,
    this.customEnd,
  });
}

// Revenue Search Changed Event
class RevenueSearchChanged extends AdminRevenueEvent {
  final String query;
  const RevenueSearchChanged(this.query);
}

// Revenue Page Changed Event
class RevenuePageChanged extends AdminRevenueEvent {
  final int page;
  const RevenuePageChanged(this.page);
}
