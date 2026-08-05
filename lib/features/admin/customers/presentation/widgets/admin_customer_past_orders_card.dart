import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/features/admin/customers/presentation/utils/admin_customers_helper.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/core/utils/price_utils.dart';
import 'package:street_cart/core/utils/date_formatter.dart';
import 'package:street_cart/features/admin/orders/presentation/utils/admin_orders_helper.dart';
import 'package:street_cart/shared/widgets/admin_pagination.dart';
import 'package:street_cart/features/admin/customers/presentation/bloc/admin_customer_detail_bloc.dart';
import 'package:street_cart/features/admin/customers/presentation/bloc/admin_customer_detail_event.dart';

// Admin Customer Past Orders Card
class AdminCustomerPastOrdersCard extends StatelessWidget {
  final List<OrderModel> orders;
  final int currentPage;

  const AdminCustomerPastOrdersCard({
    super.key,
    required this.orders,
    required this.currentPage,
  });

  static const int _perPage = 5;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Calculate total pages
    final totalPages = AdminCustomersHelper.getTotalPages(
      orders.length,
      _perPage,
    );

    // Filter list for the active page
    final paginatedOrders = AdminCustomersHelper.getPaginatedList(
      orders,
      currentPage,
      _perPage,
    );

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AdminAppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? AdminAppColors.darkBorder : const Color(0xFFE8E7ED),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header title
          Padding(
            padding: EdgeInsets.all(24.w),
            child: Text(
              'Past Orders',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
                color: isDark
                    ? AdminAppColors.darkTextPrimary
                    : AdminAppColors.textPrimary,
              ),
            ),
          ),
          if (orders.isEmpty)
            Padding(
              padding: EdgeInsets.all(24.w),
              child: Center(
                child: Text(
                  'No orders placed yet',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AdminAppColors.primaryColor,
                  ),
                ),
              ),
            )
          else ...[
            // Main order list table layout
            Table(
              columnWidths: const {
                0: FlexColumnWidth(1.5), // ORDER ID
                1: FlexColumnWidth(2.5), // PRODUCTS
                2: FlexColumnWidth(1.8), // DATE
                3: FlexColumnWidth(1.2), // AMOUNT
                4: FlexColumnWidth(1.2), // STATUS
                5: FlexColumnWidth(1.0), // ACTIONS
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: isDark
                        ? AdminAppColors.darkInputBackground
                        : const Color(0xFFF4F5F7),
                    border: Border(
                      bottom: BorderSide(
                        color: isDark
                            ? AdminAppColors.darkBorder
                            : const Color(0xFFE8E7ED),
                        width: 1.5,
                      ),
                    ),
                  ),
                  // Table Title
                  children: [
                    _buildTableHeaderCell(context, 'ORDER ID'),
                    _buildTableHeaderCell(context, 'PRODUCTS'),
                    _buildTableHeaderCell(context, 'DATE'),
                    _buildTableHeaderCell(context, 'AMOUNT'),
                    _buildTableHeaderCell(context, 'STATUS'),
                    _buildTableHeaderCell(context, 'ACTIONS'),
                  ],
                ),
                ...paginatedOrders.map((order) {
                  final returnStatus = (order.returnStatus ?? '').toLowerCase();
                  final status = returnStatus.isNotEmpty
                      ? order.returnStatus!
                      : order.status;
                  final displayStatus = AdminOrdersHelper.getStatusLabel(
                    status,
                  );
                  final badgeBg = AdminOrdersHelper.getStatusBgColor(status);
                  final badgeText = AdminOrdersHelper.getStatusTextColor(
                    status,
                  );

                  final dateStr = DateFormatter.formatToDateTime(
                    order.createdAt,
                  );
                  final amountStr = PriceUtils.formatPrice(order.totalAmount);
                  final productNamesDisplay =
                      AdminCustomersHelper.formatOrderItems(order.items);

                  return TableRow(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isDark
                              ? AdminAppColors.darkBorder
                              : const Color(0xFFE8E7ED),
                          width: 1.2,
                        ),
                      ),
                    ),
                    children: [
                      // Order ID
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 16.h,
                        ),
                        child: Text(
                          '#${order.id.substring(0, 8).toUpperCase()}',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: AdminAppColors.primaryColor,
                          ),
                        ),
                      ),
                      // Products Names
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Text(
                          productNamesDisplay,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: isDark
                                ? AdminAppColors.darkTextPrimary
                                : AdminAppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      // Date
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Text(
                          dateStr,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: isDark
                                ? AdminAppColors.darkTextSecondary
                                : const Color(0xFF6C6C80),
                          ),
                        ),
                      ),
                      // Total Amount
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Text(
                          amountStr,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? AdminAppColors.darkTextPrimary
                                : AdminAppColors.textPrimary,
                          ),
                        ),
                      ),
                      // Badge Status
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: badgeBg,
                              borderRadius: BorderRadius.circular(100.r),
                            ),
                            child: Text(
                              displayStatus,
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                                color: badgeText,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Actions view Details button
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            // Navigate to Order Details Page
                            onPressed: () {
                              context.push('/orders/${order.id}');
                            },
                            child: Text(
                              'View',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: AdminAppColors.primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
            if (totalPages > 1) ...[
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                // Admin Pagination
                child: AdminPagination(
                  currentPage: currentPage,
                  totalPages: totalPages,
                  onPageChanged: (page) {
                    context.read<AdminCustomerDetailBloc>().add(
                      ChangePastOrdersPageRequested(page),
                    );
                  },
                ),
              ),
            ],
          ],
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildTableHeaderCell(BuildContext context, String text) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
          color: isDark
              ? AdminAppColors.darkTextSecondary
              : const Color(0xFF8A8A9E),
        ),
      ),
    );
  }
}
