import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/core/utils/debouncer.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/admin/orders/presentation/bloc/admin_orders_bloc.dart';
import 'package:street_cart/features/admin/orders/presentation/bloc/admin_orders_event.dart';
import 'package:street_cart/features/admin/orders/presentation/widgets/orders_table.dart';
import 'package:street_cart/shared/widgets/admin_pagination.dart';
import 'package:street_cart/shared/widgets/custom_admin_search_bar.dart';

// Orders Table Container
class OrdersTableContainer extends StatelessWidget {
  final List<OrderModel> orders;
  final Map<String, String> shopNames;
  final Map<String, String> customerNames;
  final bool isWide;
  final bool isLoading;
  final TextEditingController searchController;
  final Debouncer debouncer;
  final int currentPage;
  final int totalPages;
  final int perPage;
  final ValueChanged<int> onPageChanged;

  const OrdersTableContainer({
    super.key,
    required this.orders,
    required this.shopNames,
    required this.customerNames,
    required this.isWide,
    required this.isLoading,
    required this.searchController,
    required this.debouncer,
    required this.currentPage,
    required this.totalPages,
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
          // Header with Search bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomAdminSearchBar(
                  hintText: 'Search order ID, customer or shop',
                  controller: searchController,
                  width: isWide ? 360.w : 220.w,
                  onChanged: (val) {
                    debouncer.run(() {
                      context.read<AdminOrdersBloc>().add(
                        SearchQueryChanged(val),
                      );
                    });
                  },
                ),
              ],
            ),
          ),

          if (isLoading)
            const LinearProgressIndicator(
              color: AdminAppColors.primaryColor,
              backgroundColor: Colors.transparent,
              minHeight: 2,
            )
          else
            const SizedBox(height: 2),

          // Table data
          if (orders.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 80.h),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      color: AdminAppColors.primaryColor,
                      size: 64.sp,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'No matching orders found',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: AdminAppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else ...[
            // Orders Table Section
            OrdersTable(
              orders: orders,
              shopNames: shopNames,
              customerNames: customerNames,
              currentPage: currentPage,
              perPage: perPage,
            ),
            SizedBox(height: 24.h),
            // Pagination
            AdminPagination(
              currentPage: currentPage,
              totalPages: totalPages,
              onPageChanged: onPageChanged,
            ),
            SizedBox(height: 24.h),
          ],
        ],
      ),
    );
  }
}
