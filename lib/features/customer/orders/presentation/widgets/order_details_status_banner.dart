import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/customer/orders/presentation/utils/customer_order_status.dart';
import 'package:street_cart/features/customer/orders/presentation/utils/orders_helper.dart';

// Order Details Status Banner
class OrderDetailsStatusBanner extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsStatusBanner({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final status = CustomerOrderStatus.fromString(order.status);
    final isDelivered = OrdersHelper.isDelivered(status);
    final isCancelled = OrdersHelper.isCancelled(status);
    final createdDateStr = OrdersHelper.formatDateShort(order.createdAt);
    final deliveredDateStr = order.deliveredAt != null
        ? OrdersHelper.formatDateShort(order.deliveredAt!)
        : createdDateStr;
    final activeColor = CustomerAppColors.primary;

    // Return statuses
    final returnStatus = (order.returnStatus ?? '').toLowerCase();
    final hasReturnRequest = returnStatus.isNotEmpty;
    final isReturnPicked =
        returnStatus == 'returned' || returnStatus == 'return_picked';

    // Show return banner if a return initiated
    if (isDelivered && hasReturnRequest) {
      if (isReturnPicked) {
        final pickedDateStr = order.returnPickedAt != null
            ? OrdersHelper.formatDateShort(order.returnPickedAt!)
            : deliveredDateStr;

        final refundBanner = order.refundStatus == 'refunded'
            ? _buildBanner(
                isDark: isDark,
                color: isDark
                    ? const Color(0xFF1B3A2B)
                    : const Color(0xFFE8F5E9),
                borderColor: isDark
                    ? const Color(0xFF2E6B47)
                    : const Color(0xFFC8E6C9),
                iconColor: CustomerAppColors.success,
                icon: Icons.currency_rupee,
                title: 'Refund Completed',
                subtitle:
                    'A refund of ₹${order.refundAmount ?? order.totalAmount} has been processed.',
                textColor: CustomerAppColors.success,
              )
            : _buildBanner(
                isDark: isDark,
                color: isDark
                    ? const Color(0xFF3A2E1B)
                    : const Color(0xFFFFF3E0),
                borderColor: isDark
                    ? const Color(0xFF6B4E2E)
                    : const Color(0xFFFFE0B2),
                iconColor: CustomerAppColors.warning,
                icon: Icons.hourglass_empty,
                title: 'Refund Processing',
                subtitle:
                    'Refund will be credited to your account within 2-3 business days.',
                textColor: CustomerAppColors.warning,
              );

        return Column(
          children: [
            _buildBanner(
              isDark: isDark,
              color: isDark ? const Color(0xFF1B3A2B) : const Color(0xFFE8F5E9),
              borderColor: isDark
                  ? const Color(0xFF2E6B47)
                  : const Color(0xFFC8E6C9),
              iconColor: CustomerAppColors.success,
              icon: Icons.assignment_return_rounded,
              title: 'Item Returned on $pickedDateStr',
              subtitle: 'The item has been successfully picked up.',
              textColor: CustomerAppColors.success,
            ),
            SizedBox(height: 12.h),
            refundBanner,
          ],
        );
      } else if (returnStatus == 'return_confirmed') {
        final confirmedDateStr = order.returnConfirmedAt != null
            ? OrdersHelper.formatDateShort(order.returnConfirmedAt!)
            : deliveredDateStr;
        return _buildBanner(
          isDark: isDark,
          color: isDark ? const Color(0xFF1B2D3A) : const Color(0xFFE3F2FD),
          borderColor: isDark
              ? const Color(0xFF2E4D6B)
              : const Color(0xFFBBDEFB),
          iconColor: CustomerAppColors.primary,
          icon: Icons.assignment_turned_in_outlined,
          title: 'Return Confirmed on $confirmedDateStr',
          subtitle: 'Your return request has been confirmed.',
          textColor: CustomerAppColors.primary,
        );
      } else {
        // Return requested or confirmed with date
        final returnedDateStr = order.returnedAt != null
            ? OrdersHelper.formatDateShort(order.returnedAt!)
            : deliveredDateStr;
        return _buildBanner(
          isDark: isDark,
          color: isDark ? const Color(0xFF3A2E1B) : const Color(0xFFFFF3E0),
          borderColor: isDark
              ? const Color(0xFF6B4E2E)
              : const Color(0xFFFFE0B2),
          iconColor: CustomerAppColors.error,
          icon: Icons.assignment_return_outlined,
          title: 'Return Requested on $returnedDateStr',
          subtitle: 'Your return request is being processed.',
          textColor: CustomerAppColors.error,
        );
      }
    }

    if (isDelivered) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E2A3A) : const Color(0xFFF1F0FF),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isDark ? const Color(0xFF3A4A6A) : const Color(0xFFE2DFFF),
          ),
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
                  // Delivered Date
                  Text(
                    'Delivered on $deliveredDateStr',
                    style: TextStyle(
                      color: isDark
                          ? CustomerAppColors.darkTextPrimary
                          : CustomerAppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  // Customer Name
                  Text(
                    'Handed over to ${order.deliveryAddress.fullName}',
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                      fontSize: 12.sp,
                    ),
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
          color: isDark ? const Color(0xFF3A1B1B) : Colors.red[50],
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isDark ? const Color(0xFF6B2E2E) : Colors.red[100]!,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: const BoxDecoration(
                color: CustomerAppColors.error,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close, color: Colors.white, size: 20.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cancelled Title
                  Text(
                    'Cancelled on $createdDateStr',
                    style: TextStyle(
                      color: CustomerAppColors.error,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'This order was cancelled.',
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey,
                      fontSize: 12.sp,
                    ),
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
          color: CustomerAppColors.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: CustomerAppColors.primary.withValues(alpha: 0.15),
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
                  // Delivery Progress Title
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
                      color: CustomerAppColors.primary.withValues(alpha: 0.7),
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

  Widget _buildBanner({
    required bool isDark,
    required Color color,
    required Color borderColor,
    required Color iconColor,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color textColor,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(color: iconColor, shape: BoxShape.circle),
            child: Icon(icon, color: Colors.white, size: 20.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.sp,
                  ),
                ),
                SizedBox(height: 2.h),
                // Subtitle
                Text(
                  subtitle,
                  style: TextStyle(
                    color: textColor.withValues(alpha: 0.7),
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
