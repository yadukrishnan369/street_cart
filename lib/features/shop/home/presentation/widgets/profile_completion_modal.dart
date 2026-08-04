import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';

// Profile Completion Modal
class ProfileCompletionModal extends StatelessWidget {
  final VoidCallback onCompleteNow;
  final VoidCallback onMaybeLater;

  const ProfileCompletionModal({
    super.key,
    required this.onCompleteNow,
    required this.onMaybeLater,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        padding: EdgeInsets.all(32.w),
        decoration: BoxDecoration(
          color: isDark ? ShopAppColors.darkSurface : ShopAppColors.surface,
          borderRadius: BorderRadius.circular(32.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: ShopAppColors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              // Icon
              child: Icon(
                Icons.storefront_outlined,
                size: 48.sp,
                color: ShopAppColors.primary,
              ),
            ),
            SizedBox(height: 24.h),
            // Title
            Text(
              'Complete Your Profile',
              style: ShopAppTextStyles.heading3.copyWith(
                color: isDark
                    ? ShopAppColors.darkTextPrimary
                    : ShopAppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            // Subtitle
            Text(
              'Your shop is almost ready! Finish setting up your business profile to start receiving orders.',
              style: ShopAppTextStyles.bodyMedium.copyWith(
                color: isDark
                    ? ShopAppColors.darkTextSecondary
                    : ShopAppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            // Button for Complete Profile
            PrimaryButton(
              text: 'Complete Setup Now',
              backgroundColor: ShopAppColors.primary,
              textStyle: ShopAppTextStyles.buttonText,
              onPressed: onCompleteNow,
            ),
            SizedBox(height: 12.h),
            TextButton(
              onPressed: onMaybeLater,
              child: Text(
                'Maybe Later',
                style: ShopAppTextStyles.bodyMediumBold.copyWith(
                  color: isDark
                      ? ShopAppColors.darkTextSecondary
                      : ShopAppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
