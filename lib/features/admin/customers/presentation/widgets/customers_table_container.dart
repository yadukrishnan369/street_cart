import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/core/utils/debouncer.dart';
import 'package:street_cart/shared/widgets/custom_admin_search_bar.dart';
import 'package:street_cart/features/admin/customers/presentation/bloc/admin_customers_bloc.dart';
import 'package:street_cart/features/admin/customers/presentation/bloc/admin_customers_event.dart';
import 'package:street_cart/features/admin/customers/presentation/bloc/admin_customers_state.dart';
import 'customers_table.dart';
import 'package:street_cart/shared/widgets/admin_pagination.dart';

// Customers Table Container
class CustomersTableContainer extends StatelessWidget {
  final AdminCustomersLoaded state;
  final bool isWide;
  final bool isLoading;
  final TextEditingController searchController;
  final Debouncer debouncer;
  final int perPage;
  final ValueChanged<int> onPageChanged;

  const CustomersTableContainer({
    super.key,
    required this.state,
    required this.isWide,
    required this.isLoading,
    required this.searchController,
    required this.debouncer,
    required this.perPage,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AdminAppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? AdminAppColors.darkBorder : const Color(0xFFE8E7ED),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E1E2F).withValues(alpha: 0.02),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Input field
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomAdminSearchBar(
                  hintText: 'Search customers by name or email',
                  controller: searchController,
                  width: isWide ? 360.w : 220.w,
                  onChanged: (val) {
                    debouncer.run(() {
                      context.read<AdminCustomersBloc>().add(
                        SearchCustomersQueryChanged(val),
                      );
                    });
                  },
                ),
              ],
            ),
          ),

          // Linear progress bar for search/filter operations
          if (isLoading)
            const LinearProgressIndicator(
              color: AdminAppColors.primaryColor,
              backgroundColor: Colors.transparent,
              minHeight: 2,
            )
          else
            const SizedBox(height: 2),

          // Customer lists or empty view matching state
          if (state.customers.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 80.h),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.people_outline,
                      color: AdminAppColors.primaryColor,
                      size: 64.sp,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'No matching customers found',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AdminAppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else ...[
            // Main Data Table
            CustomersTable(customers: state.customers),
            SizedBox(height: 24.h),

            // Pagination footer controls
            AdminPagination(
              currentPage: state.currentPage,
              totalPages: state.totalPages,
              onPageChanged: onPageChanged,
            ),
            SizedBox(height: 24.h),
          ],
        ],
      ),
    );
  }
}
