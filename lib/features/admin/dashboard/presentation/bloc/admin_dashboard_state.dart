import '../../data/models/dashboard_stats_model.dart';

abstract class AdminDashboardState {
  const AdminDashboardState();
}

class AdminDashboardInitial extends AdminDashboardState {}

class AdminDashboardLoading extends AdminDashboardState {}

class AdminDashboardLoadSuccess extends AdminDashboardState {
  final DashboardStatsModel stats;

  const AdminDashboardLoadSuccess(this.stats);
}

class AdminDashboardLoadFailure extends AdminDashboardState {
  final String message;

  const AdminDashboardLoadFailure(this.message);
}
