import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';

class AdminCustomerPastOrdersCard extends StatelessWidget {
  const AdminCustomerPastOrdersCard({super.key});

  @override
  Widget build(BuildContext context) {
    final mockOrders = [
      {
        'id': '#ORD-98310',
        'date': 'Nov 02, 2023',
        'amount': '₹89.00',
        'status': 'Shipped',
      },
      {
        'id': '#ORD-98421',
        'date': 'Nov 15, 2023',
        'amount': '₹124.50',
        'status': 'Delivered',
      },
      {
        'id': '#ORD-97855',
        'date': 'Oct 20, 2023',
        'amount': '₹432.20',
        'status': 'Delivered',
      },
      {
        'id': '#ORD-97642',
        'date': 'Oct 14, 2023',
        'amount': '₹56.00',
        'status': 'Canceled',
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE8E7ED), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(24.w),
            child: Text(
              'Past Orders',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
                color: AdminAppColors.textPrimary,
              ),
            ),
          ),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(2.0),
              1: FlexColumnWidth(2.0),
              2: FlexColumnWidth(1.5),
              3: FlexColumnWidth(1.5),
              4: FlexColumnWidth(1.2),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(
                decoration: const BoxDecoration(
                  color: Color(0xFFF4F5F7),
                  border: Border(
                    bottom: BorderSide(color: Color(0xFFE8E7ED), width: 1.5),
                  ),
                ),
                children: [
                  _buildTableHeaderCell('ORDER ID'),
                  _buildTableHeaderCell('DATE'),
                  _buildTableHeaderCell('AMOUNT'),
                  _buildTableHeaderCell('STATUS'),
                  _buildTableHeaderCell('ACTIONS'),
                ],
              ),
              ...mockOrders.map((order) {
                final status = order['status']!;
                Color badgeBg = const Color(0xFFDEF7EC);
                Color badgeText = const Color(0xFF03543F);
                if (status == 'Shipped') {
                  badgeBg = const Color(0xFFFEF08A);
                  badgeText = const Color(0xFF713F12);
                } else if (status == 'Canceled') {
                  badgeBg = const Color(0xFFFDE8E8);
                  badgeText = const Color(0xFF9B1C1C);
                }

                return TableRow(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFF0EFF5), width: 1.2),
                    ),
                  ),
                  children: [
                    // Order ID
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
                      child: Text(
                        order['id']!,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: AdminAppColors.primaryColor,
                        ),
                      ),
                    ),
                    // Date
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Text(
                        order['date']!,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: const Color(0xFF6C6C80),
                        ),
                      ),
                    ),
                    // Amount
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Text(
                        order['amount']!,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1E1E2F),
                        ),
                      ),
                    ),
                    // Status
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: badgeBg,
                            borderRadius: BorderRadius.circular(100.r),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                              color: badgeText,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Actions
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {
                            CustomSnackBar.show(
                              context,
                              message: 'Order details will be implemented in future',
                            );
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
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildTableHeaderCell(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
          color: const Color(0xFF8A8A9E),
        ),
      ),
    );
  }
}
