import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';

class AppearanceCard extends StatelessWidget {
  const AppearanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE8E7ED), width: 1.5),
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
                Text(
                  'Appearance Settings',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E1E2F),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF0EFF5)),
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
                          color: const Color(0xFF1E1E2F),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Choose how you want the dashboard to look.',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFF8A8A9E),
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
                        child: Container(
                          height: 70.h,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AdminAppColors.primaryColor,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(10.r),
                            color: Colors.white,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.wb_sunny_outlined,
                                color: AdminAppColors.primaryColor,
                                size: 20.sp,
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'Light Mode',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AdminAppColors.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      // Dark Mode button
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            CustomSnackBar.show(
                              context,
                              message: 'Dark Mode is coming soon!',
                            );
                          },
                          child: Container(
                            height: 70.h,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFFE8E7ED),
                              ),
                              borderRadius: BorderRadius.circular(10.r),
                              color: const Color(0xFFF9FAFC),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.nightlight_outlined,
                                  color: const Color(0xFF8A8A9E),
                                  size: 20.sp,
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  'Dark Mode',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF8A8A9E),
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
