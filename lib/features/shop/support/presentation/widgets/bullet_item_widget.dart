import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';

// Privacy Policy Bullet Item Widget
class BulletItemWidget extends StatelessWidget {
  final String text;

  const BulletItemWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(left: 12.w, bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 6.h),
            width: 5.r,
            height: 5.r,
            decoration: BoxDecoration(
              color: isDark
                  ? ShopAppColors.darkTextSecondary
                  : ShopAppColors.textSecondary,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              text,
              style: ShopAppTextStyles.bodyMedium.copyWith(
                color: isDark
                    ? ShopAppColors.darkTextSecondary
                    : ShopAppColors.textSecondary,
                fontSize: 13.sp,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
