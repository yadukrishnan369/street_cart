import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/shared/widgets/app_logo.dart';

// About Logo Section
class AboutLogoSection extends StatelessWidget {
  const AboutLogoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: 140.w,
      height: 140.w,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark
            ? CustomerAppColors.primary.withValues(alpha: 0.15)
            : const Color(0xFFEEEFFF),
        borderRadius: BorderRadius.circular(36.r),
        border: isDark ? Border.all(color: CustomerAppColors.darkBorder) : null,
      ),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: CustomerAppColors.primary,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: CustomerAppColors.primary.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(child: AppLogo(isDark: true, size: 80.w)),
      ),
    );
  }
}
