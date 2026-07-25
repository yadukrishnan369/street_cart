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
      customerImage = data['profile_image'] ?? user.photoURL ?? '';
    }

    // Upload images to Cloudinary
    final List<String> imageUrls = [];
    for (final file in imageFiles) {
      final url = await cloudinaryService.uploadImage(file);
      if (url != null) {
        imageUrls.add(url);
      }
    }

    // Create review doc
    final reviewRef = firestore.collection('reviews').doc();

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
