import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/customer/orders/presentation/bloc/orders_bloc.dart';
import 'package:street_cart/features/customer/orders/presentation/pages/order_details_page.dart';
import 'package:street_cart/features/customer/orders/presentation/utils/orders_helper.dart';
import 'package:street_cart/features/customer/orders/presentation/utils/customer_order_status.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:street_cart/shared/widgets/product_image_placeholder.dart';

class RecentOrdersList extends StatelessWidget {
  final List<OrderModel> orders;

  const RecentOrdersList({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) return const SizedBox.shrink();

    // Split into active and history
    final activeOrders = orders
        .where(
          (o) => OrdersHelper.isCancellable(
            CustomerOrderStatus.fromString(o.status),
          ),
        )
        .toList();
    final historyOrders = orders
        .where(
          (o) => !OrdersHelper.isCancellable(
            CustomerOrderStatus.fromString(o.status),
          ),
        )
        .toList();

    // Move delivered orders to the bottom of history list
    final nonDeliveredHistory = historyOrders
        .where((o) => o.status.toLowerCase() != 'delivered')
        .toList();
    final deliveredHistory = historyOrders
        .where((o) => o.status.toLowerCase() == 'delivered')
        .toList();
    final sortedHistoryOrders = [...nonDeliveredHistory, ...deliveredHistory];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ACTIVE ORDERS
          if (activeOrders.isNotEmpty) ...[
            _SectionLabel(label: 'ACTIVE ORDERS'),
            SizedBox(height: 8.h),
            ...activeOrders.map((order) => _ActiveOrderCard(order: order)),
            SizedBox(height: 24.h),
          ],

          // ORDER HISTORY
          if (sortedHistoryOrders.isNotEmpty) ...[
            _SectionLabel(label: 'RECENT HISTORY'),
            SizedBox(height: 8.h),
            ...sortedHistoryOrders.map(
              (order) => _HistoryOrderCard(order: order),
            ),
          ],
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w900,
          color: const Color(0xFF1E293B),
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
    final firstItem = order.items.first;
    final statusColor = OrdersHelper.getStatusColor(
      CustomerOrderStatus.fromString(order.status),
    );
    final statusText = OrdersHelper.getDisplayStatus(
      CustomerOrderStatus.fromString(order.status),
    );
    final totalItems = order.items.fold<int>(
      0,
      (sum, item) => sum + item.quantity,
    );

    final displayName = order.items.length > 1
        ? '${firstItem.productName} and ${order.items.length - 1} more'
        : firstItem.productName;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
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
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
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
                              child: Text(
                                displayName,
                                style: TextStyle(
                                  color: CustomerAppColors.textPrimary,
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
                                color: statusColor.withOpacity(0.1),
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
                        Text(
                          'Order #${OrdersHelper.getOrderIdSuffix(order.id)} • $totalItems ${totalItems == 1 ? 'item' : 'items'}',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12.sp,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Total: ₹${order.totalAmount.toStringAsFixed(0)}',
                          style: TextStyle(
                            color: Colors.grey[600],
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
                      imageUrl: firstItem.productImage,
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
              // Cancel button row
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
                          color: const Color.fromARGB(255, 219, 214, 214),
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
                    color: Colors.grey[400],
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
    final firstItem = order.items.first;
    final dateStr = OrdersHelper.formatDateShort(order.createdAt);
    final isDelivered = order.status.toLowerCase() == 'delivered';
    final activeColor = const Color(0xFF5E5CE6);

    final displayName = order.items.length > 1
        ? '${firstItem.productName} and ${order.items.length - 1} more'
        : firstItem.productName;

    String statusDisplay;
    if (order.status.toLowerCase() == 'cancelled') {
      statusDisplay = 'Cancelled $dateStr';
    } else if (isDelivered) {
      statusDisplay = 'Delivered $dateStr';
    } else {
      statusDisplay =
          '${OrdersHelper.getDisplayStatus(CustomerOrderStatus.fromString(order.status))} • $dateStr';
    }

    return InkWell(
      onTap: () {
        final ordersBloc = context.read<OrdersBloc>();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: CachedNetworkImage(
                imageUrl: firstItem.productImage,
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: TextStyle(
                      color: CustomerAppColors.textPrimary,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    statusDisplay,
                    style: TextStyle(
                      color: order.status.toLowerCase() == 'cancelled'
                          ? CustomerAppColors.error
                          : Colors.grey[500],
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            if (OrdersHelper.isReturnEligible(order)) ...[
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Return request initiated for ${firstItem.productName}',
                      ),
                      behavior: SnackBarBehavior.floating,
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
            Icon(Icons.chevron_right, color: Colors.grey[400], size: 20.sp),
          ],
        ),
      ),
    );
  }
}
