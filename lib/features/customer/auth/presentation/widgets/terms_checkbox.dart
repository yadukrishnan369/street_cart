import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';

// Terms Check box
class TermsCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const TermsCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24.w,
          height: 24.w,
          child: Checkbox(
            value: value,
            activeColor: CustomerAppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.r),
            ),
            side: BorderSide(
              color: isDark
                  ? CustomerAppColors.darkBorder
                  : CustomerAppColors.border,
            ),
            onChanged: onChanged,
          ),
        ),
        12.horizontalSpace,
        Expanded(
          child: RichText(
            text: TextSpan(
              style: CustomerAppTextStyles.body.copyWith(
                color: isDark
                    ? CustomerAppColors.darkTextSecondary
                    : CustomerAppColors.textSecondary,
                fontSize: 13.sp,
                height: 1.5,
              ),
              children: [
                const TextSpan(text: "I agree to the "),
                TextSpan(
                  text: "Terms and Conditions",
                  style: TextStyle(
                    color: CustomerAppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const TextSpan(text: " and "),
                TextSpan(
                  text: "Privacy Policy",
                  style: TextStyle(
                    color: CustomerAppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const TextSpan(text: "."),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
