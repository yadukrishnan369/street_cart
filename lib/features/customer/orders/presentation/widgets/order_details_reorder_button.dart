import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/customer/cart/presentation/pages/checkout_page.dart';
import 'package:street_cart/shared/widgets/custom_alert_dialog.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';
import 'package:street_cart/features/customer/orders/presentation/utils/orders_helper.dart';

class OrderDetailsReorderButton extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsReorderButton({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final activeColor = const Color(0xFF5E5CE6);

    return PrimaryButton(
      text: 'Reorder Item',
      backgroundColor: activeColor,
      height: 48.h,
      borderRadius: 24.r,
      prefixIcon: Icon(Icons.refresh, size: 20.sp, color: Colors.white),
      textStyle: TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (dialogCtx) => CustomAlertDialog(
            icon: Icons.refresh_outlined,
            iconColor: activeColor,
            title: 'Reorder Item',
            content:
                'Are you sure you want to buy these items again with the same options?',
            secondaryActionLabel: 'Cancel',
            onSecondaryAction: () => Navigator.pop(dialogCtx),
            primaryActionLabel: 'Reorder',
            primaryActionColor: activeColor,
            onPrimaryAction: () {
              Navigator.pop(dialogCtx);
              final cartItems = OrdersHelper.convertToCartItems(order.items);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CheckoutPage(cartItems: cartItems),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
