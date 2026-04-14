import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';
import 'package:street_cart/shared/widgets/app_logo.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool showLogo;
  final bool centerText;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.showLogo = true,
    this.centerText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: centerText ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        if (showLogo) ...[
          Center(child: AppLogo(isDark: false, size: 70.w)),
          24.verticalSpace,
        ],
        Text(
          title,
          style: CustomerAppTextStyles.heading2,
          textAlign: centerText ? TextAlign.center : TextAlign.start,
        ),
        8.verticalSpace,
        Text(
          subtitle,
          style: CustomerAppTextStyles.body.copyWith(
            color: CustomerAppColors.textSecondary,
            fontSize: 14.sp,
          ),
          textAlign: centerText ? TextAlign.center : TextAlign.start,
        ),
      ],
    );
  }
}
