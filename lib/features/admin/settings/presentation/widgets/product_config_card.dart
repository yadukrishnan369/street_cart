import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/core/router/admin/route_paths.dart';

// Product Config Card
class ProductConfigCard extends StatelessWidget {
  const ProductConfigCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE8E7ED), width: 1.5),
      ),
      padding: EdgeInsets.all(24.w),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF3E5F5),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.tune_rounded,
              color: AdminAppColors.primaryColor,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 20.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  'Product Configuration',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E1E2F),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Manage colors and size groups for products.',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF8A8A9E),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.push(RoutePaths.productConfig);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AdminAppColors.primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              elevation: 0,
            ),
            child: Row(
              children: [
                const Text('Manage Config'),
                SizedBox(width: 4.w),
                const Icon(Icons.chevron_right, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
