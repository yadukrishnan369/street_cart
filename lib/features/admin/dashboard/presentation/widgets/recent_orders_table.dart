import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/features/admin/dashboard/data/models/recent_order_model.dart';
import 'package:street_cart/features/admin/orders/presentation/utils/admin_orders_helper.dart';

class RecentOrdersTable extends StatelessWidget {
  final List<RecentOrderModel> orders;
  final VoidCallback? onViewAll;

  const RecentOrdersTable({super.key, required this.orders, this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFF0EFF5), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Orders',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1E1E2F),
                ),
              ),
              TextButton(
                onPressed: onViewAll,
                child: Text(
                  'View all',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF9D4EDD),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          SingleChildScrollView(
            child: SizedBox(
              width: 950.w,
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(1.8), // Order ID
                  1: FlexColumnWidth(2.2), // Customer
                  2: FlexColumnWidth(1.5), // Amount
                  3: FlexColumnWidth(1.5), // Status
                  4: FlexColumnWidth(1.2), // Actions
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  // Table Header Row
                  TableRow(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xFFF0EFF5),
                          width: 1.5,
                        ),
                      ),
                    ),
                    children: [
                      _buildHeaderCell('ORDER ID'),
                      _buildHeaderCell('CUSTOMER'),
                      _buildHeaderCell('AMOUNT'),
                      _buildHeaderCell('STATUS'),
                      _buildHeaderCell('ACTIONS'),
                    ],
                  ),
                  // Table Data Rows
                  ...orders.map((order) {
                    // order ID
                    final displayId = order.id.length >= 4
                        ? '#ORD-${order.id.substring(order.id.length - 4)}'
                              .toUpperCase()
                        : order.id.toUpperCase();

                    return TableRow(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0xFFF0EFF5),
                            width: 1,
                          ),
                        ),
                      ),
                      children: [
                        _buildDataCell(displayId, isBold: true),
                        _buildDataCell(order.customerName),
                        _buildDataCell(
                          '₹${order.amount.toStringAsFixed(2)}',
                          isBold: true,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: _buildStatusBadge(order.status),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton(
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String label) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
          color: const Color(0xFF8A8A9E),
        ),
      ),
    );
  }

  Widget _buildDataCell(String value, {bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Text(
        value,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
          color: const Color(0xFF1E1E2F),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final bgColor = AdminOrdersHelper.getStatusBgColor(status);
    final textColor = AdminOrdersHelper.getStatusTextColor(status);
    final label = AdminOrdersHelper.getStatusLabel(status);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}
