import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/recent_order_model.dart';

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
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 950.w,
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(2.0), // Order ID
                  1: FlexColumnWidth(2.0), // Customer
                  2: FlexColumnWidth(2.0), // Amount
                  3: FlexColumnWidth(2.0), // Status
                  4: FlexColumnWidth(2.0), // Date
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
                      _buildHeaderCell('DATE'),
                    ],
                  ),
                  // Table Data Rows
                  ...orders.map((order) {
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
                        _buildDataCell(order.id, isBold: true),
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
                        _buildDataCell(order.timeAgo),
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
    Color bgColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'delivered':
        bgColor = const Color(0xFFE6F4EA);
        textColor = const Color(0xFF137333);
        break;
      case 'processing':
        bgColor = const Color(0xFFE8F0FE);
        textColor = const Color(0xFF1A73E8);
        break;
      case 'shipped':
        bgColor = const Color(0xFFF3E8FF);
        textColor = const Color(0xFF7B2CBF);
        break;
      default:
        bgColor = const Color(0xFFF9FAFC);
        textColor = const Color(0xFF6C6C80);
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}
