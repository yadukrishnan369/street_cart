import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:street_cart/core/error/exceptions.dart';
import 'package:street_cart/features/customer/review/data/models/review_model.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'admin_reviews_remote_datasource.dart';

class AdminReviewsRemoteDataSourceImpl
    implements IAdminReviewsRemoteDataSource {
  final FirebaseFirestore _firestore;

  AdminReviewsRemoteDataSourceImpl({required FirebaseFirestore firestore})
    : _firestore = firestore;
  // Get All Reviews
  @override
  Future<List<ReviewModel>> getAllReviews() async {
    try {
      final snap = await _firestore.collection('reviews').get();
      return snap.docs
          .map((doc) => ReviewModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw ServerException('Failed to get reviews from Firestore: $e');
    }
  }

  //  Get All Products
  @override
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final snap = await _firestore.collection('products').get();
      return snap.docs
          .map((doc) => ProductModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw ServerException('Failed to get products from Firestore: $e');
    }
  }

  // Get All Shops
  @override
  Future<List<ShopProfileModel>> getAllShops() async {
    try {
      final snap = await _firestore.collection('shops').get();
      return snap.docs
          .map((doc) => ShopProfileModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw ServerException('Failed to get shops from Firestore: $e');
    }
  }

  // Delete Review
  @override
  Future<void> deleteReview(String id) async {
    try {
      // Fetch review to know productId for updating average rating
      final reviewDoc = await _firestore.collection('reviews').doc(id).get();
      if (!reviewDoc.exists) return;

      final reviewData = reviewDoc.data();
      final productId = reviewData?['product_id'] as String?;

      // Delete the review
      await _firestore.collection('reviews').doc(id).delete();

      // Recalculate average rating for product
      if (productId != null && productId.isNotEmpty) {
        await _recalculateProductRating(productId);
      }
    } catch (e) {
      throw ServerException('Failed to delete review: $e');
    }
  }

  // Review Hide/Show
  @override
  Future<void> toggleReviewVisibility(String id, bool isHidden) async {
    try {
      await _firestore.collection('reviews').doc(id).update({
        'is_hidden': isHidden,
      });
    } catch (e) {
      throw ServerException('Failed to update review visibility: $e');
    }
  }

  // Get Review By ID
  @override
  Future<ReviewModel> getReviewById(String id) async {
    try {
      final doc = await _firestore.collection('reviews').doc(id).get();
      if (!doc.exists || doc.data() == null) {
        throw ServerException('Review not found.');
      }
      return ReviewModel.fromMap(doc.data()!, doc.id);
    } catch (e) {
      throw ServerException('Failed to fetch review: $e');
    }
  }

  // Get Product By ID
  @override
  Future<ProductModel> getProductById(String id) async {
    try {
      final doc = await _firestore.collection('products').doc(id).get();
      if (!doc.exists || doc.data() == null) {
        throw ServerException('Product not found.');
      }
      return ProductModel.fromMap(doc.data()!, doc.id);
    } catch (e) {
      throw ServerException('Failed to fetch product details: $e');
    }
  }

  // Recalculate Product Rating
  Future<void> _recalculateProductRating(String productId) async {
    final reviewsSnapshot = await _firestore
        .collection('reviews')
        .where('product_id', isEqualTo: productId)
        .get();

    double totalRating = 0;
    int reviewsCount = reviewsSnapshot.docs.length;

    for (final doc in reviewsSnapshot.docs) {
      final r = (doc.data()['rating'] as num?)?.toDouble() ?? 0.0;
      totalRating += r;
    }

    final averageRating = reviewsCount > 0 ? (totalRating / reviewsCount) : 0.0;

    await _firestore.collection('products').doc(productId).update({
      'rating': averageRating,
      'reviews_count': reviewsCount,
    });
  }
}
