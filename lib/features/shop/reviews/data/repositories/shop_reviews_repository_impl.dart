import 'package:street_cart/features/customer/review/data/models/review_model.dart';
import 'package:street_cart/features/shop/reviews/data/datasources/shop_reviews_remote_datasource.dart';
import 'package:street_cart/features/shop/reviews/domain/repositories/i_shop_reviews_repository.dart';

class ShopReviewsRepositoryImpl implements IShopReviewsRepository {
  final IShopReviewsRemoteDataSource remoteDataSource;

  ShopReviewsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ReviewModel>> getProductReviews(String productId) {
    return remoteDataSource.getProductReviews(productId);
  }
}
