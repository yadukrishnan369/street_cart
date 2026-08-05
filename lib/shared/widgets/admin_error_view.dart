import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';

// Admin Error Views
class AdminErrorView extends StatelessWidget {
  final VoidCallback onRetry;
  final String message;
  final String? title;
  final IconData? icon;
  final Color? iconColor;

  const AdminErrorView({
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isOffline = _isNetworkError(message);
    final displayTitle =
        title ?? (isOffline ? 'Connection Timeout' : 'Unable to Load Resource');
    final displayIcon =
        icon ??
        (isOffline ? Icons.wifi_off_rounded : Icons.error_outline_rounded);
    final displayColor =
        iconColor ??
        (isOffline ? AdminAppColors.errorColor : AdminAppColors.warningColor);
    final displayMessage = message.isNotEmpty
        ? message
        : 'An unexpected system error occurred. Please try again.';

    return Align(
      alignment: const Alignment(-0.15, -0.20),
      child: Container(
        constraints: BoxConstraints(maxWidth: 600.w),
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOutBack,
              builder: (context, value, child) {
                return Transform.scale(scale: value, child: child);
              },
              child: Container(
                padding: EdgeInsets.all(28.r),
                decoration: BoxDecoration(
                  color: displayColor.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(displayIcon, color: displayColor, size: 64.sp),
              ),
            ),
            SizedBox(height: 28.h),
            // Title
            Text(
              displayTitle,
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AdminAppColors.darkTextPrimary
                    : AdminAppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            // Message
            Text(
              displayMessage,
              style: TextStyle(
                fontSize: 15.sp,
                color: isDark
                    ? AdminAppColors.darkTextSecondary
                    : AdminAppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            // Button for Reload
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: Icon(
                Icons.refresh_rounded,
                size: 20.sp,
                color: Colors.white,
              ),
              label: Text(
                'Retry Connection',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AdminAppColors.primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
