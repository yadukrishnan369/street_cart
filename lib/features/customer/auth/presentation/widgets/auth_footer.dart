import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';

// Auth Footer
class AuthFooter extends StatelessWidget {
  final String text1;
  final String text2;
  final VoidCallback onTap;

  const AuthFooter({
    super.key,
    required this.text1,
    required this.text2,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(8.w),
          child: RichText(
            text: TextSpan(
              text: text1,
              style: CustomerAppTextStyles.body.copyWith(
                color: isDark
                    ? CustomerAppColors.darkTextSecondary
                    : CustomerAppColors.textSecondary,
              ),
              children: [
                TextSpan(
                  text: text2,
                  style: CustomerAppTextStyles.body.copyWith(
                    color: CustomerAppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
