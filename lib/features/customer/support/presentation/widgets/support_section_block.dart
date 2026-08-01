import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';

// Support Section Block
class SupportSectionBlock extends StatelessWidget {
  final String title;
  final String content;

  const SupportSectionBlock({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // section heading
        Text(
          title,
          style: CustomerAppTextStyles.heading2.copyWith(
            fontSize: 18.sp,
            color: CustomerAppColors.primary,
          ),
        ),
        SizedBox(height: 12.h),
        // section body paragraph text
        Text(
          content,
          style: CustomerAppTextStyles.body.copyWith(
            height: 1.6,
            fontSize: 14.sp,
            color: isDark
                ? CustomerAppColors.darkTextSecondary
                : const Color(0xFF475569),
          ),
        ),
      ],
    );
  }
}
