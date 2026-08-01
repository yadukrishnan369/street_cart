import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';

// Support Illustration Banner
class SupportIllustrationBanner extends StatelessWidget {
  const SupportIllustrationBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 200.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark
            ? CustomerAppColors.primary.withValues(alpha: 0.15)
            : const Color(0xFFF0F1FF),
        borderRadius: BorderRadius.circular(32.r),
        border: isDark ? Border.all(color: CustomerAppColors.darkBorder) : null,
        gradient: isDark
            ? null
            : const LinearGradient(
                colors: [Color(0xFFE8EAFF), Color(0xFFF5F6FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
      ),
      child: Center(
        child: Icon(
          Icons.support_agent_rounded,
          size: 100.sp,
          color: CustomerAppColors.primary.withValues(
            alpha: isDark ? 0.7 : 0.5,
          ),
        ),
      ),
    );
  }
}
