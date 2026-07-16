import 'package:flutter/material.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/shared/widgets/custom_alert_dialog.dart';

class OrderErrorDialog extends StatelessWidget {
  final String message;

  const OrderErrorDialog({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      title: 'Order Status',
      content: message,
      primaryActionLabel: 'Okay',
      primaryActionColor: CustomerAppColors.primary,
      icon: Icons.error_outline,
      iconColor: CustomerAppColors.error,
      onPrimaryAction: () => Navigator.pop(context),
    );
  }
}
