import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';

// Orders Tab Bar
class OrdersTabBar extends StatelessWidget {
  final int activeTab;
  final ValueChanged<int> onTabChanged;

  const OrdersTabBar({
    super.key,
    required this.activeTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          // Tab Titles
          children: [
            _buildTab(context, label: 'All Orders', index: 0),
            _buildTab(context, label: 'Processing', index: 1),
            _buildTab(context, label: 'Packed/Shipped', index: 2),
            _buildTab(context, label: 'Completed', index: 3),
            _buildTab(context, label: 'Cancelled', index: 4),
          ],
        ),
        const Divider(height: 1, thickness: 1.5, color: Color(0xFFE8E7ED)),
      ],
    );
  }

  Widget _buildTab(
    BuildContext context, {
    required String label,
    required int index,
  }) {
    final isSelected = index == activeTab;
    return GestureDetector(
      onTap: () => onTabChanged(index),
      child: Container(
        margin: EdgeInsets.only(right: 24.w),
        padding: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          border: isSelected
              ? Border(
                  bottom: BorderSide(
                    color: AdminAppColors.primaryColor,
                    width: 2.w,
                  ),
                )
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected
                ? AdminAppColors.primaryColor
                : const Color(0xFF6C6C80),
          ),
        ),
      ),
    );
  }
}
