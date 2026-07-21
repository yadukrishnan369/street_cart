import 'package:street_cart/features/admin/dashboard/data/models/dashboard_stats_model.dart';
import 'package:street_cart/features/admin/dashboard/domain/repositories/i_admin_dashboard_repository.dart';

class GetDashboardData {
  final IAdminDashboardRepository repository;

  const GetDashboardData(this.repository);

  Future<DashboardStatsModel> call() async {
    return await repository.getDashboardStats();
  }
}
