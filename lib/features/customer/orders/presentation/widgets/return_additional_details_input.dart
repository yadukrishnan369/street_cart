import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';

// Return Additional Details Input
class ReturnAdditionalDetailsInput extends StatelessWidget {
  final TextEditingController controller;

  const ReturnAdditionalDetailsInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: isDark ? Border.all(color: CustomerAppColors.darkBorder) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      // Text Field for Return Additional Detail
      child: TextField(
        controller: controller,
        maxLines: 4,
        style: TextStyle(
          fontSize: 14.sp,
          color: isDark
              ? CustomerAppColors.darkTextPrimary
              : CustomerAppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: 'Type additional details here...',
          hintStyle: TextStyle(
            fontSize: 13.sp,
            color: isDark
                ? CustomerAppColors.darkTextSecondary
                : Colors.grey[400],
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
