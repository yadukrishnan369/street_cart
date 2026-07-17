import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';
import 'package:street_cart/core/constants/customer_constants.dart';

// Support Hours Card
class SupportHoursCard extends StatelessWidget {
  const SupportHoursCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: CustomerAppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // clock icon badge
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: CustomerAppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.access_time_filled,
              color: CustomerAppColors.primary,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 16.w),
          // support hours label and time text
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SUPPORT HOURS',
                style: CustomerAppTextStyles.body.copyWith(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: Colors.grey.shade500,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                CustomerConstants.supportHours,
                style: CustomerAppTextStyles.body.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.sp,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
