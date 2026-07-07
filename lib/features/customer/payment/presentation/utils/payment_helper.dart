import 'package:flutter/material.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/shared/widgets/custom_alert_dialog.dart';

class PaymentHelper {
  static String getOrderIdSuffix(String rawId) {
    return rawId.length >= 5
        ? rawId.substring(0, 5).toUpperCase()
        : rawId.toUpperCase();
  }

  static void showConfirmOrderDialog(
    BuildContext context, {
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return CustomAlertDialog(
          title: 'Place Your Order',
          content: 'Are you sure you want to proceed and place this order?',
          primaryActionLabel: 'Confirm',
          secondaryActionLabel: 'Cancel',
          primaryActionColor: CustomerAppColors.primary,
          icon: Icons.shopping_bag_outlined,
          iconColor: CustomerAppColors.primary,
          onPrimaryAction: () {
            Navigator.pop(dialogContext);
            onConfirm();
          },
          onSecondaryAction: () => Navigator.pop(dialogContext),
        );
      },
    );
  }
}
