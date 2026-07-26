import 'package:street_cart/features/customer/review/data/models/review_model.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';

abstract class IAdminReviewsRemoteDataSource {
  Future<List<ReviewModel>> getAllReviews();
  Future<List<ProductModel>> getAllProducts();
  Future<List<ShopProfileModel>> getAllShops();
  Future<void> deleteReview(String id);
  Future<void> toggleReviewVisibility(String id, bool isHidden);
  Future<ReviewModel> getReviewById(String id);
  Future<ProductModel> getProductById(String id);
}
