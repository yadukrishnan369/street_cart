import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';

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
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFECEFF1), width: 0.8),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: ShopAppTextStyles.bodyMediumBold.copyWith(
            color: ShopAppColors.textPrimary,
            fontSize: 14.sp,
          ),
        ),
        shape: const RoundedRectangleBorder(side: BorderSide.none),
        collapsedShape: const RoundedRectangleBorder(side: BorderSide.none),
        iconColor: ShopAppColors.primary,
        collapsedIconColor: ShopAppColors.textTertiary,
        childrenPadding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
        expandedAlignment: Alignment.topLeft,
        children: [
          Text(
            answer,
            style: ShopAppTextStyles.bodyMedium.copyWith(
              color: ShopAppColors.textSecondary,
              fontSize: 13.sp,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
