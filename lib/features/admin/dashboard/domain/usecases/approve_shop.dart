import '../repositories/i_admin_dashboard_repository.dart';

class ApproveShop {
  final IAdminDashboardRepository repository;

  const ApproveShop(this.repository);

  Future<void> call(String shopId) async {
    return await repository.approveShop(shopId);
  }
}
