import 'dart:io';
import 'package:street_cart/features/customer/review/domain/repositories/i_review_repository.dart';

class SubmitReview {
  final IReviewRepository repository;

  SubmitReview(this.repository);

  Future<void> call({
    required String productId,
    required String shopId,
    required int rating,
    required String reviewText,
    required List<File> imageFiles,
    String? reviewId,
  }) async {
    return await repository.submitReview(
      productId: productId,
      shopId: shopId,
      rating: rating,
      reviewText: reviewText,
      imageFiles: imageFiles,
      reviewId: reviewId,
    );
  }
}
