import 'package:street_cart/features/customer/review/data/models/review_model.dart';
import 'package:street_cart/features/shop/reviews/domain/repositories/i_shop_reviews_repository.dart';

class GetShopProductReviews {
  final IShopReviewsRepository repository;

  GetShopProductReviews(this.repository);

  Future<List<ReviewModel>> call(String productId) {
    return repository.getProductReviews(productId);
  }
}
