import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';

// Privacy Call out Box
class PrivacyCalloutBox extends StatelessWidget {
  final String text;

  const PrivacyCalloutBox({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark
            ? CustomerAppColors.primary.withValues(alpha: 0.12)
            : const Color(0xFFF3F5FF),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark
              ? CustomerAppColors.darkBorder
              : CustomerAppColors.primary.withValues(alpha: 0.1),
        ),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: CustomerAppTextStyles.body.copyWith(
          color: isDark
              ? CustomerAppColors.darkTextSecondary
              : const Color(0xFF475569),
          fontStyle: FontStyle.italic,
          height: 1.5,
        ),
      ),
    );
  }
}
