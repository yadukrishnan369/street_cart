import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/constants/admin_constants.dart';
import 'package:street_cart/core/theme/admin/admin_text_styles.dart';

class AdminProfileBioCard extends StatelessWidget {
  const AdminProfileBioCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFECEFF1), width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AdminConstants.bioTitle,
            style: AdminAppTextStyles.heading3.copyWith(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E1E2F),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            AdminConstants.bioContent,
            style: AdminAppTextStyles.bodyMedium.copyWith(
              color: const Color(0xFF4A4A68),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
