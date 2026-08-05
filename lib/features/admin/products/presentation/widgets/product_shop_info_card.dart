import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:street_cart/core/router/admin/route_paths.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';

// Product Shop Info Card
class ProductShopInfoCard extends StatelessWidget {
  final String shopId;
  final String shopName;
  final String shopLocation;

  const ProductShopInfoCard({
    super.key,
    required this.shopId,
    required this.shopName,
    required this.shopLocation,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AdminAppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? AdminAppColors.darkBorder : const Color(0xFFE8E7ED),
          width: 1.5,
        ),
      ),
      padding: EdgeInsets.all(28.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Posted by Shop',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w900,
              color: isDark
                  ? AdminAppColors.darkTextPrimary
                  : AdminAppColors.textPrimary,
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              Container(
                width: 48.r,
                height: 48.r,
                decoration: BoxDecoration(
                  color: isDark
                      ? AdminAppColors.primaryColor.withValues(alpha: 0.15)
                      : const Color(0xFFF3E8FF),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.storefront,
                  color: AdminAppColors.primaryColor,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Shop Name
                    Text(
                      shopName,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w800,
                        color: isDark
                            ? AdminAppColors.darkTextPrimary
                            : AdminAppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    // Shop Location
                    Text(
                      shopLocation,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: isDark
                            ? AdminAppColors.darkTextSecondary
                            : const Color(0xFF8A8A9E),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          SizedBox(
            width: double.infinity,
            // Button for View Shop Profile
            child: ElevatedButton(
              onPressed: () {
                context.push(RoutePaths.shopDetails.replaceAll(':id', shopId));
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: isDark
                    ? AdminAppColors.primaryColor.withValues(alpha: 0.15)
                    : const Color(0xFFF3E8FF),
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  side: BorderSide(
                    color: AdminAppColors.primaryColor,
                    width: 1,
                  ),
                ),
              ),
              child: Text(
                'View Shop Profile',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: AdminAppColors.primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
