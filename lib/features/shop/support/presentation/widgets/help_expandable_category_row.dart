import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/support/presentation/widgets/faq_expansion_tile.dart';

// Help Expandable Category Row
class HelpExpandableCategoryRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Map<String, String>> items;

  const HelpExpandableCategoryRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: isDark ? ShopAppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? ShopAppColors.darkBorder : const Color(0xFFECEFF1),
          width: 0.8,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          leading: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: isDark
                  ? ShopAppColors.primary.withValues(alpha: 0.15)
                  : const Color(0xFFE8F5E9),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: ShopAppColors.primary, size: 22.sp),
          ),
          // Title
          title: Text(
            title,
            style: ShopAppTextStyles.bodyMediumBold.copyWith(
              color: isDark
                  ? ShopAppColors.darkTextPrimary
                  : ShopAppColors.textPrimary,
              fontSize: 14.sp,
            ),
          ),
          // Subtitle
          subtitle: Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: Text(
              subtitle,
              style: ShopAppTextStyles.bodySmall.copyWith(
                color: isDark
                    ? ShopAppColors.darkTextSecondary
                    : ShopAppColors.textSecondary,
                fontSize: 12.sp,
              ),
            ),
          ),
          iconColor: ShopAppColors.primary,
          collapsedIconColor: isDark
              ? ShopAppColors.darkTextSecondary
              : ShopAppColors.textSecondary,
          childrenPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 8.h,
          ),
          children: items.map((item) {
            // Expansion Tile
            return FAQExpansionTile(
              question: item['question']!,
              answer: item['answer']!,
            );
          }).toList(),
        ),
      ),
    );
  }
}
