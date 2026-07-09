import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/customer/orders/presentation/utils/customer_order_status.dart';
import 'package:street_cart/features/customer/orders/presentation/utils/orders_helper.dart';

class OrderDetailsStatusBanner extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsStatusBanner({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final status = CustomerOrderStatus.fromString(order.status);
    final isDelivered = OrdersHelper.isDelivered(status);
    final isCancelled = OrdersHelper.isCancelled(status);
    final dateStr = OrdersHelper.formatDateShort(order.createdAt);
    final activeColor = const Color(0xFF5E5CE6);

    if (isDelivered) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F0FF),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFE2DFFF)),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: activeColor,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check, color: Colors.white, size: 20.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Delivered on $dateStr',
                    style: TextStyle(
                      color: const Color(0xFF1E293B),
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Handed over to ${order.deliveryAddress.fullName}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12.sp),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else if (isCancelled) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.red[100]!),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close, color: Colors.white, size: 20.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cancelled on $dateStr',
                    style: TextStyle(
                      color: Colors.red[900],
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'This order was cancelled.',
                    style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: CustomerAppColors.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: CustomerAppColors.primary.withOpacity(0.15),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: const BoxDecoration(
                color: CustomerAppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.local_shipping,
                color: Colors.white,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'In Progress: ${OrdersHelper.getDisplayStatus(status)}',
                    style: TextStyle(
                      color: CustomerAppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Estimated delivery is pending updates.',
                    style: TextStyle(
                      color: CustomerAppColors.primary.withOpacity(0.7),
                      fontSize: 12.sp,
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
}
