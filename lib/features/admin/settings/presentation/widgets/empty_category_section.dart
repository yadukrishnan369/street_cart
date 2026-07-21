import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';

// Empty Category
class EmptyCategory extends StatelessWidget {
  const EmptyCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 60.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.category_outlined,
              size: 64.sp,
              color: const Color(0xFFB0B0C3),
            ),
            SizedBox(height: 16.h),
            // Title
            Text(
              'No Categories Yet',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF4A4A68),
              ),
            ),
            SizedBox(height: 8.h),
            // Subtitle
            Text(
              'Create your first streetcart category to get started.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: AdminAppColors.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
