import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/core/utils/price_utils.dart';
import 'package:street_cart/features/admin/customers/presentation/utils/admin_customers_helper.dart';

// Admin Customer Stats Card
class AdminCustomerStatsCard extends StatelessWidget {
  final List<OrderModel> orders;

  const AdminCustomerStatsCard({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    // Total spent amount
    final totalSpent = AdminCustomersHelper.getTotalSpent(orders);

    // Returns count
    final returnsCount = AdminCustomersHelper.getReturnsCount(orders);

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
              // Title
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

          // Total Spent Amount
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
                // Spent Amount
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
              // Total Returns Count
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
                      // Return Count
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
                      // Total Orders Count
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
