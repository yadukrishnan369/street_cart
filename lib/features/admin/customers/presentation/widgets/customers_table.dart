import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:street_cart/core/router/admin/route_paths.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/features/admin/customers/data/models/customer_model.dart';
import 'package:street_cart/features/admin/customers/presentation/bloc/admin_customers_bloc.dart';
import 'package:street_cart/features/admin/customers/presentation/bloc/admin_customers_event.dart';
import 'package:street_cart/features/admin/customers/presentation/utils/admin_customers_helper.dart';
import 'package:street_cart/shared/widgets/customer_image_placeholder.dart';

// Customers Table
class CustomersTable extends StatelessWidget {
  final List<CustomerModel> customers;

  const CustomersTable({super.key, required this.customers});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
          // Table Headers
          children: [
            _buildTableHeaderCell(context, 'CUSTOMER NAME'),
            _buildTableHeaderCell(context, 'EMAIL'),
            _buildTableHeaderCell(context, 'TOTAL ORDERS'),
            _buildTableHeaderCell(context, 'STATUS'),
            _buildTableHeaderCell(context, 'ACTIONS'),
          ],
        ),
        ...customers.map((c) => _buildTableRow(context, c)),
      ],
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

  TableRow _buildTableRow(BuildContext context, CustomerModel customer) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isBlocked = customer.isBlocked;
    final initials = AdminCustomersHelper.getCustomerInitials(
      customer.fullName,
    );

    return TableRow(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? AdminAppColors.darkBorder : const Color(0xFFF0EFF5),
            width: 1.2,
          ),
        ),
      ),
      children: [
        // Name & Image
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18.r,
                backgroundColor: isDark
                    ? AdminAppColors.darkInputBackground
                    : const Color(0xFFEBE9F5),
                child: customer.profileImageUrl.isNotEmpty
                    ? ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: customer.profileImageUrl,
                          width: 36.r,
                          height: 36.r,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              CustomerImagePlaceholder(
                                size: 36.w,
                                iconColor: AdminAppColors.primaryColor,
                              ),
                          errorWidget: (context, url, error) =>
                              CustomerImagePlaceholder(
                                size: 36.w,
                                iconColor: AdminAppColors.primaryColor,
                              ),
                        ),
                      )
                    : Text(
                        initials,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: AdminAppColors.primaryColor,
                        ),
                      ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                // Customer Full Name
                child: Text(
                  customer.fullName.isNotEmpty ? customer.fullName : 'Unknown',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AdminAppColors.darkTextPrimary
                        : AdminAppColors.textPrimary,
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
            style: TextStyle(
              fontSize: 13.sp,
              color: isDark
                  ? AdminAppColors.darkTextSecondary
                  : const Color(0xFF6C6C80),
            ),
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
              color: isDark
                  ? AdminAppColors.darkTextPrimary
                  : AdminAppColors.textPrimary,
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
                color: AdminCustomersHelper.getStatusBgColor(
                  isBlocked,
                  isDeleted: customer.isDeleted,
                ),
                borderRadius: BorderRadius.circular(100.r),
              ),
              child: Text(
                AdminCustomersHelper.getStatusLabel(
                  isBlocked,
                  isDeleted: customer.isDeleted,
                ),
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                  color: AdminCustomersHelper.getStatusTextColor(
                    isBlocked,
                    isDeleted: customer.isDeleted,
                  ),
                ),
              ),
            ),
          ),
        ),

        // Action View Button Navigates to Details Page
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
