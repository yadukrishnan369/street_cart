import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/admin/orders/presentation/utils/admin_orders_helper.dart';

// Tracking Details Card
class TrackingDetailsCard extends StatelessWidget {
  final OrderModel order;

  const TrackingDetailsCard({super.key, required this.order});

  static const _labels = ['Placed', 'Confirmed', 'Shipped', 'Delivered'];
  static const _icons = [
    Icons.check,
    Icons.check_circle_outline,
    Icons.local_shipping_outlined,
    Icons.location_on_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeIndex = AdminOrdersHelper.getTrackingStepIndex(order.status);

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark ? AdminAppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? AdminAppColors.darkBorder : const Color(0xFFE8E7ED),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Tracking Details',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AdminAppColors.darkTextPrimary
                      : AdminAppColors.textPrimary,
                ),
              ),
              SizedBox(width: 20.w),
              if (order.returnStatus != null && order.returnStatus!.isNotEmpty)
                Text(
                  'ORDER RETURNED',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: AdminAppColors.errorColor,
                  ),
                ),
            ],
          ),
          SizedBox(height: 24.h),
          if (activeIndex == -1)
            Center(
              child: Text(
                'ORDER CANCELLED',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: AdminAppColors.errorColor,
                ),
              ),
            )
          else
            Column(
              children: [
                Row(
                  children: [
                    for (int i = 0; i < 4; i++) ...[
                      SizedBox(
                        width: 76.w,
                        child: Center(
                          child: _buildCircle(context, i, activeIndex),
                        ),
                      ),
                      if (i < 3)
                        Expanded(
                          child: _buildLine(context, activeIndex >= i + 1),
                        ),
                    ],
                  ],
                ),
                SizedBox(height: 8.h),
                // labels
                Row(
                  children: [
                    for (int i = 0; i < 4; i++) ...[
                      SizedBox(
                        width: 76.w,
                        child: Text(
                          _labels[i],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: activeIndex >= i
                                ? (isDark
                                      ? AdminAppColors.darkTextPrimary
                                      : AdminAppColors.textPrimary)
                                : (isDark
                                      ? AdminAppColors.darkTextSecondary
                                      : const Color(0xFF8A8A9E)),
                          ),
                        ),
                      ),
                      if (i < 3) const Expanded(child: SizedBox()),
                    ],
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildCircle(BuildContext context, int index, int activeIndex) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isCompleted = activeIndex >= index;
    final color = isCompleted
        ? AdminAppColors.primaryColor
        : (isDark ? AdminAppColors.darkBorder : const Color(0xFFE8E7ED));

    return Container(
      width: 46.w,
      height: 46.h,
      decoration: BoxDecoration(
        color: isCompleted
            ? AdminAppColors.primaryColor
            : (isDark ? AdminAppColors.darkInputBackground : Colors.white),
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2.w),
      ),
      child: Icon(
        _icons[index],
        size: 20.sp,
        color: isCompleted
            ? Colors.white
            : (isDark
                  ? AdminAppColors.darkTextSecondary
                  : const Color(0xFF8A8A9E)),
      ),
    );
  }

  Widget _buildLine(BuildContext context, bool isActive) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 3.h,
      color: isActive
          ? AdminAppColors.primaryColor
          : (isDark ? AdminAppColors.darkBorder : const Color(0xFFE8E7ED)),
    );
  }
}
