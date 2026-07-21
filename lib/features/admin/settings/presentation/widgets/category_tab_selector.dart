import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';

// Category Tab Selector
class CategoryTabSelector extends StatelessWidget {
  final bool isProductTab;
  final Function(bool) onTabChanged;

  const CategoryTabSelector({
    super.key,
    required this.isProductTab,
    required this.onTabChanged,
  });

  Widget _buildTabButton({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isActive ? AdminAppColors.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isActive
                ? AdminAppColors.primaryColor
                : const Color(0xFFE8E7ED),
            width: 1.5,
          ),
        ),
        // Label
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
            color: isActive ? Colors.white : const Color(0xFF8A8A9E),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildTabButton(
          label: 'Product Categories',
          isActive: isProductTab,
          onTap: () => onTabChanged(true),
        ),
        SizedBox(width: 12.w),
        _buildTabButton(
          label: 'Business Categories',
          isActive: !isProductTab,
          onTap: () => onTabChanged(false),
        ),
      ],
    );
  }
}
