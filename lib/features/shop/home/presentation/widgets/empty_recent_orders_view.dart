import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';

class EmptyRecentOrdersView extends StatelessWidget {
  const EmptyRecentOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 36.h, horizontal: 24.w),
      decoration: BoxDecoration(
        color: ShopAppColors.surface,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: ShopAppColors.border, width: 1.w),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: ShopAppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_bag_outlined,
              color: ShopAppColors.primary,
              size: 32.sp,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'No New Orders Yet',
            style: ShopAppTextStyles.bodyMediumBold.copyWith(
              color: ShopAppColors.textPrimary,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'When customers place orders, they will show up here.',
            textAlign: TextAlign.center,
            style: ShopAppTextStyles.caption.copyWith(
              color: ShopAppColors.textSecondary,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}
