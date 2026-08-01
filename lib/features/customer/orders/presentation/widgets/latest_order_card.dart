import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/customer/orders/presentation/utils/orders_helper.dart';
import 'package:street_cart/features/customer/orders/presentation/utils/customer_order_status.dart';

// Latest Order Card
class LatestOrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onCancel;

  const LatestOrderCard({
    super.key,
    required this.order,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    if (order.items.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final firstItem = order.items.first;
    final totalItems = OrdersHelper.getOrderTotalItems(order);
    final statusColor = OrdersHelper.getStatusColor(
      CustomerOrderStatus.fromString(order.status),
    );
    final statusText = OrdersHelper.getDisplayStatus(
      CustomerOrderStatus.fromString(order.status),
    );
    final orderIdText = OrdersHelper.getOrderIdSuffix(order.id);

    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: isDark ? Border.all(color: CustomerAppColors.darkBorder) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // Product Info
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8.w,
                          height: 8.w,
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            statusText,
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    // Product Name
                    Text(
                      firstItem.productName,
                      style: TextStyle(
                        color: isDark
                            ? CustomerAppColors.darkTextPrimary
                            : CustomerAppColors.textPrimary,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Order $orderIdText • $totalItems ${totalItems == 1 ? 'Item' : 'Items'}',
                      style: TextStyle(
                        color: isDark
                            ? CustomerAppColors.darkTextSecondary
                            : Colors.grey[600],
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.network(
                  firstItem.productImage,
                  width: 72.w,
                  height: 72.w,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 72.w,
                    height: 72.w,
                    color: isDark
                        ? CustomerAppColors.darkInputBackground
                        : Colors.grey[200],
                    child: Icon(
                      Icons.image,
                      color: isDark
                          ? CustomerAppColors.darkTextSecondary
                          : Colors.grey[400],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Cancel Button
          if (OrdersHelper.isCancellable(
            CustomerOrderStatus.fromString(order.status),
          )) ...[
            SizedBox(height: 16.h),
            SizedBox(
              width: double.infinity,
              height: 38.h,
              child: OutlinedButton(
                onPressed: onCancel,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: isDark
                        ? CustomerAppColors.darkBorder
                        : Colors.grey[300]!,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: isDark
                        ? CustomerAppColors.darkTextPrimary
                        : CustomerAppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
