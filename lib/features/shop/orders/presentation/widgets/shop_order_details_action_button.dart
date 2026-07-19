import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/shop/orders/presentation/bloc/shop_orders_bloc.dart';
import 'package:street_cart/features/shop/orders/presentation/utils/shop_orders_helper.dart';
import 'package:street_cart/features/shop/orders/presentation/utils/shop_order_status.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';
import 'package:street_cart/core/utils/price_utils.dart';

// Shop Order Details Action Button
class ShopOrderDetailsActionButton extends StatelessWidget {
  final OrderModel order;
  final String shopId;

  const ShopOrderDetailsActionButton({
    super.key,
    required this.order,
    required this.shopId,
  });

  @override
  Widget build(BuildContext context) {
    final status = ShopOrderStatus.fromString(order.status);
    final nextStatusLabel = ShopOrdersHelper.getNextStatusActionLabel(status);
    final nextStatus = ShopOrdersHelper.getNextStatus(status);

    if (nextStatusLabel == null || nextStatus == null) {
      return const SizedBox.shrink();
    }

    final isCOD =
        order.paymentMethod.toLowerCase().contains('cod') ||
        order.paymentMethod.toLowerCase().contains('cash');
    final isDelivering = nextStatus == ShopOrderStatus.delivered;
    final isNotPaid = order.paymentStatus.toLowerCase() != 'paid';
    final requiresPaymentConfirmation = isCOD && isDelivering && isNotPaid;

    IconData actionIcon = Icons.check_circle_outline;
    if (order.status.toLowerCase() == 'processing') {
      actionIcon = Icons.local_shipping_outlined;
    } else if (order.status.toLowerCase() == 'shipped' ||
        order.status.toLowerCase() == 'packed') {
      actionIcon = Icons.check_rounded;
    }

    return BlocBuilder<ShopOrdersBloc, ShopOrdersState>(
      builder: (context, state) {
        final paymentReceived = state.isPaymentReceived;

        return Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (requiresPaymentConfirmation) ...[
                Row(
                  children: [
                    // Mark as Payment Recieved
                    Checkbox(
                      value: paymentReceived,
                      activeColor: ShopAppColors.primary,
                      onChanged: (val) {
                        context.read<ShopOrdersBloc>().add(
                          TogglePaymentReceivedEvent(val ?? false),
                        );
                      },
                    ),
                    Expanded(
                      // Total Amount of COD
                      child: Text(
                        'Confirm Cash Payment of ₹${PriceUtils.formatPrice(order.totalAmount)} Received',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: ShopAppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
              ],
              // Button for Order Status Change
              PrimaryButton(
                onPressed: (requiresPaymentConfirmation && !paymentReceived)
                    ? null
                    : () {
                        // Confirmation for Status Change
                        ShopOrdersHelper.showStatusChangeConfirmation(
                          context: context,
                          statusLabel: nextStatusLabel,
                          onConfirm: () {
                            context.read<ShopOrdersBloc>().add(
                              UpdateOrderStatusEvent(
                                shopId: shopId,
                                orderId: order.id,
                                newStatus: nextStatus.value,
                              ),
                            );
                            Navigator.pop(context);
                          },
                        );
                      },
                backgroundColor: ShopAppColors.primary,
                height: 56.h,
                borderRadius: 28.r,
                text: nextStatusLabel,
                prefixIcon: Icon(
                  actionIcon,
                  color: (requiresPaymentConfirmation && !paymentReceived)
                      ? Colors.grey[500]
                      : Colors.white,
                  size: 20.sp,
                ),
                textStyle: TextStyle(
                  color: (requiresPaymentConfirmation && !paymentReceived)
                      ? Colors.grey[500]
                      : Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
