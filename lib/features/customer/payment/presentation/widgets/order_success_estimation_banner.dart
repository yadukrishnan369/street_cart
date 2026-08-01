import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';

// Order Success Estimation Banner
class OrderSuccessEstimationBanner extends StatelessWidget {
  final double totalAmount;
  final String paymentStatus;

  const OrderSuccessEstimationBanner({
    super.key,
    required this.totalAmount,
    required this.paymentStatus,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bool isPaid = paymentStatus.toLowerCase() == 'paid';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isDark
              ? CustomerAppColors.darkBorder
              : Colors.grey.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: isDark
                  ? CustomerAppColors.darkInputBackground
                  : Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.receipt_long_outlined,
              color: isDark
                  ? CustomerAppColors.darkTextSecondary
                  : CustomerAppColors.textSecondary,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ESTIMATED DELIVERY',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? CustomerAppColors.darkTextSecondary
                      : Colors.grey,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                '2 - 7 Days',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? CustomerAppColors.darkTextPrimary
                      : CustomerAppColors.textPrimary,
                ),
              ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                isPaid ? 'TOTAL PAID' : 'TOTAL PENDING',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? CustomerAppColors.darkTextSecondary
                      : Colors.grey,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                '₹${totalAmount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: isPaid ? CustomerAppColors.primary : Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
