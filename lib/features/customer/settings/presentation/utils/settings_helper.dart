import 'package:flutter/material.dart';
import 'package:street_cart/shared/widgets/custom_confirmation_modal.dart';

// Settings Helper
class SettingsHelper {
  // Confirmation for Customer Delete Account
  static void showDeleteAccountConfirm({
    required BuildContext context,
    required VoidCallback onConfirmed,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) => ConfirmationModal(
        title: 'Delete Account?',
        content:
            'Are you sure you want to permanently delete your account? This action cannot be undone.',
        confirmText: 'Yes, Delete',
        confirmColor: Colors.red,
        onConfirm: () {
          Navigator.pop(dialogContext);
          onConfirmed();
        },
        onCancel: () => Navigator.pop(dialogContext),
      ),
    );
  }

  // Second Confirmation before actual Account Deletion
  static void showDeleteAccountConfirmDouble({
    required BuildContext context,
    required VoidCallback onConfirmed,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) => ConfirmationModal(
        title: 'Permanently Erase All Data?',
        content:
            'Warning: This will immediately delete all your profile details, orders history, and addresses. Proceed?',
        confirmText: 'Delete Permanently',
        confirmColor: Colors.red,
        onConfirm: () {
          Navigator.pop(dialogContext);
          onConfirmed();
        },
        onCancel: () => Navigator.pop(dialogContext),
      ),
    );
  }
}
