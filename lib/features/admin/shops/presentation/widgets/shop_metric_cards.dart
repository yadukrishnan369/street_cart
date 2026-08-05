import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';

// Shop Metric Cards
class ShopMetricCards extends StatelessWidget {
  final int totalShops;
  final int activeShops;
  final int suspendedShops;
  final bool isWide;

  const ShopMetricCards({
    super.key,
    required this.totalShops,
    required this.activeShops,
    required this.suspendedShops,
    required this.isWide,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final List<Map<String, dynamic>> cardData = [
      {
        'title': 'Total Shops',
        'value': '$totalShops',
        'color': isDark
            ? AdminAppColors.darkTextPrimary
            : AdminAppColors.textPrimary,
      },
      {
        'title': 'Active Now',
        'value': '$activeShops',
        'color': AdminAppColors.successColor,
      },
      {
        'title': 'Suspended',
        'value': '$suspendedShops',
        'color': AdminAppColors.errorColor,
      },
    ];

    if (isWide) {
      return Row(
        children: cardData.map((data) {
          final String title = data['title'] as String;
          final String value = data['value'] as String;
          final Color color = data['color'] as Color;

          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: data != cardData.last ? 16.w : 0),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: isDark ? AdminAppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: isDark
                      ? AdminAppColors.darkBorder
                      : const Color(0xFFE8E7ED),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1E1E2F).withValues(alpha: 0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AdminAppColors.darkTextSecondary
                          : const Color(0xFF8A8A9E),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
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

          return Container(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: isDark ? AdminAppColors.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: isDark
                    ? AdminAppColors.darkBorder
                    : const Color(0xFFE8E7ED),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AdminAppColors.darkTextSecondary
                        : const Color(0xFF8A8A9E),
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      );
    }
  }
}
