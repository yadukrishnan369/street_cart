import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/shared/widgets/custom_confirmation_modal.dart';
import 'package:street_cart/features/customer/settings/presentation/bloc/settings_bloc.dart';
import 'package:street_cart/features/customer/settings/presentation/bloc/settings_event.dart';

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
        confirmColor: CustomerAppColors.error,
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
        title: 'Permanently Delete Account?',
        content:
            'Warning: This will permanently delete your profile details and addresses. Your historical order records will be preserved for business and financial purposes. Proceed?',
        confirmText: 'Delete Permanently',
        confirmColor: CustomerAppColors.error,
        onConfirm: () {
          Navigator.pop(dialogContext);
          onConfirmed();
        },
        onCancel: () => Navigator.pop(dialogContext),
      ),
    );
  }

  // Show Clear Data Confirmation Dialog
  static void showClearConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => ConfirmationModal(
        title: 'Clear App Data',
        content:
            'Are you sure you want to clear all locally stored images, search history, and temporary preferences? This will reset the app state locally but will NOT delete your account or order history.',
        confirmText: 'Next',
        confirmColor: CustomerAppColors.primary,
        onConfirm: () {
          Navigator.pop(dialogContext);
          showClearConfirmSecond(context);
        },
        onCancel: () => Navigator.pop(dialogContext),
      ),
    );
  }

  // Show Second Confirmation Dialog for Clear Data
  static void showClearConfirmSecond(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => ConfirmationModal(
        title: 'Confirm Reset',
        content:
            'Warning: This action will reset cached files and preferences. Are you absolutely sure you want to proceed?',
        confirmText: 'Clear Now',
        confirmColor: CustomerAppColors.primary,
        onConfirm: () {
          Navigator.pop(dialogContext);
          performClearData(context);
        },
        onCancel: () => Navigator.pop(dialogContext),
      ),
    );
  }

  // Perform Clear Data
  static void performClearData(BuildContext context) {
    context.read<SettingsBloc>().add(PerformClearData());
  }
}
