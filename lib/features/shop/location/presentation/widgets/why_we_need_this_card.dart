import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';

// Why We Need This Card - Info about the importance of Location Permission
class WhyWeNeedThisCard extends StatelessWidget {
  const WhyWeNeedThisCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: ShopAppColors.background,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: ShopAppColors.border.withAlpha(128)),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: ShopAppColors.primary.withAlpha(26),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.verified_user_outlined,
              color: ShopAppColors.primary,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Title
                Text(
                  'Why we need this',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                    color: ShopAppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                // Subtitle
                Text(
                  'We only use your location to calculate distance for delivery and to list your shop in local search results. Your privacy is our top priority.',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: ShopAppColors.textSecondary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
