import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/core/animation/text_animation.dart';

// Empty Recent Orders State
class EmptyRecentOrdersView extends StatelessWidget {
  const EmptyRecentOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 36.h, horizontal: 24.w),
      decoration: BoxDecoration(
        color: isDark ? ShopAppColors.darkSurface : ShopAppColors.surface,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: isDark ? ShopAppColors.darkBorder : ShopAppColors.border,
          width: 1.w,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: isDark
                  ? ShopAppColors.primary.withValues(alpha: 0.2)
                  : ShopAppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_bag_outlined,
              color: ShopAppColors.primary,
              size: 32.sp,
            ),
          ),
          SizedBox(height: 16.h),
          // Title
          AppTextAnimation.fade(
            'No New Orders Yet',
            style: ShopAppTextStyles.bodyMediumBold.copyWith(
              color: isDark
                  ? ShopAppColors.darkTextPrimary
                  : ShopAppColors.textPrimary,
              fontSize: 16.sp,
            ),
            duration: const Duration(milliseconds: 1000),
          ),
          SizedBox(height: 6.h),
          // Subtitle
          AppTextAnimation.fade(
            'When customers place orders, they will show up here.',
            textAlign: TextAlign.center,
            style: ShopAppTextStyles.caption.copyWith(
              color: isDark
                  ? ShopAppColors.darkTextSecondary
                  : ShopAppColors.textSecondary,
              fontSize: 12.sp,
            ),
            duration: const Duration(milliseconds: 1200),
          ),
        ],
      ),
    );
  }
}
