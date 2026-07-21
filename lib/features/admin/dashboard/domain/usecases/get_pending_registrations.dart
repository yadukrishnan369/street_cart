import 'package:street_cart/features/admin/dashboard/data/models/new_registration_model.dart';
import 'package:street_cart/features/admin/dashboard/domain/repositories/i_admin_dashboard_repository.dart';

class GetPendingRegistrations {
  final IAdminDashboardRepository repository;

  const GetPendingRegistrations(this.repository);

  Future<List<NewRegistrationModel>> call({
    required int page,
    required int limit,
  }) async {
    return await repository.getPendingRegistrations(page: page, limit: limit);
  }
}
