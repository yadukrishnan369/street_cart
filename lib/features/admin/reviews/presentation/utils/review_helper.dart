import 'package:flutter/material.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/shared/widgets/custom_alert_dialog.dart';
import 'package:intl/intl.dart';

class AdminReviewHelper {
  // Confirm Delete Review
  static void confirmDeleteByAdmin({
    required BuildContext context,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (dialogCtx) => CustomAlertDialog(
        title: 'Delete Review',
        content:
            'Are you sure you want to permanently delete this customer review? This action cannot be undone.',
        secondaryActionLabel: 'Cancel',
        onSecondaryAction: () => Navigator.pop(dialogCtx),
        primaryActionLabel: 'Delete',
        primaryActionColor: CustomerAppColors.error,
        icon: Icons.delete_outline_rounded,
        iconColor: CustomerAppColors.error,
        onPrimaryAction: () {
          Navigator.pop(dialogCtx);
          onConfirm();
        },
      ),
    );
  }

  // Confirm Toggle Visibility of Review
  static void confirmToggleVisibilityByAdmin({
    required BuildContext context,
    required bool isCurrentlyHidden,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (dialogCtx) => CustomAlertDialog(
        title: isCurrentlyHidden ? 'Show Review' : 'Hide Review',
        content: isCurrentlyHidden
            ? 'Are you sure you want to make this review visible to customers?'
            : 'Are you sure you want to hide this review from customers?',
        secondaryActionLabel: 'Cancel',
        onSecondaryAction: () => Navigator.pop(dialogCtx),
        primaryActionLabel: isCurrentlyHidden ? 'Show' : 'Hide',
        primaryActionColor: AdminAppColors.primaryColor,
        icon: isCurrentlyHidden
            ? Icons.visibility_outlined
            : Icons.visibility_off_outlined,
        iconColor: AdminAppColors.primaryColor,
        onPrimaryAction: () {
          Navigator.pop(dialogCtx);
          onConfirm();
        },
      ),
    );
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
}
