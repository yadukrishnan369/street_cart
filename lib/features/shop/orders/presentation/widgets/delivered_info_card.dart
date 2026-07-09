import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/utils/date_formatter.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';

class DeliveredInfoCard extends StatelessWidget {
  final OrderModel order;

  const DeliveredInfoCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final bool isDelivered = order.status.toLowerCase() == 'delivered';
    if (!isDelivered) return const SizedBox.shrink();

    // timestamp saved by the shop when marking delivery
    final deliveredTime = order.deliveredAt;
    final formattedTime = deliveredTime != null
        ? DateFormatter.formatToOrderDateTime(deliveredTime)
        : '—';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ShopAppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: ShopAppColors.primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: const BoxDecoration(
              color: ShopAppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle_outline,
              color: Colors.white,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order Delivered',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: ShopAppColors.primary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Delivered on: $formattedTime',
                  style: TextStyle(fontSize: 13.sp, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
