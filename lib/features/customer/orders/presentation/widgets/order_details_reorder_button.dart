import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/customer/cart/presentation/pages/checkout_page.dart';
import 'package:street_cart/core/navigation/page_transitions.dart';
import 'package:street_cart/shared/widgets/custom_alert_dialog.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';
import 'package:street_cart/features/customer/orders/presentation/utils/orders_helper.dart';
import 'package:street_cart/features/customer/orders/presentation/bloc/orders_bloc.dart';
import 'package:street_cart/features/customer/orders/presentation/bloc/orders_event.dart';
import 'package:street_cart/features/customer/orders/presentation/bloc/orders_state.dart';

// Order Details Reorder Button
class OrderDetailsReorderButton extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsReorderButton({super.key, required this.order});

  void _showReorderConfirmDialog(BuildContext context, Color activeColor) {
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
          // Navigate to Checkout Page Directly
          Navigator.push(
            context,
            AppPageTransitions.slideFromBottom(
              CheckoutPage(cartItems: cartItems),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = CustomerAppColors.primary;

    return BlocConsumer<OrdersBloc, OrdersState>(
      listener: (context, state) {
        if (state is ReorderVerifySuccess) {
          _showReorderConfirmDialog(context, activeColor);
        } else if (state is ReorderVerifyFailure) {
          showDialog(
            context: context,
            builder: (dialogCtx) => CustomAlertDialog(
              icon: Icons.error_outline,
              iconColor: CustomerAppColors.error,
              title: 'Product Unavailable',
              content:
                  'Sorry, we found some issues with the products in this order:\n\n${state.unavailableProducts}\n\nYou cannot reorder this item.',
              primaryActionLabel: 'OK',
              primaryActionColor: CustomerAppColors.error,
              onPrimaryAction: () => Navigator.pop(dialogCtx),
            ),
          );
        } else if (state is OrdersFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        final bool isVerifying = state is ReorderVerifying;

        return PrimaryButton(
          text: 'Reorder Item',
          backgroundColor: activeColor,
          height: 48.h,
          borderRadius: 24.r,
          isLoading: isVerifying,
          prefixIcon: Icon(Icons.refresh, size: 20.sp, color: Colors.white),
          textStyle: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          onPressed: () {
            context.read<OrdersBloc>().add(VerifyReorderEvent(order));
          },
        );
      },
    );
  }
}
