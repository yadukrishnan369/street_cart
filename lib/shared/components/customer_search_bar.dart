import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';

class CustomSearchBar extends StatelessWidget {
  final String hintText;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final VoidCallback? onFilterTap;
  final bool autofocus;
  final bool showFilter;

  const CustomSearchBar({
    super.key,
    required this.hintText,
    this.onTap,
    this.controller,
    this.onChanged,
    this.onFilterTap,
    this.autofocus = false,
    this.showFilter = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(30.r),
        border: isDark ? Border.all(color: CustomerAppColors.darkBorder) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: isDark ? CustomerAppColors.darkTextSecondary : Colors.grey,
            size: 24.sp,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              onTap: onTap,
              autofocus: autofocus,
              style: TextStyle(
                color: isDark
                    ? CustomerAppColors.darkTextPrimary
                    : CustomerAppColors.textPrimary,
                fontSize: 14.sp,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: isDark
                      ? CustomerAppColors.darkTextSecondary
                      : Colors.grey,
                  fontSize: 14.sp,
                  overflow: TextOverflow.ellipsis,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          if (showFilter)
            GestureDetector(
              onTap: onFilterTap,
              child: Icon(Icons.tune, color: Colors.grey, size: 24.sp),
            ), // Filter icon
        ],
      ),
    );
  }
}
