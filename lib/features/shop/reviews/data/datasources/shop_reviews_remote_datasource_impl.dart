import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:street_cart/core/error/exceptions.dart';
import 'package:street_cart/features/customer/review/data/models/review_model.dart';
import 'shop_reviews_remote_datasource.dart';

class ShopReviewsRemoteDataSourceImpl implements IShopReviewsRemoteDataSource {
  final FirebaseFirestore _firestore;

  ShopReviewsRemoteDataSourceImpl({required FirebaseFirestore firestore})
    : _firestore = firestore;
  // Get Product Reviews
  @override
  Future<List<ReviewModel>> getProductReviews(String productId) async {
    try {
      final snapshot = await _firestore
          .collection('reviews')
          .where('product_id', isEqualTo: productId)
          .get();

      final list = snapshot.docs
          .map((doc) => ReviewModel.fromMap(doc.data(), doc.id))
          .where((r) => !r.isHidden)
          .toList();

      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return list;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
