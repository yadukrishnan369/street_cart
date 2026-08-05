import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';

// Gst Card
class GstCard extends StatelessWidget {
  final ShopProfileModel shop;

  const GstCard({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
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
          // Title
          Text(
            'GST Number',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
              color: isDark
                  ? AdminAppColors.darkTextPrimary
                  : AdminAppColors.textPrimary,
            ),
          ),
          Divider(
            height: 32.h,
            color: isDark ? AdminAppColors.darkBorder : const Color(0xFFF0EFF5),
          ),
          // GST Number
          Text(
            shop.gstNumber.isNotEmpty ? shop.gstNumber : 'Not Provided',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: shop.gstNumber.isNotEmpty
                  ? (isDark
                        ? AdminAppColors.darkTextPrimary
                        : AdminAppColors.textPrimary)
                  : (isDark
                        ? AdminAppColors.darkTextSecondary
                        : const Color(0xFF8A8A9E)),
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
