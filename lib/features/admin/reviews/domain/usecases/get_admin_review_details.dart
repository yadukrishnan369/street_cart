import 'package:street_cart/features/admin/reviews/domain/repositories/i_admin_reviews_repository.dart';
import 'package:street_cart/features/customer/review/data/models/review_model.dart';

class GetAdminReviewDetails {
  final IAdminReviewsRepository repository;

  GetAdminReviewDetails(this.repository);

  Future<ReviewModel> call(String id) {
    return repository.getReviewDetails(id);
  }
}
