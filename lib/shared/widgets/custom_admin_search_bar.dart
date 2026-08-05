import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';

class CustomAdminSearchBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final double? width;

  const CustomAdminSearchBar({
    super.key,
    required this.hintText,
    this.onChanged,
    this.controller,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: width ?? 320.w,
      height: 44.h,
      decoration: BoxDecoration(
        color: isDark
            ? AdminAppColors.darkInputBackground
            : const Color(0xFFF9FAFC),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: isDark ? AdminAppColors.darkBorder : const Color(0xFFE8E7ED),
          width: 1.2,
        ),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: TextStyle(
          fontSize: 13.sp,
          color: isDark
              ? AdminAppColors.darkTextPrimary
              : AdminAppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 13.sp,
            color: isDark
                ? AdminAppColors.darkTextSecondary
                : const Color(0xFF8A8A9E),
          ),
          prefixIcon: Icon(
            Icons.search,
            color: isDark
                ? AdminAppColors.darkTextSecondary
                : const Color(0xFF8A8A9E),
            size: 20.sp,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 10.h),
        ),
      ),
    );
  }
}
