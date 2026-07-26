import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:street_cart/core/services/cloudinary_service.dart';
import 'package:street_cart/features/customer/review/data/models/review_model.dart';
import 'review_remote_datasource.dart';

class ReviewRemoteDataSourceImpl implements IReviewRemoteDataSource {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final CloudinaryService cloudinaryService;

  ReviewRemoteDataSourceImpl({
    required this.auth,
    required this.firestore,
    required this.cloudinaryService,
  });

  // Submit Review
  @override
  Future<void> submitReview({
    required String productId,
    required String shopId,
    required int rating,
    required String reviewText,
    required List<File> imageFiles,
    String? reviewId,
    List<String>? existingImageUrls,
  }) async {
    final user = auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated.');
    }

    // Fetch customer name and image
    final customerDoc = await firestore
        .collection('customers')
        .doc(user.uid)
        .get();
    String customerName = 'Anonymous';
    String customerImage = '';

    if (customerDoc.exists && customerDoc.data() != null) {
      final data = customerDoc.data()!;
      customerName = data['full_name'] ?? user.displayName ?? 'Anonymous';
      customerImage = data['profile_image'] ?? '';
    }

    // Existing non deleted URLs and newly uploaded Images
    final List<String> imageUrls = existingImageUrls != null
        ? List<String>.from(existingImageUrls)
        : [];

    for (final file in imageFiles) {
      final url = await cloudinaryService.uploadImage(file);
      if (url != null) {
        imageUrls.add(url);
      }
    }

    // Create review doc
    final reviewRef = reviewId != null
        ? firestore.collection('reviews').doc(reviewId)
        : firestore.collection('reviews').doc();

    final reviewModel = ReviewModel(
      id: reviewRef.id,
      customerId: user.uid,
      customerName: customerName,
      customerImage: customerImage,
      shopId: shopId,
      productId: productId,
      rating: rating,
      reviewText: reviewText,
      images: imageUrls,
      createdAt: DateTime.now(),
    );

    // Save
    await reviewRef.set(reviewModel.toMap());

    // Calculate new average rating for product
    await _recalculateProductRating(productId);
  }

  // Get Product Reviews
  @override
  Future<List<ReviewModel>> getProductReviews(String productId) async {
    final snapshot = await firestore
        .collection('reviews')
        .where('product_id', isEqualTo: productId)
        .get();

    final list = snapshot.docs
        .map((doc) => ReviewModel.fromMap(doc.data(), doc.id))
        .where((r) => !r.isHidden)
        .toList();
    // Sort descending by created_at
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  // Delete Review
  @override
  Future<void> deleteReview(String reviewId, String productId) async {
    await firestore.collection('reviews').doc(reviewId).delete();
    await _recalculateProductRating(productId);
  }

  // Re Calculate Product Rating
  Future<void> _recalculateProductRating(String productId) async {
    final reviewsSnapshot = await firestore
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

    await firestore.collection('products').doc(productId).update({
      'rating': averageRating,
      'reviews_count': reviewsCount,
    });
  }
}
