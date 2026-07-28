import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/core/utils/price_utils.dart';

// Revenue Stats Cards
class RevenueStatsCards extends StatelessWidget {
  final double totalRevenue;
  final double todayRevenue;
  final double lastMonthRevenue;

  const RevenueStatsCards({
    super.key,
    required this.totalRevenue,
    required this.todayRevenue,
    required this.lastMonthRevenue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildCard(
            icon: Icons.account_balance_wallet_outlined,
            label: 'Total Revenue',
            value: '₹${PriceUtils.formatPrice(totalRevenue)}',
            color: AdminAppColors.primaryColor,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _buildCard(
            icon: Icons.today_outlined,
            label: 'Today Revenue',
            value: '₹${PriceUtils.formatPrice(todayRevenue)}',
            color: AdminAppColors.successColor,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _buildCard(
            icon: Icons.calendar_month_outlined,
            label: 'Last Month Revenue',
            value: '₹${PriceUtils.formatPrice(lastMonthRevenue)}',
            color: AdminAppColors.warningColor,
          ),
        ),
      ],
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFF0EFF5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: color, size: 22.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Card Label
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: AdminAppColors.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 6.h),
                // Card Value
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    color: AdminAppColors.textPrimary,
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
