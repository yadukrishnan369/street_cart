import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';

// Product Info Section
class ProductInfoSection extends StatelessWidget {
  final String productName;
  final String shopName;
  final double rating;

  const ProductInfoSection({
    super.key,
    required this.productName,
    required this.shopName,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              // Product Name
              child: Text(
                productName,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? CustomerAppColors.darkTextPrimary
                      : CustomerAppColors.textPrimary,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            // Product Rating
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: isDark
                    ? CustomerAppColors.primary.withValues(alpha: 0.2)
                    : const Color(0xFFF3E8FF),
                borderRadius: BorderRadius.circular(12.r),
              ),
              // Product Overall Rating
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.star_rounded,
                    color: CustomerAppColors.warning,
                    size: 14.sp,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    rating > 0.0 ? rating.toStringAsFixed(1) : '0.0',
                    style: TextStyle(
                      color: isDark
                          ? CustomerAppColors.darkTextPrimary
                          : CustomerAppColors.textPrimary,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        // Shop Name
        Text(
          shopName,
          style: TextStyle(
            fontSize: 14.sp,
            color: CustomerAppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
