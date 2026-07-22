import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/utils/date_formatter.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';

// Return Progress Tracker
class ReturnProgressTracker extends StatelessWidget {
  final OrderModel order;

  const ReturnProgressTracker({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final returnStatus = (order.returnStatus ?? '').toLowerCase();

    // Step Completions
    final isStep1Completed = returnStatus.isNotEmpty;
    final isStep2Completed =
        returnStatus == 'return_confirmed' ||
        returnStatus == 'returned' ||
        returnStatus == 'return_picked';
    final isStep3Completed =
        returnStatus == 'returned' || returnStatus == 'return_picked';

    final returnedTime = order.returnedAt != null
        ? DateFormatter.formatToOrderDateTime(order.returnedAt!)
        : 'Request Submitted';
    final confirmedTime = order.returnConfirmedAt != null
        ? DateFormatter.formatToOrderDateTime(order.returnConfirmedAt!)
        : (isStep2Completed ? 'Confirmed' : 'Pending confirmation');
    final pickedTime = order.returnPickedAt != null
        ? DateFormatter.formatToOrderDateTime(order.returnPickedAt!)
        : (isStep3Completed ? 'Item Picked Up' : 'Pending pickup');

    final steps = [
      {
        'title': 'Returned',
        'time': returnedTime,
        'completed': isStep1Completed,
      },
      {
        'title': 'Confirmed',
        'time': confirmedTime,
        'completed': isStep2Completed,
      },
      {'title': 'Picked', 'time': pickedTime, 'completed': isStep3Completed},
    ];

    int activeIndex = 0;
    if (isStep3Completed) {
      activeIndex = 2;
    } else if (isStep2Completed) {
      activeIndex = 1;
    } else if (isStep1Completed) {
      activeIndex = 0;
    }

    final activeColor = CustomerAppColors.primary;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'RETURN TRACKING',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF1E293B),
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
              final isActiveStage = index == activeIndex;

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
                            color: isCompleted ? activeColor : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isCompleted
                                  ? activeColor
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
                                  Icons.assignment_return_outlined,
                                  size: 14.sp,
                                  color: activeColor,
                                )
                              : null,
                        ),
                        if (!isLast)
                          Expanded(
                            child: Container(
                              width: 2.w,
                              color: isCompleted && index < activeIndex
                                  ? activeColor
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
                            // Status Title
                            Text(
                              step['title'] as String,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                color: isCompleted
                                    ? (isActiveStage
                                          ? activeColor
                                          : const Color(0xFF1E293B))
                                    : Colors.grey[500],
                              ),
                            ),
                            SizedBox(height: 2.h),
                            // Status Time
                            Text(
                              step['time'] as String,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: isCompleted
                                    ? (isActiveStage
                                          ? activeColor.withValues(alpha: 0.7)
                                          : Colors.grey[500])
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
