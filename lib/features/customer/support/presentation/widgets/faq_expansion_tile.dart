import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';

// FAQ Expansion Tile
class FAQExpansionTile extends StatelessWidget {
  final String question;
  final String answer;

  const FAQExpansionTile({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? CustomerAppColors.darkBorder : Colors.grey.shade100,
        ),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: CustomerAppTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
            color: isDark
                ? CustomerAppColors.darkTextPrimary
                : CustomerAppColors.textPrimary,
          ),
        ),
        shape: const RoundedRectangleBorder(side: BorderSide.none),
        collapsedShape: const RoundedRectangleBorder(side: BorderSide.none),
        iconColor: CustomerAppColors.primary,
        collapsedIconColor: isDark
            ? CustomerAppColors.darkTextSecondary
            : Colors.grey.shade400,
        childrenPadding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 20.h),
        expandedAlignment: Alignment.topLeft,
        children: [
          Text(
            answer,
            style: CustomerAppTextStyles.body.copyWith(
              color: isDark
                  ? CustomerAppColors.darkTextSecondary
                  : CustomerAppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
