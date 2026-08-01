import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';

// Terms Checklist Box
class TermsChecklistBox extends StatelessWidget {
  final List<String> steps;

  const TermsChecklistBox({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark
            ? CustomerAppColors.darkInputBackground
            : CustomerAppColors.background,
        borderRadius: BorderRadius.circular(20.r),
        border: isDark ? Border.all(color: CustomerAppColors.darkBorder) : null,
      ),
      child: Column(
        children: [
          // introduction text
          Text(
            'As a user of Street Cart, you agree to:',
            style: CustomerAppTextStyles.body.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 13.sp,
              color: isDark
                  ? CustomerAppColors.darkTextSecondary
                  : const Color(0xFF475569),
            ),
          ),
          SizedBox(height: 16.h),
          // List of each checklist item
          ...steps.map(
            (step) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle_outline_rounded,
                    size: 18.sp,
                    color: CustomerAppColors.primary.withValues(alpha: 0.7),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      step,
                      style: CustomerAppTextStyles.body.copyWith(
                        fontSize: 13.sp,
                        color: isDark
                            ? CustomerAppColors.darkTextSecondary
                            : const Color(0xFF64748B),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
