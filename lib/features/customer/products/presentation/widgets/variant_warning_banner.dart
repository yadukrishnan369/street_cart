import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';

// Variant Unavailable Warning Banner
class VariantWarningBanner extends StatelessWidget {
  final String warningMessage;

  const VariantWarningBanner({super.key, required this.warningMessage});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isDark
            ? CustomerAppColors.error.withValues(alpha: 0.12)
            : const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: isDark
              ? CustomerAppColors.error.withValues(alpha: 0.35)
              : const Color(0xFFFECACA),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: CustomerAppColors.error,
            size: 20.sp,
          ),
          SizedBox(width: 8.w),
          Expanded(
            // Warning Message
            child: Text(
              warningMessage,
              style: TextStyle(
                fontSize: 13.sp,
                color: isDark
                    ? CustomerAppColors.darkTextPrimary
                    : CustomerAppColors.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
