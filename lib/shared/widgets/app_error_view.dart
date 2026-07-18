import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';

// App Error View
class AppErrorView extends StatelessWidget {
  final VoidCallback onRetry;
  final String message;
  final String? title;
  final IconData? icon;
  final Color? iconColor;

  const AppErrorView({
    super.key,
    required this.onRetry,
    this.message = 'Please check your internet connection and try again.',
    this.title,
    this.icon,
    this.iconColor,
  });

  bool _isNetworkError(String msg) {
    final lower = msg.toLowerCase();
    return lower.contains('connection') ||
        lower.contains('internet') ||
        lower.contains('network') ||
        lower.contains('offline');
  }

  @override
  Widget build(BuildContext context) {
    final isOffline = _isNetworkError(message);
    final displayTitle =
        title ??
        (isOffline ? 'No Internet Connection' : 'Something went wrong');
    final displayIcon =
        icon ??
        (isOffline ? Icons.wifi_off_rounded : Icons.error_outline_rounded);
    final displayColor = iconColor ?? (isOffline ? Colors.red : Colors.orange);
    final displayMessage = message.isNotEmpty
        ? message
        : 'An unexpected error occurred. Please try again.';

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Error Icon
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 1000),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(scale: value, child: child);
              },
              child: Container(
                padding: EdgeInsets.all(24.r),
                decoration: BoxDecoration(
                  color: displayColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: displayColor.withValues(alpha: 0.15),
                      blurRadius: 24,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(displayIcon, color: displayColor, size: 64.sp),
              ),
            ),

            // Error Content
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 20.0, end: 0.0),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutQuint,
              builder: (context, value, child) {
                final opacity = (1.0 - (value / 20.0)).clamp(0.0, 1.0);
                return Transform.translate(
                  offset: Offset(0, value),
                  child: Opacity(opacity: opacity, child: child),
                );
              },
              child: Column(
                children: [
                  SizedBox(height: 28.h),
                  Text(
                    displayTitle,
                    style: CustomerAppTextStyles.heading2.copyWith(
                      fontSize: 20.sp,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    displayMessage,
                    style: CustomerAppTextStyles.body.copyWith(
                      fontSize: 14.sp,
                      color: CustomerAppColors.textSecondary,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 36.h),
                  // Retry button
                  SizedBox(
                    width: 160.w,
                    child: PrimaryButton(
                      text: 'Try Again',
                      suffixIcon: Icon(
                        Icons.refresh_rounded,
                        color: Colors.white,
                        size: 18.sp,
                      ),
                      onPressed: onRetry,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
