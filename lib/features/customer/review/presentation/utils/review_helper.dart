import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/shared/widgets/custom_alert_dialog.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/customer/review/presentation/bloc/review_bloc.dart';
import 'package:street_cart/features/customer/review/presentation/bloc/review_event.dart';

class ReviewHelper {
  // Get Rating Titles
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

  // Submit Review
  static void submitReview({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required String productId,
    required String shopId,
  }) {
    if (formKey.currentState?.validate() ?? false) {
      showSubmitReviewDialog(
        context: context,
        onConfirm: () {
          context.read<ReviewBloc>().add(
            SubmitReviewEvent(productId: productId, shopId: shopId),
          );
        },
      );
    }
  }

  // Showing Confirmation for Submit Review
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
}
