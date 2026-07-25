import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/customer_products_bloc.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/customer_products_event.dart';
import 'package:street_cart/features/customer/review/data/models/review_model.dart';
import 'package:street_cart/features/customer/review/domain/usecases/delete_review.dart';
import 'package:street_cart/features/customer/review/presentation/bloc/review_bloc.dart';
import 'package:street_cart/features/customer/review/presentation/bloc/review_event.dart';
import 'package:street_cart/features/customer/review/presentation/pages/review_page.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/shared/widgets/custom_alert_dialog.dart';

class ReviewHelper {
  //  Get Rating Title
  static String getRatingText(int rating) {
    switch (rating) {
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Great product!';
      case 5:
        return 'Excellent!';
      default:
        return '';
    }
  }

  // Confirmation for Submit Review
  static void showSubmitReviewDialog({
    required BuildContext context,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (dialogCtx) => CustomAlertDialog(
        title: 'Submit Review',
        content: 'Are you sure you want to submit your review?',
        secondaryActionLabel: 'Cancel',
        onSecondaryAction: () => Navigator.pop(dialogCtx),
        primaryActionLabel: 'Yes, Submit',
        primaryActionColor: CustomerAppColors.primary,
        icon: Icons.rate_review_outlined,
        iconColor: CustomerAppColors.primary,
        onPrimaryAction: () {
          Navigator.pop(dialogCtx);
          onConfirm();
        },
      ),
    );
  }

  // Submit Review
  static void submitReview({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required String productId,
    required String shopId,
    String? reviewId,
  }) {
    if (formKey.currentState?.validate() ?? false) {
      showSubmitReviewDialog(
        context: context,
        onConfirm: () {
          context.read<ReviewBloc>().add(
            SubmitReviewEvent(
              productId: productId,
              shopId: shopId,
              reviewId: reviewId,
            ),
          );
        },
      );
    }
  }

  // Get Average Rating
  static double getAverageRating(List<ReviewModel> reviews) {
    if (reviews.isEmpty) return 0.0;
    double totalRating = 0;
    for (final review in reviews) {
      totalRating += review.rating.toDouble();
    }
    return totalRating / reviews.length;
  }

  // Get Formatted Time
  static String getFormattedTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return '$days ${days == 1 ? 'day' : 'days'} ago';
    } else {
      return DateFormat('MMM dd, yyyy').format(dateTime);
    }
  }

  // Delete Review by Customer with Confirmation
  static void onDeleteReview({
    required BuildContext context,
    required String reviewId,
    required ProductModel product,
  }) {
    showDialog(
      context: context,
      builder: (dialogCtx) => CustomAlertDialog(
        title: 'Delete Review',
        content: 'Are you sure you want to delete this review?',
        secondaryActionLabel: 'Cancel',
        onSecondaryAction: () => Navigator.pop(dialogCtx),
        primaryActionLabel: 'Delete',
        primaryActionColor: CustomerAppColors.error,
        icon: Icons.delete_outline_rounded,
        iconColor: CustomerAppColors.error,
        onPrimaryAction: () async {
          Navigator.pop(dialogCtx);
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );

          try {
            await sl<DeleteReview>().call(
              reviewId: reviewId,
              productId: product.id,
            );
            if (context.mounted) {
              Navigator.pop(context);
              context.read<CustomerProductsBloc>().add(
                InitProductDetail(product: product),
              );
            }
          } catch (e) {
            if (context.mounted) {
              Navigator.pop(context);
            }
          }
        },
      ),
    );
  }

  // Edit Review by Customer
  static Future<void> onEditReview({
    required BuildContext context,
    required ReviewModel review,
    required ProductModel product,
    required ShopProfileModel shop,
    String? selectedColor,
    String? selectedSize,
  }) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => sl<ReviewBloc>()
            ..add(
              InitializeReviewEvent(
                rating: review.rating,
                comment: review.reviewText,
                existingImageUrls: review.images,
              ),
            ),
          child: ReviewPage(
            productId: product.id,
            productName: product.name,
            productImage: product.images.isNotEmpty ? product.images.first : '',
            shopId: shop.uid,
            price: product.offerPrice,
            existingReview: review,
            selectedColor: selectedColor,
            selectedSize: selectedSize,
          ),
        ),
      ),
    );

    if (result == true && context.mounted) {
      context.read<CustomerProductsBloc>().add(
        InitProductDetail(product: product),
      );
    }
  }
}
