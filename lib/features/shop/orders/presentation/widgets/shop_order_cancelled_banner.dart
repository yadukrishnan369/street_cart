import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/utils/price_utils.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';

// Shop Order Cancelled Banner
class ShopOrderCancelledBanner extends StatelessWidget {
  final OrderModel order;
  final double totalAmount;

  const ShopOrderCancelledBanner({
    super.key,
    required this.order,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isCOD =
        order.paymentMethod.toLowerCase().contains('cod') ||
        order.paymentMethod.toLowerCase().contains('cash');
    final refundStatus = order.refundStatus;

    Color mainColor = ShopAppColors.error;
    IconData icon = Icons.cancel_outlined;
    String title = 'Order Cancelled';
    String subtitle = 'This order was cancelled by the customer.';

    if (!isCOD) {
      if (refundStatus == 'pending') {
        mainColor = ShopAppColors.warning;
        icon = Icons.access_time_rounded;
        title = 'Order Cancelled - Refund Pending';
        subtitle =
            'Customer cancelled online order. Refund of ₹${PriceUtils.formatPrice(totalAmount)} is pending.';
      } else if (refundStatus == 'refunded') {
        mainColor = ShopAppColors.success;
        icon = Icons.check_circle_outline;
        title = 'Order Cancelled - Refunded';
        subtitle =
            'Refund of ₹${PriceUtils.formatPrice(order.refundAmount ?? totalAmount)} processed successfully.';
      }
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: mainColor.withValues(alpha: isDark ? 0.15 : 0.08),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: mainColor.withValues(alpha: isDark ? 0.3 : 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(color: mainColor, shape: BoxShape.circle),
            child: Icon(icon, color: Colors.white, size: 24.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: mainColor,
                  ),
                ),
                SizedBox(height: 4.h),
                // Subtitle
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: mainColor.withAlpha(170),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
