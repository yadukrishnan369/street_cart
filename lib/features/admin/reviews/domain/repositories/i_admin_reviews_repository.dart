import 'package:street_cart/features/customer/review/data/models/review_model.dart';

abstract class IAdminReviewsRepository {
  Future<List<ReviewModel>> getReviews();
  Future<void> deleteReview(String id);
  Future<void> toggleReviewVisibility(String id, bool isHidden);
  Future<ReviewModel> getReviewDetails(String id);
  Future<Map<String, String>> getProductNamesMap();
  Future<Map<String, String>> getShopNamesMap();
}
