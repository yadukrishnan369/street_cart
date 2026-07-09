import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/utils/date_formatter.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';

enum TimelineStepState { completed, active, inactive }

class OrderTimelineTracker extends StatelessWidget {
  final OrderModel order;

  const OrderTimelineTracker({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final status = order.status.toLowerCase();
    final bool isDone =
        status == 'delivered' || status == 'cancelled' || status == 'returned';

    // timestamps of steps and null means the step hasn't happened yet
    final String placedTime = DateFormatter.formatToOrderDateTime(
      order.createdAt,
    );
    final String confirmedTime = order.confirmedAt != null
        ? DateFormatter.formatToOrderDateTime(order.confirmedAt!)
        : '';
    final String shippedTime = order.shippedAt != null
        ? DateFormatter.formatToOrderDateTime(order.shippedAt!)
        : '';
    final String deliveredTime = order.deliveredAt != null
        ? DateFormatter.formatToOrderDateTime(order.deliveredAt!)
        : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Text(
            isDone ? 'ORDER TIMELINE' : 'DELIVERY PROGRESS',
            style: TextStyle(
              color: ShopAppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 13.sp,
              letterSpacing: 0.5,
            ),
          ),
        ),

        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: [
              _buildTimelineStep(
                title: 'Order Placed',
                subtitle: placedTime,
                state: TimelineStepState.completed,
                isLast: false,
              ),
              _buildTimelineStep(
                title: 'Order Confirmed',
                subtitle: confirmedTime.isNotEmpty
                    ? confirmedTime
                    : (status == 'pending' || status == 'placed')
                    ? 'Waiting for confirmation'
                    : '',
                state: order.confirmedAt != null
                    ? TimelineStepState.completed
                    : (status == 'pending' || status == 'placed')
                    ? TimelineStepState.active
                    : TimelineStepState.inactive,
                isLast: false,
              ),
              _buildTimelineStep(
                title: 'Packed & Shipped',
                subtitle: shippedTime.isNotEmpty
                    ? shippedTime
                    : (status == 'processing')
                    ? 'Preparing/Shipped'
                    : '',
                state: order.shippedAt != null
                    ? TimelineStepState.completed
                    : (status == 'processing')
                    ? TimelineStepState.active
                    : TimelineStepState.inactive,
                isLast: false,
              ),
              _buildTimelineStep(
                title: 'Delivered',
                subtitle: deliveredTime.isNotEmpty
                    ? deliveredTime
                    : (status == 'shipped' || status == 'packed')
                    ? 'Out for delivery'
                    : '',
                state: order.deliveredAt != null
                    ? TimelineStepState.completed
                    : (status == 'shipped' || status == 'packed')
                    ? TimelineStepState.active
                    : TimelineStepState.inactive,
                isLast: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineStep({
    required String title,
    required String subtitle,
    required TimelineStepState state,
    required bool isLast,
  }) {
    Color nodeColor = Colors.grey[300]!;
    Widget nodeIcon = Container();

    if (state == TimelineStepState.completed) {
      nodeColor = ShopAppColors.primary;
      nodeIcon = Icon(Icons.check, color: Colors.white, size: 14.sp);
    } else if (state == TimelineStepState.active) {
      nodeColor = ShopAppColors.primary;
      nodeIcon = Container(
        width: 8.w,
        height: 8.w,
        decoration: const BoxDecoration(
          color: ShopAppColors.primary,
          shape: BoxShape.circle,
        ),
      );
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Indicator column
          Column(
            children: [
              Container(
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  color: state == TimelineStepState.completed
                      ? ShopAppColors.primary
                      : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: nodeColor,
                    width: state == TimelineStepState.active ? 6.w : 2.w,
                  ),
                ),
                child: Center(child: nodeIcon),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2.w,
                    color: state == TimelineStepState.completed
                        ? ShopAppColors.primary
                        : Colors.grey[200],
                  ),
                ),
            ],
          ),
          SizedBox(width: 16.w),

          // Details column
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: state != TimelineStepState.inactive
                          ? FontWeight.bold
                          : FontWeight.w500,
                      color: state != TimelineStepState.inactive
                          ? const Color(0xFF1E293B)
                          : Colors.grey[400],
                    ),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    SizedBox(height: 4.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
