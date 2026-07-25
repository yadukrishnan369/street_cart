import 'package:street_cart/features/customer/review/data/models/review_model.dart';
import 'package:street_cart/features/customer/review/domain/repositories/i_review_repository.dart';

class GetProductReviews {
  final IReviewRepository repository;

  GetProductReviews(this.repository);

  Future<List<ReviewModel>> call(String productId) {
    return repository.getProductReviews(productId);
  }
}
