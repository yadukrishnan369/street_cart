import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/core/constants/shop_constants.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/services/communication_service.dart';
import 'package:street_cart/shared/widgets/custom_confirmation_modal.dart';
import 'package:street_cart/features/shop/auth/presentation/bloc/shop_auth_bloc.dart';

class ShopSupportHelper {
  // Get corresponding icon for support category titles
  static IconData getCategoryIcon(String title) {
    switch (title) {
      case 'Account & Security':
        return Icons.account_circle_outlined;
      case 'Shop Customization':
        return Icons.storefront_outlined;
      case 'Shipping & Delivery':
        return Icons.local_shipping_outlined;
      case 'Marketing & Sales':
        return Icons.campaign_outlined;
      default:
        return Icons.help_outline;
    }
  }

  // Confirmation for phone call support
  static void callSupport(BuildContext context, CommunicationService comms) {
    showDialog(
      context: context,
      builder: (dialogContext) => ConfirmationModal(
        title: 'Call Support',
        content:
            'Are you sure you want to call our support team at ${ShopConstants.supportPhoneNumber}?',
        confirmText: 'Call',
        confirmColor: ShopAppColors.primary,
        onConfirm: () {
          Navigator.pop(dialogContext);
          comms.makeCall(ShopConstants.supportPhoneNumber);
        },
        onCancel: () => Navigator.pop(dialogContext),
      ),
    );
  }

  // Confirmation for email support
  static void emailSupport(BuildContext context, CommunicationService comms) {
    showDialog(
      context: context,
      builder: (dialogContext) => ConfirmationModal(
        title: 'Email Support',
        content:
            'Do you want to send an email to ${ShopConstants.supportEmail}?',
        confirmText: 'Send',
        confirmColor: ShopAppColors.primary,
        onConfirm: () {
          Navigator.pop(dialogContext);
          comms.sendEmail(ShopConstants.supportEmail);
        },
        onCancel: () => Navigator.pop(dialogContext),
      ),
    );
  }

  // confirmation for logout shop
  static void showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => ConfirmationModal(
        title: 'Logout',
        content: 'Are you sure you want to logout from your shop account?',
        confirmText: 'Yes, Logout',
        confirmColor: ShopAppColors.error,
        onConfirm: () {
          Navigator.pop(dialogContext);
          context.read<ShopAuthBloc>().add(ShopLogoutRequested());
        },
        onCancel: () => Navigator.pop(dialogContext),
      ),
    );
  }
}
