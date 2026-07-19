import 'package:flutter/material.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/shared/widgets/custom_confirmation_modal.dart';

class ShopSettingsHelper {
  // Confirmation for shop account Deletion
  static void confirmDelete({
    required BuildContext context,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) => ConfirmationModal(
        title: 'Delete Account?',
        content:
            'Are you sure you want to permanently delete your merchant account? This action cannot be undone.',
        confirmText: 'Yes, Delete',
        confirmColor: ShopAppColors.error,
        onConfirm: () {
          Navigator.pop(dialogContext);
          confirmDeleteDouble(context: context, onConfirm: onConfirm);
        },
        onCancel: () => Navigator.pop(dialogContext),
      ),
    );
  }

  // Second Confirmation for shop account Deletion
  static void confirmDeleteDouble({
    required BuildContext context,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) => ConfirmationModal(
        title: 'Permanently Erase Data?',
        content:
            'Warning: This action will permanently erase your store profile, active products, and past order records. Proceed?',
        confirmText: 'Delete Permanently',
        confirmColor: ShopAppColors.error,
        onConfirm: () {
          Navigator.pop(dialogContext);
          onConfirm();
        },
        onCancel: () => Navigator.pop(dialogContext),
      ),
    );
  }

  // Confirmation for clearing app data cache
  static void showDoubleConfirmation({
    required BuildContext context,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext1) => ConfirmationModal(
        title: 'Clear App Data',
        content:
            'Are you sure you want to clear all locally stored images and temporary files?',
        confirmText: 'Next',
        confirmColor: ShopAppColors.primary,
        onConfirm: () {
          Navigator.pop(dialogContext1);
          showSecondConfirmation(context: context, onConfirm: onConfirm);
        },
        onCancel: () => Navigator.pop(dialogContext1),
      ),
    );
  }

  // Second Confirmation for clearing app data cache
  static void showSecondConfirmation({
    required BuildContext context,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext2) => ConfirmationModal(
        title: 'Confirm Action',
        content:
            'Warning: This action will reset cached files and preferences. Are you absolutely sure you want to proceed?',
        confirmText: 'Clear Now',
        confirmColor: ShopAppColors.primary,
        onConfirm: () {
          Navigator.pop(dialogContext2);
          onConfirm();
        },
        onCancel: () => Navigator.pop(dialogContext2),
      ),
    );
  }
}
