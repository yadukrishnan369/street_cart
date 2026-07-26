import 'package:street_cart/features/customer/review/data/models/review_model.dart';

abstract class IShopReviewsRepository {
  Future<List<ReviewModel>> getProductReviews(String productId);
}
