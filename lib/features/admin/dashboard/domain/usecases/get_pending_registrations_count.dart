import '../repositories/i_admin_dashboard_repository.dart';

class GetPendingRegistrationsCount {
  final IAdminDashboardRepository repository;

  const GetPendingRegistrationsCount(this.repository);

  Future<int> call() async {
    return await repository.getPendingRegistrationsCount();
  }
}
