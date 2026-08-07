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

    final returnedItems = AdminOrdersHelper.getReturnedItems(order);
    final cancelledItems = AdminOrdersHelper.getCancelledItems(order);
    final allItemsCancelled = AdminOrdersHelper.isAllItemsCancelled(order);
    final allItemsReturned = AdminOrdersHelper.isAllItemsReturned(order);
    final allItemsCancelledOrReturned =
        AdminOrdersHelper.isAllItemsCancelledOrReturned(order);

    final String mainStatus;
    final String? secondaryStatusLabel;
    final Color? secondaryStatusBg;
    final Color? secondaryStatusText;

    if (allItemsCancelled) {
      mainStatus = 'cancelled';
      secondaryStatusLabel = null;
      secondaryStatusBg = null;
      secondaryStatusText = null;
    } else if (allItemsReturned) {
      mainStatus = order.returnStatus ?? 'returned';
      secondaryStatusLabel = null;
      secondaryStatusBg = null;
      secondaryStatusText = null;
    } else if (allItemsCancelledOrReturned) {
      mainStatus = 'returned';
      if (cancelledItems.isNotEmpty) {
        secondaryStatusLabel = '${cancelledItems.length} Cancelled';
        secondaryStatusBg = const Color(0xFFFCE8E6);
        secondaryStatusText = AdminAppColors.errorColor;
      } else {
        secondaryStatusLabel = null;
        secondaryStatusBg = null;
        secondaryStatusText = null;
      }
    } else {
      final String orderMainStatus = order.status;
      mainStatus = orderMainStatus;
      if (orderMainStatus.toLowerCase() == 'delivered') {
        if (returnedItems.isNotEmpty) {
          final isRequested = returnedItems.any(
            (i) => i.returnStatus!.toLowerCase() == 'return_requested',
          );
          secondaryStatusLabel = isRequested
              ? '${returnedItems.length} Requested'
              : '${returnedItems.length} Returned';
          secondaryStatusBg = const Color(0xFFFFF3E0);
          secondaryStatusText = AdminAppColors.warningColor;
        } else if (cancelledItems.isNotEmpty) {
          secondaryStatusLabel = '${cancelledItems.length} Cancelled';
          secondaryStatusBg = const Color(0xFFFCE8E6);
          secondaryStatusText = AdminAppColors.errorColor;
        } else {
          secondaryStatusLabel = null;
          secondaryStatusBg = null;
          secondaryStatusText = null;
        }
      } else {
        secondaryStatusLabel = null;
        secondaryStatusBg = null;
        secondaryStatusText = null;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12.w,
          runSpacing: 8.h,
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
            // Main Status Badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AdminOrdersHelper.getStatusBgColor(mainStatus),
                borderRadius: BorderRadius.circular(100.r),
              ),
              child: Text(
                AdminOrdersHelper.getStatusLabel(mainStatus),
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                  color: AdminOrdersHelper.getStatusTextColor(mainStatus),
                ),
              ),
            ),
            // Secondary Status Badge
            if (secondaryStatusLabel != null)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: secondaryStatusBg,
                  borderRadius: BorderRadius.circular(100.r),
                ),
                child: Text(
                  secondaryStatusLabel,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    color: secondaryStatusText,
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
