import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/core/utils/date_formatter.dart';
import 'package:street_cart/core/utils/price_utils.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/admin/orders/presentation/utils/admin_orders_helper.dart';

// Orders Table
class OrdersTable extends StatelessWidget {
  final List<OrderModel> orders;
  final Map<String, String> shopNames;
  final Map<String, String> customerNames;
  final int currentPage;
  final int perPage;

  const OrdersTable({
    super.key,
    required this.orders,
    required this.shopNames,
    required this.customerNames,
    required this.currentPage,
    required this.perPage,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1.2), // ORDER ID
        1: FlexColumnWidth(2.2), // PRODUCT
        2: FlexColumnWidth(1.5), // CUSTOMER
        3: FlexColumnWidth(1.2), // AMOUNT
        4: FlexColumnWidth(1.4), // STATUS
        5: FlexColumnWidth(1.4), // DATE
        6: FlexColumnWidth(1.0), // ACTIONS
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
          // Table Titles
          children: [
            _buildTableHeaderCell(context, 'ORDER ID'),
            _buildTableHeaderCell(context, 'PRODUCT'),
            _buildTableHeaderCell(context, 'CUSTOMER'),
            _buildTableHeaderCell(context, 'AMOUNT'),
            _buildTableHeaderCell(context, 'STATUS'),
            _buildTableHeaderCell(context, 'DATE'),
            _buildTableHeaderCell(context, 'ACTIONS'),
          ],
        ),
        ...orders.map((order) {
          final orderId = AdminOrdersHelper.getDisplayOrderId(order.id);
          final customer =
              customerNames[order.customerId] ?? order.deliveryAddress.fullName;
          final amount = '₹${PriceUtils.formatPrice(order.totalAmount)}';
          final returnStatus = (order.returnStatus ?? '').toLowerCase();
          final status = returnStatus.isNotEmpty
              ? order.returnStatus!
              : order.status;
          final date = DateFormatter.formatToReadableDate(order.createdAt);

          final hasItems = order.items.isNotEmpty;
          final firstItem = hasItems ? order.items.first : null;
          final moreCount = order.items.length - 1;

          return TableRow(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isDark
                      ? AdminAppColors.darkBorder
                      : const Color(0xFFF0EFF5),
                  width: 1.2,
                ),
              ),
            ),
            children: [
              // Order ID
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
                child: Text(
                  orderId,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AdminAppColors.darkTextPrimary
                        : AdminAppColors.textPrimary,
                  ),
                ),
              ),

              // Product Name
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
                child: firstItem != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            firstItem.productName,
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
                          if (moreCount > 0) ...[
                            SizedBox(height: 2.h),
                            Text(
                              '+$moreCount more product${moreCount > 1 ? 's' : ''}',
                              style: TextStyle(
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w600,
                                color: AdminAppColors.primaryColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      )
                    : Text(
                        'No Items',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: isDark
                              ? AdminAppColors.darkTextSecondary
                              : const Color(0xFF8A8A9E),
                        ),
                      ),
              ),

              // Customer
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Text(
                  customer,
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

              // Amount
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Text(
                  amount,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AdminAppColors.darkTextPrimary
                        : AdminAppColors.textPrimary,
                  ),
                ),
              ),

              // Status Badge
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: AdminOrdersHelper.getStatusBgColor(status),
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    child: Text(
                      AdminOrdersHelper.getStatusLabel(status),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        color: AdminOrdersHelper.getStatusTextColor(status),
                      ),
                    ),
                  ),
                ),
              ),

              // Date & Time
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      date,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: isDark
                            ? AdminAppColors.darkTextSecondary
                            : const Color(0xFF6C6C80),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      DateFormatter.formatToTime(order.createdAt),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: isDark
                            ? AdminAppColors.darkTextSecondary.withValues(
                                alpha: 0.7,
                              )
                            : const Color(0xFF8A8A9E),
                      ),
                    ),
                  ],
                ),
              ),

              // Actions
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () => context.push('/orders/${order.id}'),
                    child: Text(
                      'View',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.sp,
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
    );
  }

  Widget _buildTableHeaderCell(BuildContext context, String text) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
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
