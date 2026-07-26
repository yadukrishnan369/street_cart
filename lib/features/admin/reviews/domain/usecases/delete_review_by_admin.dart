import 'package:street_cart/features/admin/reviews/domain/repositories/i_admin_reviews_repository.dart';

class DeleteReviewByAdmin {
  final IAdminReviewsRepository repository;

  DeleteReviewByAdmin(this.repository);

  Future<void> call(String id) {
    return repository.deleteReview(id);
  }
}
