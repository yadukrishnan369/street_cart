import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/core/utils/price_utils.dart';

class AdminCustomerStatsCard extends StatelessWidget {
  final List<OrderModel> orders;

  const AdminCustomerStatsCard({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    // Total spent amount
    double totalSpent = 0.0;
    for (final order in orders) {
      if (order.status.toLowerCase() != 'cancelled') {
        totalSpent += order.totalAmount;
      }
    }

    // Returns count
    final returnsCount = orders
        .where((o) => o.status.toLowerCase() == 'cancelled')
        .length;

    // Total orders count
    final totalOrders = orders.length;
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE8E7ED), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.analytics_outlined,
                color: AdminAppColors.primaryColor,
                size: 18.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'ACCOUNT STATISTICS',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                  color: AdminAppColors.textPrimary,
                ),
              ),
            ],
          ),
          Divider(height: 32.h, color: const Color(0xFFF0EFF5), thickness: 1.2),

          // Total Spent
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFC),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Spent',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: const Color(0xFF8A8A9E),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  '₹${PriceUtils.formatPrice(totalSpent)}',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                    color: AdminAppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 4.h),

          Row(
            children: [
              // Returns Box
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFC),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Returns',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: const Color(0xFF8A8A9E),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        '$returnsCount',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1E1E2F),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 16.w),

              // Total Orders
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFC),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Orders',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: const Color(0xFF8A8A9E),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        '$totalOrders',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1E1E2F),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
