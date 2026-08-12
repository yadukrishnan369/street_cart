import 'dart:io';
import 'package:street_cart/features/customer/review/domain/repositories/i_review_repository.dart';
import 'package:street_cart/features/customer/cart/domain/usecases/get_product_by_id.dart';
import 'package:street_cart/features/shop/notification/domain/usecases/send_shop_notification.dart';

class SubmitReview {
  final IReviewRepository repository;
  final GetProductById getProductById;
  final SendShopNotification sendShopNotification;

  SubmitReview({
    required this.repository,
    required this.getProductById,
    required this.sendShopNotification,
  });

  Future<void> call({
    required String productId,
    required String shopId,
    required int rating,
    required String reviewText,
    required List<File> imageFiles,
    String? reviewId,
    List<String>? existingImageUrls,
  }) async {
    await repository.submitReview(
      productId: productId,
      shopId: shopId,
      rating: rating,
      reviewText: reviewText,
      imageFiles: imageFiles,
      reviewId: reviewId,
      existingImageUrls: existingImageUrls,
    );

    // Send review notification to shop
    try {
      final product = await getProductById(productId);
      final productName = product.name;
      await sendShopNotification.sendReview(
        shopId: shopId,
        productId: productId,
        productName: productName,
        rating: rating,
      );
    } catch (_) {}
  }
}
