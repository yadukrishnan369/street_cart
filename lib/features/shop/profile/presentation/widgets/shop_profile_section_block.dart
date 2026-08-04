import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';

// Shop Profile Section Block
class ShopProfileSectionBlock extends StatelessWidget {
  final String title;
  final Widget child;

  const ShopProfileSectionBlock({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? ShopAppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        border: isDark
            ? Border.all(
                color: ShopAppColors.darkBorder.withValues(alpha: 0.8),
                width: 0.8,
              )
            : null,
      ),
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            title,
            style: ShopAppTextStyles.bodySmall.copyWith(
              color: isDark
                  ? ShopAppColors.darkTextSecondary
                  : ShopAppColors.textSecondary,
              fontWeight: FontWeight.bold,
              fontSize: 12.sp,
              letterSpacing: 0.5.sp,
            ),
          ),
          SizedBox(height: 12.h),
          child,
        ],
      ),
    );
  }
}

// Shop Profile Grid Item
class ShopProfileGridItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const ShopProfileGridItem({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          label,
          style: ShopAppTextStyles.bodySmall.copyWith(
            color: isDark
                ? ShopAppColors.darkTextSecondary
                : ShopAppColors.textTertiary,
            fontSize: 11.sp,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: ShopAppTextStyles.bodyMediumBold.copyWith(
            color:
                valueColor ??
                (isDark
                    ? ShopAppColors.darkTextPrimary
                    : ShopAppColors.textPrimary),
            fontSize: 13.sp,
          ),
        ),
      ],
    );
  }
}
