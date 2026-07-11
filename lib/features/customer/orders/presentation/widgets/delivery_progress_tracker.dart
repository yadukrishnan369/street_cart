import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/customer/orders/presentation/utils/orders_helper.dart';
import 'package:street_cart/features/customer/orders/presentation/utils/customer_order_status.dart';

class DeliveryProgressTracker extends StatelessWidget {
  final OrderModel order;

  const DeliveryProgressTracker({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    if (order.status.toLowerCase() == 'cancelled') {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            const Icon(Icons.cancel, color: CustomerAppColors.error),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Cancelled',
                    style: TextStyle(
                      color: Colors.red[900],
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'This order was cancelled on ${OrdersHelper.formatDateShort(DateTime.now())}.',
                    style: TextStyle(color: Colors.red[700], fontSize: 12.sp),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final steps = OrdersHelper.getProgressSteps(order);
    final activeColor = CustomerAppColors.primary;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DELIVERY PROGRESS',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF1E293B),
              letterSpacing: 1.0,
            ),
          ),
          SizedBox(height: 16.h),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: steps.length,
            itemBuilder: (context, index) {
              final step = steps[index];
              final isCompleted = step['completed'] as bool;
              final isLast = index == steps.length - 1;

              // Find if this is the active stage
              final currentProgressIndex = OrdersHelper.getProgressIndex(
                CustomerOrderStatus.fromString(order.status),
              );
              final isActiveStage = index == currentProgressIndex;

              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 28.w,
                          height: 28.w,
                          decoration: BoxDecoration(
                            color: isCompleted ? activeColor : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isCompleted
                                  ? activeColor
                                  : Colors.grey[300]!,
                              width: 2.w,
                            ),
                          ),
                          child: isCompleted
                              ? Icon(
                                  Icons.check,
                                  size: 14.sp,
                                  color: Colors.white,
                                )
                              : isActiveStage
                              ? Icon(
                                  Icons.local_shipping_outlined,
                                  size: 14.sp,
                                  color: activeColor,
                                )
                              : null,
                        ),
                        if (!isLast)
                          Expanded(
                            child: Container(
                              width: 2.w,
                              color: isCompleted && index < currentProgressIndex
                                  ? activeColor
                                  : Colors.grey[300],
                            ),
                          ),
                      ],
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 24.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              step['title'] as String,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                color: isCompleted
                                    ? (isActiveStage
                                          ? activeColor
                                          : const Color(0xFF1E293B))
                                    : Colors.grey[500],
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              step['time'] as String,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: isCompleted
                                    ? (isActiveStage
                                          ? activeColor.withOpacity(0.7)
                                          : Colors.grey[500])
                                    : Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
