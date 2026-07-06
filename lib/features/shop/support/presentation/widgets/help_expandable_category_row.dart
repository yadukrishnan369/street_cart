import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/support/presentation/widgets/faq_expansion_tile.dart';

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
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFECEFF1), width: 0.8),
      ),
      child: Theme(
        data: ThemeData(
          dividerColor: Colors.transparent,
          colorScheme: const ColorScheme.light(primary: ShopAppColors.primary),
        ),
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          leading: Container(
            padding: EdgeInsets.all(8.w),
            decoration: const BoxDecoration(
              color: Color(0xFFE8F5E9),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: ShopAppColors.primary, size: 22.sp),
          ),
          title: Text(
            title,
            style: ShopAppTextStyles.bodyMediumBold.copyWith(
              color: ShopAppColors.textPrimary,
              fontSize: 14.sp,
            ),
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: Text(
              subtitle,
              style: ShopAppTextStyles.bodySmall.copyWith(
                color: ShopAppColors.textSecondary,
                fontSize: 12.sp,
              ),
            ),
          ),
          iconColor: ShopAppColors.primary,
          collapsedIconColor: ShopAppColors.textSecondary,
          childrenPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 8.h,
          ),
          children: items.map((item) {
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
