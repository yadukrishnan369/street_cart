import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:street_cart/core/router/admin/route_paths.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/features/admin/customers/data/models/customer_model.dart';
import 'package:street_cart/features/admin/customers/presentation/bloc/admin_customers_bloc.dart';
import 'package:street_cart/features/admin/customers/presentation/bloc/admin_customers_event.dart';

class CustomersTable extends StatelessWidget {
  final List<CustomerModel> customers;

  const CustomersTable({super.key, required this.customers});

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2.0),
        1: FlexColumnWidth(2.5),
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
            _buildTableHeaderCell('CUSTOMER NAME'),
            _buildTableHeaderCell('EMAIL'),
            _buildTableHeaderCell('TOTAL ORDERS'),
            _buildTableHeaderCell('STATUS'),
            _buildTableHeaderCell('ACTIONS'),
          ],
        ),
        ...customers.map((c) => _buildTableRow(context, c)),
      ],
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

  TableRow _buildTableRow(BuildContext context, CustomerModel customer) {
    final isBlocked = customer.isBlocked;
    final initials = customer.fullName.isNotEmpty
        ? customer.fullName
              .trim()
              .split(' ')
              .map((e) => e[0])
              .take(2)
              .join()
              .toUpperCase()
        : 'JD';

    return TableRow(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFF0EFF5), width: 1.2),
        ),
      ),
      children: [
        // Name & Avatar
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18.r,
                backgroundColor: const Color(0xFFEBE9F5),
                backgroundImage: customer.profileImageUrl.isNotEmpty
                    ? NetworkImage(customer.profileImageUrl)
                    : null,
                child: customer.profileImageUrl.isEmpty
                    ? Text(
                        initials,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: AdminAppColors.primaryColor,
                        ),
                      )
                    : null,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  customer.fullName.isNotEmpty ? customer.fullName : 'Unknown',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E1E2F),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),

        // Email
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Text(
            customer.email.isNotEmpty ? customer.email : 'Unknown',
            style: TextStyle(fontSize: 13.sp, color: const Color(0xFF6C6C80)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        // Total orders
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Text(
            '${customer.totalOrders}',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1E1E2F),
            ),
          ),
        ),

        // Status badge
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: isBlocked
                    ? const Color(0xFFFDE8E8)
                    : const Color(0xFFDEF7EC),
                borderRadius: BorderRadius.circular(100.r),
              ),
              child: Text(
                isBlocked ? 'Blocked' : 'Active',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                  color: isBlocked
                      ? const Color(0xFF9B1C1C)
                      : const Color(0xFF03543F),
                ),
              ),
            ),
          ),
        ),

        // Action View button navigates to details
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () async {
                final refresh = await context.push(
                  RoutePaths.customerDetails.replaceAll(':id', customer.uid),
                );
                if (refresh == true && context.mounted) {
                  context.read<AdminCustomersBloc>().add(
                    LoadAdminCustomers(page: 1, limit: 7),
                  );
                }
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
  }
}
