import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/core/utils/price_utils.dart';
import 'package:street_cart/features/shop/home/presentation/bloc/shop_home_bloc.dart';
import 'package:street_cart/features/shop/home/presentation/bloc/shop_home_state.dart';
import 'package:street_cart/features/shop/home/presentation/utils/shop_home_helper.dart';
import 'package:street_cart/features/shop/sales_analytics/presentation/pages/sales_analytics_page.dart';

// Weekly Sales Card
class WeeklySalesCard extends StatelessWidget {
  final String shopId;

  const WeeklySalesCard({super.key, required this.shopId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocBuilder<ShopHomeBloc, ShopHomeState>(
      builder: (context, state) {
        double weeklySales = 0.0;
        double totalSales = 0.0;

        if (state is ShopHomeDataLoaded) {
          weeklySales = ShopHomeHelper.calculateWeeklySales(
            orders: state.orders,
            shopId: shopId,
          );
          totalSales = ShopHomeHelper.calculateTotalSales(
            orders: state.orders,
            shopId: shopId,
          );
        }

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          decoration: BoxDecoration(
            color: isDark
                ? ShopAppColors.darkSurface
                : ShopAppColors.primaryLight,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Total Sales Label
                  Text(
                    'TOTAL SALES',
                    style: ShopAppTextStyles.bodySmallBold.copyWith(
                      color: isDark
                          ? ShopAppColors.darkTextSecondary
                          : ShopAppColors.textSecondary,
                      letterSpacing: 0.5.sp,
                    ),
                  ),
                  // Total Sales Amount
                  Text(
                    PriceUtils.formatPrice(totalSales),
                    style: ShopAppTextStyles.bodySmallBold.copyWith(
                      color: isDark
                          ? ShopAppColors.darkTextPrimary
                          : ShopAppColors.textPrimary,
                      letterSpacing: 0.5.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Weekly Sales Label
                      Text(
                        'WEEKLY SALES',
                        style: ShopAppTextStyles.caption.copyWith(
                          color: isDark
                              ? ShopAppColors.darkTextSecondary
                              : ShopAppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      // Weekly Amount
                      Text(
                        PriceUtils.formatPrice(weeklySales),
                        style: ShopAppTextStyles.heading2.copyWith(
                          color: ShopAppColors.primary,
                          fontSize: 22.sp,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigate to Shop Sales Analytics Page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ShopSalesAnalyticsPage(),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Text(
                          'VIEW ANALYTICS',
                          style: ShopAppTextStyles.caption.copyWith(
                            fontWeight: FontWeight.w900,
                            color: ShopAppColors.primary,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Icon(
                          Icons.chevron_right_rounded,
                          size: 16.sp,
                          color: ShopAppColors.primary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
