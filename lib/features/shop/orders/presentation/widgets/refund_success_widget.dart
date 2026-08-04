import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/utils/price_utils.dart';

// Refund Success Widget
class RefundSuccessWidget extends StatelessWidget {
  final double amount;
  final VoidCallback onDismiss;

  const RefundSuccessWidget({
    super.key,
    required this.amount,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: Container(
        color: Colors.black54,
        alignment: Alignment.center,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 24.w),
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: isDark ? ShopAppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.26),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72.w,
                height: 72.w,
                decoration: BoxDecoration(
                  color: isDark
                      ? ShopAppColors.primary.withValues(alpha: 0.2)
                      : const Color(0xFFE8F5E9),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_rounded,
                  color: ShopAppColors.success,
                  size: 48.sp,
                ),
              ),
              SizedBox(height: 20.h),
              // Title
              Text(
                'Refund Initiated Successfully',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark
                      ? ShopAppColors.darkTextPrimary
                      : ShopAppColors.textPrimary,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.h),
              // Subtitle with Refund Amount
              Text(
                'A refund of ₹${PriceUtils.formatPrice(amount)} has been successfully processed for this order.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark
                      ? ShopAppColors.darkTextSecondary
                      : Colors.grey[600],
                  fontSize: 13.sp,
                ),
              ),
              SizedBox(height: 24.h),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ShopAppColors.primary,
                  padding: EdgeInsets.symmetric(
                    horizontal: 32.w,
                    vertical: 12.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                onPressed: onDismiss,
                child: Text(
                  'Done',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
