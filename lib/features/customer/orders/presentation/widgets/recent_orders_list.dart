import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/customer/orders/presentation/bloc/orders_bloc.dart';
import 'package:street_cart/features/customer/orders/presentation/pages/order_details_page.dart';
import 'package:street_cart/features/customer/orders/presentation/pages/return_request_page.dart';
import 'package:street_cart/features/customer/orders/presentation/utils/orders_helper.dart';
import 'package:street_cart/features/customer/orders/presentation/utils/customer_order_status.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:street_cart/shared/widgets/product_image_placeholder.dart';
import 'package:street_cart/core/navigation/page_transitions.dart';
import 'package:street_cart/core/animation/staggered_animation.dart';

// Recent Orders List
class RecentOrdersList extends StatelessWidget {
  final List<OrderModel> orders;

  const RecentOrdersList({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) return const SizedBox.shrink();

    // Sort by order creation time
    final sortedOrders = OrdersHelper.getOrdersSortedByTime(orders);

    return AppStaggeredAnimation.limiter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Title
            _SectionLabel(label: 'MY ORDERS'),
            SizedBox(height: 8.h),
            ...AppStaggeredAnimation.toStaggeredList(
              children: sortedOrders.map((order) {
                final isCancellable = OrdersHelper.isCancellable(
                  CustomerOrderStatus.fromString(order.status),
                );
                return isCancellable
                    ? _ActiveOrderCard(order: order)
                    : _HistoryOrderCard(order: order);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
      // Title
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w900,
          color: isDark
              ? CustomerAppColors.darkTextSecondary
              : CustomerAppColors.textPrimary,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}

// Active order card and shows Cancel button
class _ActiveOrderCard extends StatelessWidget {
  final OrderModel order;
  const _ActiveOrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final displayItem = OrdersHelper.getDisplayItem(order);
    final statusColor = OrdersHelper.getStatusColor(
      CustomerOrderStatus.fromString(order.status),
    );
    final statusText = OrdersHelper.getDisplayStatus(
      CustomerOrderStatus.fromString(order.status),
    );
    final totalItems = OrdersHelper.getOrderTotalItems(order);
    final displayName = OrdersHelper.getOrderDisplayName(order);

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: isDark ? Border.all(color: CustomerAppColors.darkBorder) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          final ordersBloc = context.read<OrdersBloc>();
          Navigator.push(
            context,
            AppPageTransitions.slide(
              BlocProvider.value(
                value: ordersBloc,
                child: OrderDetailsPage(order: order),
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              // Product Name
                              child: Text(
                                displayName,
                                style: TextStyle(
                                  color: isDark
                                      ? CustomerAppColors.darkTextPrimary
                                      : CustomerAppColors.textPrimary,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            // Status badge
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 6.w,
                                    height: 6.w,
                                    decoration: BoxDecoration(
                                      color: statusColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: 4.w),
                                  // Status Text
                                  Text(
                                    statusText,
                                    style: TextStyle(
                                      color: statusColor,
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        // Order ID
                        Text(
                          'Order #${OrdersHelper.getOrderIdSuffix(order.id)} • $totalItems ${totalItems == 1 ? 'item' : 'items'}',
                          style: TextStyle(
                            color: isDark
                                ? CustomerAppColors.darkTextSecondary
                                : Colors.grey[500],
                            fontSize: 12.sp,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        // Price
                        Text(
                          'Total: ₹${order.totalAmount.toStringAsFixed(0)}',
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
                  // Product image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: CachedNetworkImage(
                      imageUrl: displayItem.productImage,
                      width: 64.w,
                      height: 64.w,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => ProductImagePlaceholder(
                        width: 64.w,
                        height: 64.w,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      errorWidget: (context, url, error) =>
                          ProductImagePlaceholder(
                            width: 64.w,
                            height: 64.w,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              // Cancel button
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        OrdersHelper.showCancelOrderDialog(
                          context: context,
                          orderId: order.id,
                          ordersBloc: context.read<OrdersBloc>(),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: isDark
                              ? CustomerAppColors.darkBorder
                              : const Color.fromARGB(255, 219, 214, 214),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                      ),
                      child: Text(
                        'Cancel Order',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 238, 160, 160),
                          fontWeight: FontWeight.w600,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Icon(
                    Icons.chevron_right,
                    color: isDark
                        ? CustomerAppColors.darkTextSecondary
                        : Colors.grey[400],
                    size: 20.sp,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// History order card
class _HistoryOrderCard extends StatelessWidget {
  final OrderModel order;
  const _HistoryOrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final displayItem = OrdersHelper.getDisplayItem(order);
    final createdDateStr = OrdersHelper.formatDateShort(order.createdAt);
    final statusStr = order.status.toLowerCase();
    final isDelivered = statusStr == 'delivered';

    // Date for each status
    final String statusDateStr;
    if (statusStr == 'cancelled') {
      statusDateStr = order.cancelledAt != null
          ? OrdersHelper.formatDateShort(order.cancelledAt!)
          : createdDateStr;
    } else if (statusStr == 'delivered') {
      statusDateStr = order.deliveredAt != null
          ? OrdersHelper.formatDateShort(order.deliveredAt!)
          : createdDateStr;
    } else if (statusStr == 'shipped') {
      statusDateStr = order.shippedAt != null
          ? OrdersHelper.formatDateShort(order.shippedAt!)
          : createdDateStr;
    } else if (statusStr == 'processing') {
      statusDateStr = order.processingAt != null
          ? OrdersHelper.formatDateShort(order.processingAt!)
          : createdDateStr;
    } else if (statusStr == 'confirmed') {
      statusDateStr = order.confirmedAt != null
          ? OrdersHelper.formatDateShort(order.confirmedAt!)
          : createdDateStr;
    } else {
      statusDateStr = createdDateStr;
    }

    final activeColor = CustomerAppColors.primary;

    final displayName = OrdersHelper.getOrderDisplayName(order);
    final returnStatus = (order.returnStatus ?? '').toLowerCase();
    final isReturnPicked =
        returnStatus == 'returned' || returnStatus == 'return_picked';
    final hasReturnRequest = returnStatus.isNotEmpty;

    String statusDisplay;
    if (hasReturnRequest && isDelivered) {
      if (isReturnPicked) {
        if (order.refundStatus == 'refunded') {
          statusDisplay = 'Returned • $statusDateStr';
        } else {
          statusDisplay = 'Returned & Pending Refund';
        }
      } else if (returnStatus == 'return_confirmed') {
        statusDisplay = 'Return Confirmed • $statusDateStr';
      } else {
        statusDisplay = 'Return Requested • $statusDateStr';
      }
    } else if (statusStr == 'cancelled') {
      if (order.refundStatus == 'pending') {
        statusDisplay = 'Cancelled & Pending Refund';
      } else if (order.refundStatus == 'refunded') {
        statusDisplay = 'Cancelled & Refunded';
      } else {
        statusDisplay = 'Cancelled • $statusDateStr';
      }
    } else if (isDelivered) {
      statusDisplay = 'Delivered • $statusDateStr';
    } else {
      statusDisplay =
          '${OrdersHelper.getDisplayStatus(CustomerOrderStatus.fromString(order.status))} • $statusDateStr';
    }

    return InkWell(
      onTap: () {
        final ordersBloc = context.read<OrdersBloc>();
        Navigator.push(
          context,
          AppPageTransitions.slide(
            BlocProvider.value(
              value: ordersBloc,
              child: OrderDetailsPage(order: order),
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16.r),
          border: isDark
              ? Border.all(color: CustomerAppColors.darkBorder)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        // Product Image
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: CachedNetworkImage(
                imageUrl: displayItem.productImage,
                width: 56.w,
                height: 56.w,
                fit: BoxFit.cover,
                placeholder: (context, url) => ProductImagePlaceholder(
                  width: 56.w,
                  height: 56.w,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                errorWidget: (context, url, error) => ProductImagePlaceholder(
                  width: 56.w,
                  height: 56.w,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            // Name of Product
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: TextStyle(
                      color: isDark
                          ? CustomerAppColors.darkTextPrimary
                          : CustomerAppColors.textPrimary,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  // Order Status
                  if (statusDisplay == 'Returned & Pending Refund' ||
                      statusDisplay == 'Cancelled & Pending Refund') ...[
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.normal,
                        ),
                        children: [
                          TextSpan(
                            text: statusDisplay.contains('Returned')
                                ? 'Returned • $statusDateStr - '
                                : 'Cancelled • $statusDateStr - ',
                            style: TextStyle(
                              color: statusDisplay.contains('Returned')
                                  ? CustomerAppColors.success
                                  : CustomerAppColors.error,
                            ),
                          ),
                          TextSpan(
                            text: 'Refund Pending',
                            style: TextStyle(color: CustomerAppColors.warning),
                          ),
                        ],
                      ),
                    ),
                  ] else if (order.status.toLowerCase() == 'cancelled' &&
                      order.refundStatus == 'refunded') ...[
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.normal,
                        ),
                        children: [
                          TextSpan(
                            text: 'Cancelled • $statusDateStr - ',
                            style: TextStyle(color: CustomerAppColors.error),
                          ),
                          TextSpan(
                            text: 'Refunded',
                            style: TextStyle(
                              color: CustomerAppColors.success,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    Text(
                      statusDisplay,
                      style: TextStyle(
                        color: hasReturnRequest && isDelivered
                            ? (isReturnPicked
                                  ? (order.refundStatus == 'refunded'
                                        ? CustomerAppColors.success
                                        : CustomerAppColors.warning)
                                  : CustomerAppColors.error)
                            : order.status.toLowerCase() == 'cancelled'
                            ? (order.refundStatus == 'refunded'
                                  ? CustomerAppColors.success
                                  : CustomerAppColors.error)
                            : isDelivered
                            ? CustomerAppColors.success
                            : isDark
                            ? CustomerAppColors.darkTextSecondary
                            : Colors.grey[500],
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Return Button
            if (OrdersHelper.isReturnEligible(order) &&
                (order.returnStatus == null ||
                    order.returnStatus!.isEmpty)) ...[
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    AppPageTransitions.slide(
                      BlocProvider.value(
                        value: context.read<OrdersBloc>(),
                        child: ReturnRequestPage(
                          order: order,
                          item: displayItem,
                        ),
                      ),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Return Item',
                  style: TextStyle(
                    color: activeColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 4.w),
            ],
            Icon(
              Icons.chevron_right,
              color: isDark
                  ? CustomerAppColors.darkTextSecondary
                  : Colors.grey[400],
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }
}
