import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/core/utils/number_formatter.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/admin/auth/presentation/bloc/admin_auth_bloc.dart';
import 'package:street_cart/features/admin/auth/presentation/bloc/admin_auth_state.dart';
import 'package:street_cart/features/admin/dashboard/presentation/bloc/admin_dashboard_bloc.dart';
import 'package:street_cart/features/admin/dashboard/presentation/bloc/admin_dashboard_event.dart';
import 'package:street_cart/features/admin/dashboard/presentation/bloc/admin_dashboard_state.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';
import 'package:street_cart/shared/widgets/admin_error_view.dart';
import 'package:street_cart/core/router/admin/route_paths.dart';
import 'package:go_router/go_router.dart';
import 'package:street_cart/features/admin/dashboard/presentation/widgets/stat_card.dart';
import 'package:street_cart/features/admin/dashboard/presentation/widgets/new_registrations_section.dart';
import 'package:street_cart/features/admin/dashboard/presentation/widgets/shimmer/admin_dashboard_shimmer.dart';
import 'package:street_cart/features/admin/dashboard/presentation/widgets/recent_orders_table.dart';

// Admin Dashboard Page
class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<AdminDashboardBloc>()..add(LoadDashboardDataRequested()),
      child: MultiBlocListener(
        listeners: [
          BlocListener<AdminAuthBloc, AdminAuthState>(
            listener: (context, state) {
              if (state is AdminUnauthenticated) {
                CustomSnackBar.show(
                  context,
                  message: 'Logged out successfully.',
                );
              }
            },
          ),
        ],
        child: BlocBuilder<AdminDashboardBloc, AdminDashboardState>(
          builder: (context, state) {
            if (state is AdminDashboardLoading) {
              // Admin Dashboard Shimmer
              return const AdminDashboardShimmer();
            } else if (state is AdminDashboardLoadSuccess) {
              final stats = state.stats;
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 32.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth > 900;
                        final columns = isWide
                            ? 4
                            : (constraints.maxWidth > 500 ? 2 : 1);
                        return GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: columns,
                          crossAxisSpacing: 20.w,
                          mainAxisSpacing: 20.h,
                          childAspectRatio: isWide ? 1.6 : 2.0,
                          // Stats Cards
                          children: [
                            StatCard(
                              title: 'Current Shops',
                              value: NumberFormatter.formatNumber(
                                stats.totalShops,
                              ),
                              icon: Icons.storefront_outlined,
                              iconColor: AdminAppColors.primaryColor,
                              iconBgColor: const Color(0xFFF4EBFF),
                            ),
                            StatCard(
                              title: 'Current Customers',
                              value: NumberFormatter.formatNumber(
                                stats.totalCustomers,
                              ),
                              icon: Icons.people_outline,
                              iconColor: const Color(0xFF1A73E8),
                              iconBgColor: const Color(0xFFE8F0FE),
                            ),
                            StatCard(
                              title: 'Completed Orders',
                              value: NumberFormatter.formatNumber(
                                stats.totalOrders,
                              ),
                              icon: Icons.shopping_bag_outlined,
                              iconColor: AdminAppColors.warningColor,
                              iconBgColor: const Color(0xFFFFF4E5),
                            ),
                            StatCard(
                              title: 'Total Revenue',
                              value:
                                  '₹${stats.totalRevenue.toStringAsFixed(2)}',
                              icon: Icons.monetization_on_outlined,
                              iconColor: AdminAppColors.successColor,
                              iconBgColor: const Color(0xFFE6F4EA),
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 32.h),
                    // New Registrations Section
                    NewRegistrationsSection(
                      registrations: stats.newRegistrations,
                      onSeeAll: () {
                        // Navigate to Registration Page
                        context.push(RoutePaths.registrations);
                      },
                      onApprove: (id) async {
                        final refresh = await context.push(
                          RoutePaths.registrationDetails.replaceAll(':id', id),
                        );
                        if (refresh == true && context.mounted) {
                          context.read<AdminDashboardBloc>().add(
                            LoadDashboardDataRequested(),
                          );
                        }
                      },
                    ),
                    SizedBox(height: 32.h),
                    // Recent Orders Table
                    RecentOrdersTable(
                      orders: stats.recentOrders,
                      onViewAll: () {
                        context.push(RoutePaths.orders);
                      },
                    ),
                  ],
                ),
              );
            } else if (state is AdminDashboardLoadFailure) {
              // App Error View with retry
              return AdminErrorView(
                message: state.message,
                onRetry: () => context.read<AdminDashboardBloc>().add(
                  LoadDashboardDataRequested(),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
