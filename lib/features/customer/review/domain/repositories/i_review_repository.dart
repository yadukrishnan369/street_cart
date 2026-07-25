import 'dart:io';
import 'package:street_cart/features/customer/review/data/models/review_model.dart';

abstract class IReviewRepository {
  Future<void> submitReview({
    required String productId,
    required String shopId,
    required int rating,
    required String reviewText,
    required List<File> imageFiles,
    String? reviewId,
    List<String>? existingImageUrls,
  });

  Future<List<ReviewModel>> getProductReviews(String productId);

  Future<void> deleteReview(String reviewId, String productId);
}
