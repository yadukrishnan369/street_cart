import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/features/shop/orders/presentation/bloc/shop_orders_bloc.dart';
import 'package:street_cart/features/shop/orders/presentation/utils/shop_orders_helper.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';

// Return Action Button
class ReturnActionButton extends StatelessWidget {
  final String returnStatus;
  final String orderId;
  final String shopId;

  const ReturnActionButton({
    super.key,
    required this.returnStatus,
    required this.orderId,
    required this.shopId,
  });

  @override
  Widget build(BuildContext context) {
    if (returnStatus == 'return_requested') {
      return _buildButton(
        context,
        label: 'Confirm Return',
        color: ShopAppColors.primary,
        icon: Icon(Icons.verified_outlined, color: Colors.white),
        // Showing Confirmation for change Return Status
        onPressed: () {
          ShopOrdersHelper.showStatusChangeConfirmation(
            context: context,
            statusLabel: 'Accept Return Request',
            onConfirm: () => context.read<ShopOrdersBloc>().add(
              UpdateOrderReturnStatusEvent(
                shopId: shopId,
                orderId: orderId,
                newReturnStatus: 'return_confirmed',
              ),
            ),
          );
        },
      );
    } else if (returnStatus == 'return_confirmed') {
      return _buildButton(
        context,
        label: 'Mark as Picked',
        color: ShopAppColors.primary,
        icon: Icon(Icons.assignment_turned_in_outlined, color: Colors.white),

        //  Showing Confirmation for change Return Status
        onPressed: () {
          ShopOrdersHelper.showStatusChangeConfirmation(
            context: context,
            statusLabel: 'Mark Return as Picked',
            onConfirm: () => context.read<ShopOrdersBloc>().add(
              UpdateOrderReturnStatusEvent(
                shopId: shopId,
                orderId: orderId,
                newReturnStatus: 'return_picked',
              ),
            ),
          );
        },
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildButton(
    BuildContext context, {
    required String label,
    required Color color,
    required icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      color: Colors.white,
      child: SafeArea(
        child: PrimaryButton(
          prefixIcon: icon,
          text: label,
          backgroundColor: color,
          height: 55.h,
          onPressed: onPressed,
        ),
      ),
    );
  }
}
