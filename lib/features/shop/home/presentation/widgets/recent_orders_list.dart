import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';

class RecentOrdersList extends StatelessWidget {
  const RecentOrdersList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('New Orders', style: ShopAppTextStyles.bodyLargeBold),
            GestureDetector(
              onTap: () {},
              child: Text(
                'View All',
                style: ShopAppTextStyles.bodyMediumBold.copyWith(
                  color: ShopAppColors.primary,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        _buildOrderItem(
          'Rahul Sharma',
          'Oversized Cotton Tee',
          '₹899',
          'GPAY',
          'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400&fit=crop',
          ShopAppColors.success,
        ),
        _buildOrderItem(
          'Anita Gupta',
          'Slim Fit Linen Shirt',
          '₹2,499',
          'COD',
          'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400&fit=crop',
          Colors.blueAccent,
        ),
        _buildOrderItem(
          'Suresh V.',
          'Classic Denim Jacket',
          '₹1,750',
          'GPAY',
          'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400&fit=crop',
          ShopAppColors.success,
        ),
      ],
    );
  }

  Widget _buildOrderItem(
    String name,
    String product,
    String price,
    String method,
    String imageUrl,
    Color methodColor,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: ShopAppColors.surface,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: ShopAppColors.border, width: 1.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 54.r,
            width: 54.r,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: ShopAppTextStyles.bodyMediumBold.copyWith(
                    color: ShopAppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  product,
                  style: ShopAppTextStyles.bodySmall.copyWith(
                    color: ShopAppColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: ShopAppTextStyles.bodyMediumBold.copyWith(
                  color: ShopAppColors.textPrimary,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                method,
                style: ShopAppTextStyles.caption.copyWith(
                  color: methodColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 8.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
