import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/features/admin/settings/data/models/admin_settings_model.dart';

class CategoryItemWidget extends StatelessWidget {
  final CategoryModel category;
  final Function(bool) onToggleVisibility;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CategoryItemWidget({
    super.key,
    required this.category,
    required this.onToggleVisibility,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE8E7ED), width: 1.5),
      ),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  category.name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1E1E2F),
                  ),
                ),
              ),
              Text(
                category.isVisible ? 'VISIBLE' : 'HIDDEN',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                  color: category.isVisible
                      ? AdminAppColors.primaryColor
                      : const Color(0xFF8A8A9E),
                ),
              ),
              SizedBox(width: 8.w),
              Transform.scale(
                scale: 0.8,
                child: Switch(
                  value: category.isVisible,
                  activeThumbColor: AdminAppColors.primaryColor,
                  onChanged: onToggleVisibility,
                ),
              ),
              SizedBox(width: 16.w),
              IconButton(
                onPressed: onEdit,
                icon: Icon(
                  Icons.edit_outlined,
                  size: 20.sp,
                  color: const Color(0xFF8A8A9E),
                ),
              ),
              IconButton(
                onPressed: onDelete,
                icon: Icon(
                  Icons.delete_outline,
                  size: 20.sp,
                  color: AdminAppColors.errorColor,
                ),
              ),
            ],
          ),
          if (category.productCategories.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Text(
              'Product Categories:',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 4.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 4.h,
              children: category.productCategories
                  .map(
                    (c) => Chip(
                      label: Text(
                        c,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.black87,
                        ),
                      ),
                      backgroundColor: Colors.grey[100],
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  )
                  .toList(),
            ),
          ],
          if (category.sizeGroups.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Text(
              'Size Groups:',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 4.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 4.h,
              children: category.sizeGroups
                  .map(
                    (g) => Chip(
                      label: Text(
                        g,
                        style: TextStyle(fontSize: 12.sp, color: Colors.white),
                      ),
                      backgroundColor: AdminAppColors.primaryColor,
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}
