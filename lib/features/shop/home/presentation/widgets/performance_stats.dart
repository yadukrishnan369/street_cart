import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';

class PerformanceStats extends StatelessWidget {
  const PerformanceStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Performance Today', style: ShopAppTextStyles.bodyLargeBold),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: ShopAppColors.successBg,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                'Live Updates',
                style: ShopAppTextStyles.caption.copyWith(
                  color: ShopAppColors.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 10.sp,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),
        Row(
          children: [
            Expanded(child: _buildStatCard('ORDERS', '24')),
            SizedBox(width: 16.w),
            Expanded(child: _buildStatCard('REVENUE', '₹12,450')),
          ],
        ),
        SizedBox(height: 20.h),
        _buildPendingCard('PENDING DELIVERIES', '08'),
      ],
    );
  }

  Widget _buildStatCard(String label, String value) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: ShopAppTextStyles.caption.copyWith(
              color: ShopAppColors.textSecondary,
              letterSpacing: 0.5.sp,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            value,
            style: ShopAppTextStyles.heading2.copyWith(
              fontSize: 22.sp,
              color: ShopAppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingCard(String label, String value) {
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: ShopAppTextStyles.caption.copyWith(
                  color: ShopAppColors.textSecondary,
                  letterSpacing: 0.5.sp,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                value,
                style: ShopAppTextStyles.heading2.copyWith(
                  fontSize: 22.sp,
                  color: ShopAppColors.textPrimary,
                ),
              ),
            ],
          ),
          Icon(
            Icons.local_shipping_outlined,
            size: 28.sp,
            color: ShopAppColors.primary.withOpacity(0.4),
          ),
        ],
      ),
    );
  }
}
