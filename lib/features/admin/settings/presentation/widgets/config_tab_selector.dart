import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';

class ConfigTabSelector extends StatelessWidget {
  final bool isColorsTab;
  final ValueChanged<bool> onTabChanged;

  const ConfigTabSelector({
    super.key,
    required this.isColorsTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _pill(
          label: 'Colors',
          isActive: isColorsTab,
          onTap: () => onTabChanged(true),
        ),
        SizedBox(width: 12.w),
        _pill(
          label: 'Size Groups',
          isActive: !isColorsTab,
          onTap: () => onTabChanged(false),
        ),
      ],
    );
  }

  Widget _pill({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
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
}
