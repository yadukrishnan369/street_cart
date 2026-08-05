import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/admin/orders/presentation/utils/admin_orders_helper.dart';

// Admin Order Detail Header
class AdminOrderDetailHeader extends StatelessWidget {
  final OrderModel order;
  final String formattedId;
  final String dateStr;
  final String timeStr;

  const AdminOrderDetailHeader({
    super.key,
    required this.order,
    required this.formattedId,
    required this.dateStr,
    required this.timeStr,
  });
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final returnStatus = (order.returnStatus ?? '').toLowerCase();
    final status = returnStatus.isNotEmpty ? order.returnStatus! : order.status;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Order ID
            Text(
              'Order $formattedId',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AdminAppColors.darkTextPrimary
                    : AdminAppColors.textPrimary,
              ),
            ),
            SizedBox(width: 12.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AdminOrdersHelper.getStatusBgColor(status),
                borderRadius: BorderRadius.circular(100.r),
              ),
              child: Text(
                AdminOrdersHelper.getStatusLabel(status),
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                  color: AdminOrdersHelper.getStatusTextColor(status),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        // Order Placed Date & Time
        Text(
          'Placed on $dateStr at $timeStr',
          style: TextStyle(
            fontSize: 13.sp,
            color: isDark
                ? AdminAppColors.darkTextSecondary
                : const Color(0xFF8A8A9E),
          ),
        ),
      ],
    );
  }
}
