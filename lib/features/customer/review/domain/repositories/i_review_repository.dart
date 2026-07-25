import 'dart:io';

abstract class IReviewRepository {
  Future<void> submitReview({
    required String productId,
    required String shopId,
    required int rating,
    required String reviewText,
    required List<File> imageFiles,
  });
}
