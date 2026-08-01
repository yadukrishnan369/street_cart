import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';

class SocialButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const SocialButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: isDark
              ? CustomerAppColors.darkSurface
              : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          side: BorderSide(
            color: isDark
                ? CustomerAppColors.darkBorder
                : CustomerAppColors.border,
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Google Logo
            SvgPicture.asset(
              'assets/icons/google.svg',
              width: 26.w,
              height: 26.w,
            ),
            8.horizontalSpace,
            Text(
              text,
              style: CustomerAppTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark
                    ? CustomerAppColors.darkTextPrimary
                    : CustomerAppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
