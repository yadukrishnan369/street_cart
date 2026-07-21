import 'package:street_cart/features/admin/dashboard/data/models/dashboard_stats_model.dart';

abstract class AdminDashboardState {
  const AdminDashboardState();
}

// Dashboard Initial State
class AdminDashboardInitial extends AdminDashboardState {}

// Dashboard Loading State
class AdminDashboardLoading extends AdminDashboardState {}

// Dashboard Load Success State
class AdminDashboardLoadSuccess extends AdminDashboardState {
  final DashboardStatsModel stats;

  const AdminDashboardLoadSuccess(this.stats);
}

// Dashboard Load Failure State
class AdminDashboardLoadFailure extends AdminDashboardState {
  final String message;

  const AdminDashboardLoadFailure(this.message);
}
