import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/core/theme/admin/admin_theme_cubit.dart';

// Appearance Card
class AppearanceCard extends StatelessWidget {
  const AppearanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeCubit = context.read<AdminThemeCubit>();

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AdminAppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? AdminAppColors.darkBorder : const Color(0xFFE8E7ED),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(24.w),
            child: Row(
              children: [
                Icon(
                  Icons.palette_outlined,
                  color: AdminAppColors.primaryColor,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                // Title
                Text(
                  'Appearance Settings',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AdminAppColors.darkTextPrimary
                        : AdminAppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: isDark ? AdminAppColors.darkBorder : const Color(0xFFF0EFF5),
          ),
          Padding(
            padding: EdgeInsets.all(24.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Theme Preference',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AdminAppColors.darkTextPrimary
                              : AdminAppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Choose how you want the dashboard to look.',
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
                SizedBox(width: 24.w),
                Expanded(
                  flex: 5,
                  child: Row(
                    children: [
                      // Light Mode button
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            if (isDark) {
                              themeCubit.toggleTheme(false);
                            }
                          },
                          borderRadius: BorderRadius.circular(10.r),
                          child: Container(
                            height: 70.h,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: !isDark
                                    ? AdminAppColors.primaryColor
                                    : (isDark
                                          ? AdminAppColors.borderLight
                                          : const Color(0xFFE8E7ED)),
                                width: !isDark ? 2.0 : 1.0,
                              ),
                              borderRadius: BorderRadius.circular(10.r),
                              color: !isDark
                                  ? (isDark
                                        ? AdminAppColors.darkSurface
                                        : Colors.white)
                                  : (isDark
                                        ? AdminAppColors.darkInputBackground
                                        : AdminAppColors.backgroundLight),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.wb_sunny_outlined,
                                  color: !isDark
                                      ? AdminAppColors.primaryColor
                                      : (isDark
                                            ? AdminAppColors.darkTextSecondary
                                            : const Color(0xFF8A8A9E)),
                                  size: 20.sp,
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  'Light Mode',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                    color: !isDark
                                        ? AdminAppColors.primaryColor
                                        : (isDark
                                              ? AdminAppColors.darkTextSecondary
                                              : const Color(0xFF8A8A9E)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      // Dark Mode button
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            if (!isDark) {
                              themeCubit.toggleTheme(true);
                            }
                          },
                          borderRadius: BorderRadius.circular(10.r),
                          child: Container(
                            height: 70.h,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isDark
                                    ? AdminAppColors.primaryColor
                                    : AdminAppColors.darkBorder,
                                width: isDark ? 2.0 : 1.0,
                              ),
                              borderRadius: BorderRadius.circular(10.r),
                              color: isDark
                                  ? AdminAppColors.darkSurface
                                  : AdminAppColors.backgroundLight,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.nightlight_outlined,
                                  color: isDark
                                      ? AdminAppColors.primaryColor
                                      : const Color(0xFF8A8A9E),
                                  size: 20.sp,
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  'Dark Mode',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? AdminAppColors.primaryColor
                                        : const Color(0xFF8A8A9E),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
