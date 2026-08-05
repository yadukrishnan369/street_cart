import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/core/utils/debouncer.dart';
import 'package:street_cart/features/admin/revenue/presentation/bloc/admin_revenue_bloc.dart';
import 'package:street_cart/features/admin/revenue/presentation/bloc/admin_revenue_event.dart';
import 'package:street_cart/features/admin/revenue/presentation/bloc/admin_revenue_state.dart';
import 'package:street_cart/features/admin/revenue/presentation/widgets/revenue_orders_table.dart';
import 'package:street_cart/shared/widgets/admin_pagination.dart';
import 'package:street_cart/shared/widgets/custom_admin_search_bar.dart';

// Revenue Table Container
class RevenueTableContainer extends StatefulWidget {
  const RevenueTableContainer({super.key});

  @override
  State<RevenueTableContainer> createState() => _RevenueTableContainerState();
}

class _RevenueTableContainerState extends State<RevenueTableContainer> {
  late final TextEditingController _searchController;
  final Debouncer _debouncer = Debouncer(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    final blocState = context.read<AdminRevenueBloc>().state;
    final initialQuery = blocState is AdminRevenueLoaded
        ? blocState.searchQuery
        : '';
    _searchController = TextEditingController(text: initialQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocBuilder<AdminRevenueBloc, AdminRevenueState>(
      builder: (context, state) {
        if (state is! AdminRevenueLoaded) return const SizedBox.shrink();
        final bloc = context.read<AdminRevenueBloc>();

        return Container(
          decoration: BoxDecoration(
            color: isDark ? AdminAppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isDark
                  ? AdminAppColors.darkBorder
                  : const Color(0xFFF0EFF5),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Custom Admin Search Bar
                    CustomAdminSearchBar(
                      hintText: 'Search by order ID, customer name, shop name…',
                      controller: _searchController,
                      width: 380.w,
                      onChanged: (val) {
                        _debouncer.run(() {
                          bloc.add(RevenueSearchChanged(val));
                        });
                      },
                    ),
                  ],
                ),
              ),
              if (state.isSearching)
                const LinearProgressIndicator(
                  color: AdminAppColors.primaryColor,
                  backgroundColor: Colors.transparent,
                  minHeight: 2,
                )
              else
                const SizedBox(height: 2),
              Divider(
                height: 1,
                color: isDark
                    ? AdminAppColors.darkBorder
                    : const Color(0xFFF0EFF5),
              ),
              // Revenue Orders Table
              RevenueOrdersTable(
                orders: state.paginatedOrders,
                shops: state.shops,
                customers: state.customers,
              ),
              if (state.totalPages > 1) ...[
                Divider(
                  height: 1,
                  color: isDark
                      ? AdminAppColors.darkBorder
                      : const Color(0xFFF0EFF5),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  // Admin Pagination
                  child: AdminPagination(
                    currentPage: state.currentPage,
                    totalPages: state.totalPages,
                    onPageChanged: (page) => bloc.add(RevenuePageChanged(page)),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
