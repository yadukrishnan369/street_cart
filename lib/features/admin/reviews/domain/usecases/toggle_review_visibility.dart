import 'package:street_cart/features/admin/reviews/domain/repositories/i_admin_reviews_repository.dart';

class ToggleReviewVisibility {
  final IAdminReviewsRepository repository;

  ToggleReviewVisibility(this.repository);

  Future<void> call(String id, bool isHidden) {
    return repository.toggleReviewVisibility(id, isHidden);
  }
}
