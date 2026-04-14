import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';
import 'package:street_cart/shared/widgets/social_button.dart';

class SocialLoginSection extends StatelessWidget {
  final VoidCallback onGoogleLogin;

  const SocialLoginSection({super.key, required this.onGoogleLogin});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SocialButton(
          text: "Continue with Google",
          onPressed: onGoogleLogin,
        ),
        24.verticalSpace,
        Row(
          children: [
            Expanded(
              child: Divider(color: CustomerAppColors.border),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                "or login with email",
                style: CustomerAppTextStyles.body.copyWith(
                  color: CustomerAppColors.textSecondary,
                  fontSize: 12.sp,
                ),
              ),
            ),
            Expanded(
              child: Divider(color: CustomerAppColors.border),
            ),
          ],
        ),
      ],
    );
  }
}
