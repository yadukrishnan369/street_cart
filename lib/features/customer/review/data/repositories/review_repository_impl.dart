import 'dart:io';
import 'package:street_cart/core/network/network_info.dart';
import 'package:street_cart/core/error/exceptions.dart';
import 'package:street_cart/features/customer/review/data/datasources/review_remote_datasource.dart';
import 'package:street_cart/features/customer/review/domain/repositories/i_review_repository.dart';
import 'package:street_cart/features/customer/review/data/models/review_model.dart';

class ReviewRepositoryImpl implements IReviewRepository {
  final IReviewRemoteDataSource remoteDataSource;
  final INetworkInfo networkInfo;

  ReviewRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

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
    if (!await networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }
    return remoteDataSource.submitReview(
      productId: productId,
      shopId: shopId,
      rating: rating,
      reviewText: reviewText,
      imageFiles: imageFiles,
      reviewId: reviewId,
      existingImageUrls: existingImageUrls,
    );
  }

  @override
  Future<List<ReviewModel>> getProductReviews(String productId) async {
    if (!await networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }
    return remoteDataSource.getProductReviews(productId);
  }

  @override
  Future<void> deleteReview(String reviewId, String productId) async {
    if (!await networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }
    return remoteDataSource.deleteReview(reviewId, productId);
  }
}
