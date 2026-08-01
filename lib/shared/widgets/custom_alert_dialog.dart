import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final String? secondaryActionLabel;
  final VoidCallback? onSecondaryAction;
  final String primaryActionLabel;
  final VoidCallback onPrimaryAction;
  final IconData? icon;
  final Color? iconColor;
  final Color? primaryActionColor;

  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.content,
    this.secondaryActionLabel,
    this.onSecondaryAction,
    required this.primaryActionLabel,
    required this.onPrimaryAction,
    this.icon,
    this.iconColor,
    this.primaryActionColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 400.w),
        child: Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(24.r),
            border: isDark
                ? Border.all(color: CustomerAppColors.darkBorder)
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: (iconColor ?? Theme.of(context).primaryColor)
                        .withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 32.sp,
                    color: iconColor ?? Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(height: 16.h),
              ],
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? CustomerAppColors.darkTextPrimary
                      : CustomerAppColors.textPrimary,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                content,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isDark
                      ? CustomerAppColors.darkTextSecondary
                      : Colors.grey[600],
                  height: 1.5,
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  if (secondaryActionLabel != null) ...[
                    Expanded(
                      child: TextButton(
                        onPressed:
                            onSecondaryAction ?? () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          secondaryActionLabel!,
                          style: TextStyle(
                            color: isDark
                                ? CustomerAppColors.darkTextSecondary
                                : Colors.grey[600],
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                  ],
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onPrimaryAction,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            primaryActionColor ??
                            Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        primaryActionLabel,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
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
