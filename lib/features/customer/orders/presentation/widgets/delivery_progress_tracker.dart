import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/customer/orders/presentation/utils/orders_helper.dart';
import 'package:street_cart/features/customer/orders/presentation/utils/customer_order_status.dart';

// Delivery Progress Tracker
class DeliveryProgressTracker extends StatelessWidget {
  final OrderModel order;

  const DeliveryProgressTracker({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (order.status.toLowerCase() == 'cancelled') {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isDark ? CustomerAppColors.darkEmptyErrorBg : Colors.red[50],
          borderRadius: BorderRadius.circular(12.r),
          border: isDark
              ? Border.all(color: CustomerAppColors.darkEmptyErrorBorder)
              : null,
        ),
        child: Row(
          children: [
            const Icon(Icons.cancel, color: CustomerAppColors.error),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    'Order Cancelled',
                    style: TextStyle(
                      color: CustomerAppColors.error,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  // Subtitle
                  Text(
                    'This order was cancelled on ${OrdersHelper.formatDateShort(DateTime.now())}.',
                    style: TextStyle(
                      color: isDark
                          ? CustomerAppColors.darkTextSecondary
                          : Colors.red[700],
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

    final steps = OrdersHelper.getProgressSteps(order);
    final activeColor = CustomerAppColors.primary;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'DELIVERY PROGRESS',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w900,
              color: isDark
                  ? CustomerAppColors.darkTextSecondary
                  : CustomerAppColors.textPrimary,
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
                            color: isCompleted
                                ? activeColor
                                : isDark
                                ? CustomerAppColors.darkInputBackground
                                : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isCompleted
                                  ? activeColor
                                  : isDark
                                  ? CustomerAppColors.darkBorder
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
                                  : isDark
                                  ? CustomerAppColors.darkBorder
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
                            // Step Title
                            Text(
                              step['title'] as String,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                color: isCompleted
                                    ? (isActiveStage
                                          ? activeColor
                                          : isDark
                                          ? CustomerAppColors.darkTextPrimary
                                          : CustomerAppColors.textPrimary)
                                    : isDark
                                    ? CustomerAppColors.darkTextSecondary
                                    : Colors.grey[500],
                              ),
                            ),
                            SizedBox(height: 2.h),
                            // Step Time
                            Text(
                              step['time'] as String,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: isCompleted
                                    ? (isActiveStage
                                          ? activeColor.withValues(alpha: 0.7)
                                          : isDark
                                          ? CustomerAppColors.darkTextSecondary
                                          : Colors.grey[500])
                                    : isDark
                                    ? CustomerAppColors.darkTextSecondary
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
