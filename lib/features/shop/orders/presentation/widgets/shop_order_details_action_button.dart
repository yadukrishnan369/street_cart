import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/shop/orders/presentation/bloc/shop_orders_bloc.dart';
import 'package:street_cart/features/shop/orders/presentation/bloc/shop_orders_event.dart';
import 'package:street_cart/features/shop/orders/presentation/utils/shop_orders_helper.dart';
import 'package:street_cart/features/shop/orders/presentation/utils/shop_order_status.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';

class ShopOrderDetailsActionButton extends StatefulWidget {
  final OrderModel order;
  final String shopId;

  const ShopOrderDetailsActionButton({
    super.key,
    required this.order,
    required this.shopId,
  });

  @override
  State<ShopOrderDetailsActionButton> createState() =>
      _ShopOrderDetailsActionButtonState();
}

class _ShopOrderDetailsActionButtonState
    extends State<ShopOrderDetailsActionButton> {
  bool _paymentReceived = false;

  @override
  Widget build(BuildContext context) {
    final status = ShopOrderStatus.fromString(widget.order.status);
    final nextStatusLabel = ShopOrdersHelper.getNextStatusActionLabel(status);
    final nextStatus = ShopOrdersHelper.getNextStatus(status);

    if (nextStatusLabel == null || nextStatus == null) {
      return const SizedBox.shrink();
    }

    final isCOD =
        widget.order.paymentMethod.toLowerCase().contains('cod') ||
        widget.order.paymentMethod.toLowerCase().contains('cash');
    final isDelivering = nextStatus == ShopOrderStatus.delivered;
    final isNotPaid = widget.order.paymentStatus.toLowerCase() != 'paid';
    final requiresPaymentConfirmation = isCOD && isDelivering && isNotPaid;

    IconData actionIcon = Icons.check_circle_outline;
    if (widget.order.status.toLowerCase() == 'processing') {
      actionIcon = Icons.local_shipping_outlined;
    } else if (widget.order.status.toLowerCase() == 'shipped' ||
        widget.order.status.toLowerCase() == 'packed') {
      actionIcon = Icons.check_rounded;
    }

    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (requiresPaymentConfirmation) ...[
            Row(
              children: [
                Checkbox(
                  value: _paymentReceived,
                  activeColor: ShopAppColors.primary,
                  onChanged: (val) {
                    setState(() {
                      _paymentReceived = val ?? false;
                    });
                  },
                ),
                Expanded(
                  child: Text(
                    'Confirm Cash Payment of ₹${widget.order.totalAmount.toStringAsFixed(0)} Received',
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
          PrimaryButton(
            onPressed: (requiresPaymentConfirmation && !_paymentReceived)
                ? null
                : () {
                    context.read<ShopOrdersBloc>().add(
                      UpdateOrderStatusEvent(
                        shopId: widget.shopId,
                        orderId: widget.order.id,
                        newStatus: nextStatus.value,
                      ),
                    );
                    Navigator.pop(context);
                  },
            backgroundColor: ShopAppColors.primary,
            height: 56.h,
            borderRadius: 28.r,
            text: nextStatusLabel,
            prefixIcon: Icon(
              actionIcon,
              color: (requiresPaymentConfirmation && !_paymentReceived)
                  ? Colors.grey[500]
                  : Colors.white,
              size: 20.sp,
            ),
            textStyle: TextStyle(
              color: (requiresPaymentConfirmation && !_paymentReceived)
                  ? Colors.grey[500]
                  : Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
