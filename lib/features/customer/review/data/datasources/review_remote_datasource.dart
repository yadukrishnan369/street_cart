import 'dart:io';

abstract class IReviewRemoteDataSource {
  Future<void> submitReview({
    required String productId,
    required String shopId,
    required int rating,
    required String reviewText,
    required List<File> imageFiles,
  });
}
