import '../../data/models/dashboard_stats_model.dart';
import '../repositories/i_admin_dashboard_repository.dart';

class GetDashboardData {
  final IAdminDashboardRepository repository;

  const GetDashboardData(this.repository);

  Future<DashboardStatsModel> call() async {
    return await repository.getDashboardStats();
  }
}
