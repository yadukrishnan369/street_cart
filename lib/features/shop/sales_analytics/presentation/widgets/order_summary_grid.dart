import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';

// Order Summary Grid
class OrderSummaryGrid extends StatelessWidget {
  final Map<String, int> orderSummary;

  const OrderSummaryGrid({super.key, required this.orderSummary});

  @override
  Widget build(BuildContext context) {
    final total = orderSummary['total'] ?? 0;
    final completed = orderSummary['completed'] ?? 0;
    final pending = orderSummary['pending'] ?? 0;
    final cancelled = orderSummary['cancelled'] ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          'Order Summary',
          style: ShopAppTextStyles.bodyLargeBold.copyWith(
            fontSize: 16.sp,
            color: const Color(0xFF0F172A),
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.01),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Summary Cards
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryCell(
                      title: 'Total Orders',
                      value: total.toString(),
                      valueColor: const Color(0xFF0F172A),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 80.h,
                    color: const Color(0xFFE2E8F0),
                  ),
                  Expanded(
                    child: _buildSummaryCell(
                      title: 'Completed',
                      value: completed.toString(),
                      valueColor: ShopAppColors.success,
                    ),
                  ),
                ],
              ),
              Container(height: 1, color: const Color(0xFFE2E8F0)),
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryCell(
                      title: 'Pending',
                      value: pending.toString(),
                      valueColor: ShopAppColors.warning,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 80.h,
                    color: const Color(0xFFE2E8F0),
                  ),
                  Expanded(
                    child: _buildSummaryCell(
                      title: 'Cancelled/Returned',
                      value: cancelled.toString(),
                      valueColor: ShopAppColors.error,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCell({
    required String title,
    required String value,
    required Color valueColor,
  }) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Title
          Text(
            title,
            style: ShopAppTextStyles.caption.copyWith(
              color: ShopAppColors.textSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          // Card Value
          Text(
            value,
            style: ShopAppTextStyles.heading2.copyWith(
              color: valueColor,
              fontSize: 20.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
