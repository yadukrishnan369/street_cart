import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';

// Product Metric Cards
class ProductMetricCards extends StatelessWidget {
  final int totalProducts;
  final int activeItems;
  final int outOfStock;
  final int disabledItems;
  final bool isWide;

  const ProductMetricCards({
    super.key,
    required this.totalProducts,
    required this.activeItems,
    required this.outOfStock,
    required this.disabledItems,
    required this.isWide,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> cardData = [
      {
        'title': 'Total Products',
        'value': '$totalProducts',
        'color': AdminAppColors.textPrimary,
        'icon': Icons.inventory_2_outlined,
        'iconBgColor': const Color(0xFFF4EBFF),
        'iconColor': AdminAppColors.primaryColor,
      },
      {
        'title': 'Active Items',
        'value': '$activeItems',
        'color': AdminAppColors.successColor,
        'icon': Icons.check_circle_outline,
        'iconBgColor': const Color(0xFFE6F4EA),
        'iconColor': AdminAppColors.successColor,
      },
      {
        'title': 'Out Of Stock',
        'value': '$outOfStock',
        'color': AdminAppColors.errorColor,
        'icon': Icons.warning_amber_outlined,
        'iconBgColor': const Color(0xFFFFF4E5),
        'iconColor': AdminAppColors.warningColor,
      },
      {
        'title': 'Disabled Items',
        'value': '$disabledItems',
        'color': const Color(0xFF9B1C1C),
        'icon': Icons.block,
        'iconBgColor': const Color(0xFFFDE8E8),
        'iconColor': const Color(0xFF9B1C1C),
      },
    ];

    if (isWide) {
      return Row(
        children: cardData.map((data) {
          final String title = data['title'] as String;
          final String value = data['value'] as String;
          final Color color = data['color'] as Color;
          final IconData icon = data['icon'] as IconData;
          final Color iconBgColor = data['iconBgColor'] as Color;
          final Color iconColor = data['iconColor'] as Color;

          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: data != cardData.last ? 16.w : 0),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFFE8E7ED), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1E1E2F).withValues(alpha: 0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: iconBgColor,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(icon, color: iconColor, size: 24.sp),
                  ),
                  SizedBox(width: 16.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Title
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF8A8A9E),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        value,
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      );
    } else {
      return Column(
        children: cardData.map((data) {
          final String title = data['title'] as String;
          final String value = data['value'] as String;
          final Color color = data['color'] as Color;
          final IconData icon = data['icon'] as IconData;
          final Color iconBgColor = data['iconBgColor'] as Color;
          final Color iconColor = data['iconColor'] as Color;

          return Container(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFFE8E7ED), width: 1.5),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(icon, color: iconColor, size: 20.sp),
                ),
                SizedBox(width: 16.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF8A8A9E),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      );
    }
  }
}
