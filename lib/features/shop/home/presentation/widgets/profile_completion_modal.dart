import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';

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
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        padding: EdgeInsets.all(32.w),
        decoration: BoxDecoration(
          color: ShopAppColors.surface,
          borderRadius: BorderRadius.circular(32.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
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
                color: ShopAppColors.primary.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.storefront_outlined,
                size: 48.sp,
                color: ShopAppColors.primary,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'Complete Your Profile',
              style: ShopAppTextStyles.heading3,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            Text(
              'Your shop is almost ready! Finish setting up your business profile to start receiving orders.',
              style: ShopAppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
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
                  color: ShopAppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
