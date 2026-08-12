import 'package:flutter/material.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/shared/widgets/custom_alert_dialog.dart';

class PaymentHelper {
  // Get Order ID
  static String getOrderIdSuffix(String rawId) {
    return rawId.length <= 4
        ? rawId.substring(0, 4).toUpperCase()
        : rawId.substring(0, 6).toUpperCase();
  }

  // checks if the payment method is an online payment
  static bool isOnlinePayment(String paymentMethod) {
    final method = paymentMethod.toLowerCase();
    return method != 'cod' && method != 'cash on delivery';
  }

  // returns the loading screen title based on payment type
  static String getLoadingTitle(bool isOnline) {
    return isOnline ? 'Verifying payment...' : 'Placing Order...';
  }

  // returns the loading screen subtitle based on payment type
  static String getLoadingSubtitle(bool isOnline) {
    return isOnline
        ? 'Please wait while we confirm your payment transaction. Do not close this app.'
        : 'Please wait while we process your cart and register your order.';
  }

  // returns the success title for a given overlay phase
  static String getSuccessTitle(int phase) {
    if (phase == 2) return 'Payment Verified!';
    if (phase == 3) return 'Order Confirmed!';
    return '';
  }

  // returns the success subtitle for a given overlay phase
  static String getSuccessSubtitle(int phase) {
    if (phase == 2) return 'Your transaction was settled successfully.';
    if (phase == 3)
      return 'Congratulations! Your StreetCart order has been placed.';
    return '';
  }

  // calculates time before success flow can start
  static int getRemainingDelay(DateTime startTime, {int minimumMs = 2000}) {
    final elapsed = DateTime.now().difference(startTime).inMilliseconds;
    final remaining = minimumMs - elapsed;
    return remaining > 0 ? remaining : 0;
  }

  // Confirmation for Order Placement
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
