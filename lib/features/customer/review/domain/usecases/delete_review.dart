import 'package:street_cart/features/customer/review/domain/repositories/i_review_repository.dart';

class DeleteReview {
  final IReviewRepository repository;

  DeleteReview(this.repository);

  Future<void> call({required String reviewId, required String productId}) {
    return repository.deleteReview(reviewId, productId);
  }
}
