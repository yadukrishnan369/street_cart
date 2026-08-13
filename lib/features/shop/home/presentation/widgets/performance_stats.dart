import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/core/utils/price_utils.dart';
import 'package:street_cart/features/shop/home/presentation/bloc/shop_home_bloc.dart';
import 'package:street_cart/features/shop/home/presentation/bloc/shop_home_state.dart';
import 'package:street_cart/features/shop/home/presentation/utils/shop_home_helper.dart';
import 'package:street_cart/core/animation/text_animation.dart';

// Performance Status
class PerformanceStats extends StatelessWidget {
  final String shopId;

  const PerformanceStats({super.key, required this.shopId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocBuilder<ShopHomeBloc, ShopHomeState>(
      builder: (context, state) {
        int todayOrdersCount = 0;
        int pendingDeliveriesCount = 0;
        double todaySales = 0.0;

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

          todaySales = ShopHomeHelper.calculateTodaySales(
            orders: state.orders,
            shopId: shopId,
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title
                AppTextAnimation.fade(
                  'Performance Today',
                  style: ShopAppTextStyles.bodyLargeBold.copyWith(
                    color: isDark
                        ? ShopAppColors.darkTextPrimary
                        : ShopAppColors.textPrimary,
                  ),
                  duration: const Duration(milliseconds: 1000),
                ),
                // Live Updates Label
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? ShopAppColors.primary.withValues(alpha: 0.2)
                        : ShopAppColors.successBg,
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
                    isDark,
                  ),
                ),
                SizedBox(width: 16.w),
                // Today Sales Card
                Expanded(
                  child: _buildStatCard(
                    'TODAY SALES',
                    PriceUtils.formatPrice(todaySales),
                    isDark,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            // Pending Delivery Card
            _buildPendingCard(
              'PENDING DELIVERIES',
              pendingDeliveriesCount.toString().padLeft(2, '0'),
              isDark,
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(String label, String value, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: isDark ? ShopAppColors.darkSurface : ShopAppColors.primaryLight,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: isDark
              ? ShopAppColors.darkBorder
              : ShopAppColors.primary.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: ShopAppTextStyles.caption.copyWith(
              color: isDark
                  ? ShopAppColors.darkTextSecondary
                  : ShopAppColors.textSecondary,
              letterSpacing: 0.5.sp,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            value,
            style: ShopAppTextStyles.heading2.copyWith(
              fontSize: 22.sp,
              color: isDark
                  ? ShopAppColors.darkTextPrimary
                  : ShopAppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingCard(String label, String value, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: isDark ? ShopAppColors.darkSurface : ShopAppColors.primaryLight,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: isDark
              ? ShopAppColors.darkBorder
              : ShopAppColors.primary.withValues(alpha: 0.1),
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
                  color: isDark
                      ? ShopAppColors.darkTextSecondary
                      : ShopAppColors.textSecondary,
                  letterSpacing: 0.5.sp,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                value,
                style: ShopAppTextStyles.heading2.copyWith(
                  fontSize: 22.sp,
                  color: isDark
                      ? ShopAppColors.darkTextPrimary
                      : ShopAppColors.textPrimary,
                ),
              ),
            ],
          ),
          Icon(
            Icons.local_shipping_outlined,
            size: 28.sp,
            color: ShopAppColors.primary.withValues(alpha: 0.4),
          ),
        ],
      ),
    );
  }
}
