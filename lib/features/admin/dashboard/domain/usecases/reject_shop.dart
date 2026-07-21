import 'package:street_cart/features/admin/dashboard/domain/repositories/i_admin_dashboard_repository.dart';

class RejectShop {
  final IAdminDashboardRepository repository;

  const RejectShop(this.repository);

  Future<void> call(String shopId, String rejectionReason) async {
    return await repository.rejectShop(shopId, rejectionReason);
  }
}
