import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/admin/revenue/presentation/bloc/admin_revenue_bloc.dart';
import 'package:street_cart/features/admin/revenue/presentation/bloc/admin_revenue_event.dart';
import 'package:street_cart/features/admin/revenue/presentation/bloc/admin_revenue_state.dart';
import 'package:street_cart/features/admin/revenue/presentation/widgets/revenue_filter_bar.dart';
import 'package:street_cart/features/admin/revenue/presentation/widgets/revenue_stats_cards.dart';
import 'package:street_cart/features/admin/revenue/presentation/widgets/revenue_table_container.dart';
import 'package:street_cart/features/admin/revenue/presentation/widgets/shimmer/admin_revenue_shimmer.dart';
import 'package:street_cart/shared/widgets/admin_error_view.dart';

// Admin Revenue Page
class AdminRevenuePage extends StatelessWidget {
  const AdminRevenuePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AdminRevenueBloc>()..add(const LoadAdminRevenueData()),
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFC),
        body: SafeArea(
          child: BlocBuilder<AdminRevenueBloc, AdminRevenueState>(
            builder: (context, state) {
              // Loading Shimmer
              if (state is AdminRevenueLoading ||
                  state is AdminRevenueInitial) {
                return const AdminRevenueShimmer();
              }
              // Error View
              if (state is AdminRevenueError) {
                return AdminErrorView(
                  message: state.message,
                  onRetry: () => context.read<AdminRevenueBloc>().add(
                    const LoadAdminRevenueData(),
                  ),
                );
              }
              if (state is AdminRevenueLoaded) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 900;
                    final hPad = isWide ? 40.w : 20.w;
                    return SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: hPad,
                        vertical: 32.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          (BuildContext context) {
                            final headerText = Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title
                                Text(
                                  'Revenue Breakdown',
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w800,
                                    color: AdminAppColors.textPrimary,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                // Subtitle
                                Text(
                                  'Detailed overview of platform earnings and partner payouts.',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: AdminAppColors.textSecondary,
                                  ),
                                ),
                              ],
                            );
                            // Filter Refresh Button
                            final refreshBtn = Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(
                                  color: const Color(0xFFE0E0E0),
                                ),
                              ),
                              child: IconButton(
                                onPressed: () => context
                                    .read<AdminRevenueBloc>()
                                    .add(const ResetRevenueFilters()),
                                icon: Icon(
                                  Icons.refresh_rounded,
                                  size: 20.sp,
                                  color: AdminAppColors.primaryColor,
                                ),
                                tooltip: 'Reset Filters',
                              ),
                            );
                            // Revenue Filter Bar
                            return Wrap(
                              spacing: 16.w,
                              runSpacing: 16.h,
                              alignment: WrapAlignment.spaceBetween,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                headerText,
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const RevenueFilterBar(),
                                    SizedBox(width: 12.w),
                                    refreshBtn,
                                  ],
                                ),
                              ],
                            );
                          }(context),
                          SizedBox(height: 28.h),
                          // Revenue Stats Cards
                          RevenueStatsCards(
                            totalRevenue: state.totalRevenue,
                            todayRevenue: state.todayRevenue,
                            lastMonthRevenue: state.lastMonthRevenue,
                          ),
                          SizedBox(height: 32.h),
                          // Revenue Table Container
                          const RevenueTableContainer(),
                          SizedBox(height: 32.h),
                        ],
                      ),
                    );
                  },
                );
              }
              return const AdminRevenueShimmer();
            },
          ),
        ),
      ),
    );
  }
}
