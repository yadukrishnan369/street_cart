import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/utils/date_formatter.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';

// Shop Return Progress Tracker
class ShopReturnProgressTracker extends StatelessWidget {
  final OrderModel order;

  const ShopReturnProgressTracker({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final returnStatus = (order.returnStatus ?? '').toLowerCase();
    // Steps
    final isStep1Completed = returnStatus.isNotEmpty;
    final isStep2Completed =
        returnStatus == 'return_confirmed' ||
        returnStatus == 'returned' ||
        returnStatus == 'return_picked';
    final isStep3Completed =
        returnStatus == 'returned' || returnStatus == 'return_picked';
    // Status Time
    final returnedTime = order.returnedAt != null
        ? DateFormatter.formatToOrderDateTime(order.returnedAt!)
        : 'Request Submitted';
    final confirmedTime = order.returnConfirmedAt != null
        ? DateFormatter.formatToOrderDateTime(order.returnConfirmedAt!)
        : (isStep2Completed ? 'Confirmed' : 'Pending confirmation');
    final pickedTime = order.returnPickedAt != null
        ? DateFormatter.formatToOrderDateTime(order.returnPickedAt!)
        : (isStep3Completed ? 'Item Picked Up' : 'Pending pickup');
    // Return Tracker Steps
    final steps = [
      {
        'title': 'Return Requested',
        'time': returnedTime,
        'completed': isStep1Completed,
      },
      {
        'title': 'Return Accepted',
        'time': confirmedTime,
        'completed': isStep2Completed,
      },
      {
        'title': 'Return Picked',
        'time': pickedTime,
        'completed': isStep3Completed,
      },
    ];

    int activeIndex = 0;
    if (isStep3Completed) {
      activeIndex = 2;
    } else if (isStep2Completed) {
      activeIndex = 1;
    } else if (isStep1Completed) {
      activeIndex = 0;
    }

    final activeColor = ShopAppColors.error;

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
              color: ShopAppColors.primary,
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
                            color: isCompleted
                                ? activeColor
                                : (isDark
                                      ? ShopAppColors.darkSurface
                                      : Colors.white),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isCompleted
                                  ? activeColor
                                  : (isDark
                                        ? ShopAppColors.darkBorder
                                        : ShopAppColors.textPrimary),
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
                                  color: isDark
                                      ? ShopAppColors.darkTextPrimary
                                      : ShopAppColors.textPrimary,
                                )
                              : null,
                        ),
                        if (!isLast)
                          Expanded(
                            child: Container(
                              width: 2.w,
                              color: isCompleted && index < activeIndex
                                  ? activeColor
                                  : (isDark
                                        ? ShopAppColors.darkBorder
                                        : Colors.grey[300]),
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
                                    ? activeColor
                                    : (isDark
                                          ? ShopAppColors.darkTextPrimary
                                          : ShopAppColors.textPrimary),
                              ),
                            ),
                            SizedBox(height: 2.h),
                            // Status Time
                            Text(
                              step['time'] as String,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: isCompleted
                                    ? activeColor.withAlpha(180)
                                    : (isDark
                                          ? ShopAppColors.darkTextSecondary
                                          : ShopAppColors.textPrimary
                                                .withValues(alpha: 0.6)),
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
