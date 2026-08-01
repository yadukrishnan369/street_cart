import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';

// Support Category Section
class SupportCategorySection extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> items;
  final IconData icon;

  const SupportCategorySection({
    super.key,
    required this.title,
    required this.items,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: CustomerAppColors.primary, size: 20.sp),
            SizedBox(width: 8.w),
            Text(
              title,
              style: CustomerAppTextStyles.body.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
                color: CustomerAppColors.primary,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        ...items.map(
          (item) => Container(
            margin: EdgeInsets.only(bottom: 8.h),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16.r),
              border: isDark
                  ? Border.all(color: CustomerAppColors.darkBorder)
                  : null,
            ),
            child: Theme(
              data: Theme.of(
                context,
              ).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                title: Text(
                  item['title'],
                  style: CustomerAppTextStyles.body.copyWith(
                    color: isDark
                        ? CustomerAppColors.darkTextPrimary
                        : CustomerAppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                iconColor: CustomerAppColors.primary,
                collapsedIconColor: isDark
                    ? CustomerAppColors.darkTextSecondary
                    : Colors.grey.shade400,
                childrenPadding: EdgeInsets.only(
                  left: 16.w,
                  right: 16.w,
                  bottom: 16.h,
                ),
                children: [
                  Text(
                    item['content'],
                    style: CustomerAppTextStyles.body.copyWith(
                      color: isDark
                          ? CustomerAppColors.darkTextSecondary
                          : Colors.grey.shade600,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}
