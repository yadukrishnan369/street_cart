import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';

class CategoryHeaderSection extends StatelessWidget {
  final bool isProductTab;
  final VoidCallback onAddPressed;

  const CategoryHeaderSection({
    super.key,
    required this.isProductTab,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Category Catalog',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E1E2F),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Manage your ${isProductTab ? "product" : "business"} Categories and visibility.',
              style: TextStyle(fontSize: 13.sp, color: const Color(0xFF8A8A9E)),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: onAddPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AdminAppColors.primaryColor,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            elevation: 0,
          ),
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Add New Category'),
        ),
      ],
    );
  }
}
