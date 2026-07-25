import 'dart:io';
import 'package:street_cart/core/network/network_info.dart';
import 'package:street_cart/core/error/exceptions.dart';
import 'package:street_cart/features/customer/review/data/datasources/review_remote_datasource.dart';
import 'package:street_cart/features/customer/review/domain/repositories/i_review_repository.dart';

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
    );
  }
}
