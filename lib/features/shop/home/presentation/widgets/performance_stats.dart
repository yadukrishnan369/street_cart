import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/home/presentation/bloc/shop_home_bloc.dart';
import 'package:street_cart/features/shop/home/presentation/bloc/shop_home_state.dart';

// Performance Status
class PerformanceStats extends StatelessWidget {
  final String shopId;

  const PerformanceStats({super.key, required this.shopId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopHomeBloc, ShopHomeState>(
      builder: (context, state) {
        int todayOrdersCount = 0;
        int pendingDeliveriesCount = 0;

        if (state is ShopHomeDataLoaded) {
          final now = DateTime.now();
          final todayStart = DateTime(now.year, now.month, now.day);
          final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59);

          for (final order in state.orders) {
            final orderDate = order.createdAt;

            // Calculate pending deliveries
            if (order.status.toLowerCase() != 'delivered' &&
                order.status.toLowerCase() != 'cancelled') {
              pendingDeliveriesCount++;
            }

            // Check if order was placed today
            if (orderDate.isAfter(todayStart) && orderDate.isBefore(todayEnd)) {
              todayOrdersCount++;
            }
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title
                Text(
                  'Performance Today',
                  style: ShopAppTextStyles.bodyLargeBold,
                ),
                // Live Updates Label
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: ShopAppColors.successBg,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    'Live Updates',
                    style: ShopAppTextStyles.caption.copyWith(
                      color: ShopAppColors.primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 10.sp,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  // Today Orders Card
                  child: _buildStatCard(
                    'TODAY ORDERS',
                    todayOrdersCount.toString().padLeft(2, '0'),
                  ),
                ),
                SizedBox(width: 16.w),
                // Todal Sales Card
                Expanded(child: _buildStatCard('TODAY SALES', '₹12,450.0')),
              ],
            ),
            SizedBox(height: 20.h),
            // Pending Delivery Card
            _buildPendingCard(
              'PENDING DELIVERIES',
              pendingDeliveriesCount.toString().padLeft(2, '0'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: ShopAppColors.primaryLight,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: ShopAppColors.primary.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: ShopAppTextStyles.caption.copyWith(
              color: ShopAppColors.textSecondary,
              letterSpacing: 0.5.sp,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            value,
            style: ShopAppTextStyles.heading2.copyWith(
              fontSize: 22.sp,
              color: ShopAppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingCard(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: ShopAppColors.primaryLight,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: ShopAppColors.primary.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: ShopAppTextStyles.caption.copyWith(
                  color: ShopAppColors.textSecondary,
                  letterSpacing: 0.5.sp,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                value,
                style: ShopAppTextStyles.heading2.copyWith(
                  fontSize: 22.sp,
                  color: ShopAppColors.textPrimary,
                ),
              ),
            ],
          ),
          Icon(
            Icons.local_shipping_outlined,
            size: 28.sp,
            color: ShopAppColors.primary.withOpacity(0.4),
          ),
        ],
      ),
    );
  }
}
