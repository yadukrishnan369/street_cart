import 'package:street_cart/features/admin/reviews/domain/repositories/i_admin_reviews_repository.dart';
import 'package:street_cart/features/customer/review/data/models/review_model.dart';

class GetAdminReviews {
  final IAdminReviewsRepository repository;

  GetAdminReviews(this.repository);

  Future<List<ReviewModel>> call() {
    return repository.getReviews();
  }
}
