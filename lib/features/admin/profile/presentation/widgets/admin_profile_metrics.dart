import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/core/theme/admin/admin_text_styles.dart';

// Admin Profile Metrics
class AdminProfileMetrics extends StatelessWidget {
  final int approvedShopsCount;
  final int ordersTrackedCount;
  final int reviewsCount;

  const AdminProfileMetrics({
    super.key,
    required this.approvedShopsCount,
    required this.ordersTrackedCount,
    required this.reviewsCount,
  });

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
          Row(
            children: [
              Icon(
                Icons.analytics_outlined,
                size: 20.sp,
                color: AdminAppColors.primaryColor,
              ),
              SizedBox(width: 10.w),
              // Title
              Text(
                'Personal Performance Metrics',
                style: AdminAppTextStyles.heading3.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E1E2F),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          Row(
            children: [
              Expanded(
                // Total Shop Approved Card
                child: _buildMetricTile(
                  icon: Icons.check_circle_outline,
                  value: approvedShopsCount.toString(),
                  label: 'Shops Approved',
                  iconBgColor: const Color.fromARGB(255, 194, 170, 219),
                  iconColor: AdminAppColors.primaryColor,
                ),
              ),
              SizedBox(width: 16.w),
              // Total Review Card
              Expanded(
                child: _buildMetricTile(
                  icon: Icons.rate_review_outlined,
                  value: reviewsCount.toString(),
                  label: 'Reviews',
                  iconBgColor: const Color.fromARGB(255, 219, 203, 176),
                  iconColor: AdminAppColors.warningColor,
                ),
              ),
              SizedBox(width: 16.w),
              // Total Order Tracked Card
              Expanded(
                child: _buildMetricTile(
                  icon: Icons.inventory_2_outlined,
                  value: ordersTrackedCount.toString(),
                  label: 'Order Tracked',
                  iconBgColor: const Color.fromARGB(255, 190, 219, 218),
                  iconColor: AdminAppColors.successColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile({
    required IconData icon,
    required String value,
    required String label,
    required Color iconBgColor,
    required Color iconColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: iconBgColor.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20.sp),
          ),
          SizedBox(height: 12.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1E1E2F),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF8A8A9E),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
