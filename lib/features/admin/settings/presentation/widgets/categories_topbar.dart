import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';

class CategoriesTopbar extends StatelessWidget {
  const CategoriesTopbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFF0EFF5), width: 1.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.settings_outlined,
                size: 20.sp,
                color: AdminAppColors.primaryColor,
              ),
              SizedBox(width: 8.w),
              Text(
                'Categories',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1E1E2F),
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF4EBFF),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: InkWell(
              onTap: () {
                CustomSnackBar.show(context, message: 'No new notifications');
              },
              child: Icon(
                Icons.notifications_none,
                color: AdminAppColors.primaryColor,
                size: 20.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
