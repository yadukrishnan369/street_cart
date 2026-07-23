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
  final String? refundStatus;
  final double refundAmount;
  final String paymentMethod;

  const ReturnActionButton({
    super.key,
    required this.returnStatus,
    required this.orderId,
    required this.shopId,
    this.refundStatus,
    required this.refundAmount,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    if (returnStatus == 'return_requested') {
      return _buildButton(
        context,
        label: 'Confirm Return',
        color: ShopAppColors.primary,
        icon: const Icon(Icons.verified_outlined, color: Colors.white),
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
      return BlocBuilder<ShopOrdersBloc, ShopOrdersState>(
        builder: (context, state) {
          return Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Refund Via Hand Option CheckBox
                  Row(
                    children: [
                      Checkbox(
                        activeColor: ShopAppColors.primary,
                        value: state.isRefundViaHand,
                        onChanged: (val) {
                          context.read<ShopOrdersBloc>().add(
                            ToggleRefundViaHandEvent(val ?? false),
                          );
                        },
                      ),
                      Text(
                        'Refund via Hand',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: ShopAppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  PrimaryButton(
                    prefixIcon: const Icon(
                      Icons.assignment_turned_in_outlined,
                      color: Colors.white,
                    ),
                    text: 'Mark as Picked',
                    backgroundColor: ShopAppColors.primary,
                    height: 55.h,
                    onPressed: () {
                      ShopOrdersHelper.showStatusChangeConfirmation(
                        context: context,
                        statusLabel: 'Mark Return as Picked',
                        onConfirm: () => context.read<ShopOrdersBloc>().add(
                          UpdateOrderReturnStatusEvent(
                            shopId: shopId,
                            orderId: orderId,
                            newReturnStatus: 'return_picked',
                            refundViaHand: state.isRefundViaHand,
                            refundAmount: refundAmount,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else if (returnStatus == 'return_picked' && refundStatus == null) {
      return _buildButton(
        context,
        label: 'Process Refund',
        color: ShopAppColors.primary,
        icon: const Icon(Icons.currency_rupee, color: Colors.white),
        onPressed: () {
          ShopOrdersHelper.showStatusChangeConfirmation(
            context: context,
            statusLabel: 'Process Refund',
            onConfirm: () {
              context.read<ShopOrdersBloc>().add(
                InitiateRefundEvent(
                  orderId: orderId,
                  refundAmount: refundAmount,
                  paymentMethod: paymentMethod,
                ),
              );
            },
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
    required Widget icon,
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
