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

class RecentOrdersList extends StatelessWidget {
  final List<OrderModel> orders;

  const RecentOrdersList({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) return const SizedBox.shrink();

    // Sort by order creation time
    final sortedOrders = OrdersHelper.getOrdersSortedByTime(orders);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Page Title
          _SectionLabel(label: 'MY ORDERS'),
          SizedBox(height: 8.h),
          ...sortedOrders.map((order) {
            final isCancellable = OrdersHelper.isCancellable(
              CustomerOrderStatus.fromString(order.status),
            );
            return isCancellable
                ? _ActiveOrderCard(order: order)
                : _HistoryOrderCard(order: order);
          }),
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
      // Title
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
    final totalItems = OrdersHelper.getOrderTotalItems(order);
    final displayName = OrdersHelper.getOrderDisplayName(order);

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
                              // Product Name
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
                            color: Colors.grey[500],
                            fontSize: 12.sp,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        // Price
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
    final createdDateStr = OrdersHelper.formatDateShort(order.createdAt);
    final deliveredDateStr = order.deliveredAt != null
        ? OrdersHelper.formatDateShort(order.deliveredAt!)
        : createdDateStr;
    final isDelivered = order.status.toLowerCase() == 'delivered';
    final activeColor = CustomerAppColors.primary;

    final displayName = OrdersHelper.getOrderDisplayName(order);
    final returnStatus = (order.returnStatus ?? '').toLowerCase();
    final isReturnPicked =
        returnStatus == 'returned' || returnStatus == 'return_picked';
    final hasReturnRequest = returnStatus.isNotEmpty;

    String statusDisplay;
    if (hasReturnRequest && isDelivered) {
      if (isReturnPicked) {
        statusDisplay = 'Item Returned';
      } else {
        statusDisplay = 'Return Requested';
      }
    } else if (order.status.toLowerCase() == 'cancelled') {
      statusDisplay = 'Cancelled $createdDateStr';
    } else if (isDelivered) {
      statusDisplay = 'Delivered $deliveredDateStr';
    } else {
      statusDisplay =
          '${OrdersHelper.getDisplayStatus(CustomerOrderStatus.fromString(order.status))} • $createdDateStr';
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
        // Product Image
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
            // Name of Product
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
                  // Order Status
                  Text(
                    statusDisplay,
                    style: TextStyle(
                      color: hasReturnRequest && isDelivered
                          ? (isReturnPicked
                                ? CustomerAppColors.success
                                : CustomerAppColors.error)
                          : order.status.toLowerCase() == 'cancelled'
                          ? CustomerAppColors.error
                          : isDelivered
                          ? CustomerAppColors.success
                          : Colors.grey[500],
                      fontSize: 12.sp,
                    ),
                  ),
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
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<OrdersBloc>(),
                        child: ReturnRequestPage(order: order, item: firstItem),
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
            Icon(Icons.chevron_right, color: Colors.grey[400], size: 20.sp),
          ],
        ),
      ),
    );
  }
}
