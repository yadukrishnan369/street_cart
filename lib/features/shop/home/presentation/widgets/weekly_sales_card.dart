import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';

class WeeklySalesCard extends StatelessWidget {
  const WeeklySalesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: ShopAppColors.primaryLight,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: ShopAppColors.primary.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Weekly Sales',
                style: ShopAppTextStyles.bodySmallBold.copyWith(
                  color: ShopAppColors.textSecondary,
                  letterSpacing: 0.5.sp,
                ),
              ),
              Text(
                'LAST 7 DAYS',
                style: ShopAppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w800,
                  color: ShopAppColors.textTertiary,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹85,200',
                style: ShopAppTextStyles.heading2.copyWith(
                  color: ShopAppColors.primary,
                  fontSize: 22.sp,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    Text(
                      'VIEW',
                      style: ShopAppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w900,
                        color: ShopAppColors.primary,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 16.sp,
                      color: ShopAppColors.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
