import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/core/animation/text_animation.dart';

// Home Quick Actions
class QuickActions extends StatelessWidget {
  final VoidCallback? onAddProductTap;
  final VoidCallback? onEditProfileTap;
  final VoidCallback? onViewOrdersTap;

  const QuickActions({
    super.key,
    this.onAddProductTap,
    this.onEditProfileTap,
    this.onViewOrdersTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextAnimation.fade(
          'Quick Actions',
          style: ShopAppTextStyles.bodyLargeBold.copyWith(
            color: isDark
                ? ShopAppColors.darkTextPrimary
                : ShopAppColors.textPrimary,
          ),
          duration: const Duration(milliseconds: 1000),
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Add Product
            _buildActionCard(
              'Add Product',
              Icons.inventory_2_outlined,
              true,
              isDark: isDark,
              onTap: onAddProductTap,
            ),
            // View Order
            _buildActionCard(
              'View Orders',
              Icons.widgets_outlined,
              false,
              isDark: isDark,
              onTap: onViewOrdersTap,
            ),
            // Edit Profile
            _buildActionCard(
              'Edit Profile',
              Icons.edit_square,
              false,
              isDark: isDark,
              onTap: onEditProfileTap,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    String title,
    IconData icon,
    bool isPrimary, {
    required bool isDark,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90.w,
        padding: EdgeInsets.symmetric(vertical: 18.h),
        decoration: BoxDecoration(
          color: isPrimary
              ? ShopAppColors.primary
              : (isDark ? ShopAppColors.darkSurface : ShopAppColors.surface),
          borderRadius: BorderRadius.circular(28.r),
          border: Border.all(
            color: isPrimary
                ? ShopAppColors.primary
                : (isDark ? ShopAppColors.darkBorder : ShopAppColors.border),
            width: 1.5.w,
          ),
          boxShadow: [
            if (isPrimary)
              BoxShadow(
                color: ShopAppColors.primary.withValues(alpha: 0.25),
                blurRadius: 15,
                offset: const Offset(0, 8),
              )
            else
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 26.sp,
              color: isPrimary ? Colors.white : ShopAppColors.primary,
            ),
            SizedBox(height: 10.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: ShopAppTextStyles.bodySmallBold.copyWith(
                color: isPrimary
                    ? Colors.white
                    : (isDark
                          ? ShopAppColors.darkTextSecondary
                          : ShopAppColors.textSecondary),
                fontSize: 10.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
