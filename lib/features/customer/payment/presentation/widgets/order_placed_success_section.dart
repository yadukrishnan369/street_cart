import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/customer/payment/presentation/animation/riding_scooter_animation.dart';

// Order Placed Success Section
class OrderPlacedSuccessSection extends StatelessWidget {
  final String orderIdSuffix;

  const OrderPlacedSuccessSection({super.key, required this.orderIdSuffix});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        // Check Circle
        Container(
          width: 76.w,
          height: 76.w,
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Container(
              width: 56.w,
              height: 56.w,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check, color: Colors.white, size: 32.sp),
            ),
          ),
        ),
        SizedBox(height: 24.h),
        // Riding Scooter Animation
        const RidingScooterAnimation(),
        SizedBox(height: 32.h),
        // Header
        Text(
          'Order Placed Successfully!',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: isDark
                ? CustomerAppColors.darkTextPrimary
                : CustomerAppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 12.h),
        // Order Info
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(
              fontSize: 14.sp,
              color: isDark
                  ? CustomerAppColors.darkTextSecondary
                  : CustomerAppColors.textSecondary,
              height: 1.4,
            ),
            children: [
              const TextSpan(text: 'Your order ID is '),
              TextSpan(
                text: '#ORD-$orderIdSuffix',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: CustomerAppColors.primary,
                ),
              ),
              const TextSpan(
                text:
                    '. We\'ve received your street cart order and are processing it now.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
