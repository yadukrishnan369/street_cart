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
        1: FlexColumnWidth(1.7), // PRODUCT
        2: FlexColumnWidth(1.7), // CUSTOMER
        3: FlexColumnWidth(1.0), // AMOUNT
        4: FlexColumnWidth(2.2), // STATUS
        5: FlexColumnWidth(1.3), // DATE
        6: FlexColumnWidth(0.9), // ACTIONS
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
          final date = DateFormatter.formatToReadableDate(order.createdAt);
          final returnedItems = AdminOrdersHelper.getReturnedItems(order);
          final cancelledItems = AdminOrdersHelper.getCancelledItems(order);
          final allItemsCancelled = AdminOrdersHelper.isAllItemsCancelled(
            order,
          );
          final allItemsReturned = AdminOrdersHelper.isAllItemsReturned(order);
          final allItemsCancelledOrReturned =
              AdminOrdersHelper.isAllItemsCancelledOrReturned(order);

          final String mainStatus;
          final String? secondaryStatusLabel;
          final Color? secondaryStatusBg;
          final Color? secondaryStatusText;

          if (allItemsCancelled) {
            mainStatus = 'cancelled';
            secondaryStatusLabel = null;
            secondaryStatusBg = null;
            secondaryStatusText = null;
          } else if (allItemsReturned) {
            mainStatus = order.returnStatus ?? 'returned';
            secondaryStatusLabel = null;
            secondaryStatusBg = null;
            secondaryStatusText = null;
          } else if (allItemsCancelledOrReturned) {
            mainStatus = 'returned';
            if (cancelledItems.isNotEmpty) {
              secondaryStatusLabel = '${cancelledItems.length} Cancelled';
              secondaryStatusBg = const Color(0xFFFCE8E6);
              secondaryStatusText = AdminAppColors.errorColor;
            } else {
              secondaryStatusLabel = null;
              secondaryStatusBg = null;
              secondaryStatusText = null;
            }
          } else {
            final String orderMainStatus = order.status;
            mainStatus = orderMainStatus;
            if (returnedItems.isNotEmpty) {
              final isRequested = returnedItems.any(
                (i) => i.returnStatus!.toLowerCase() == 'return_requested',
              );
              secondaryStatusLabel = isRequested
                  ? '${returnedItems.length} Requested'
                  : '${returnedItems.length} Returned';
              secondaryStatusBg = const Color(0xFFFFF3E0);
              secondaryStatusText = AdminAppColors.warningColor;
            } else if (cancelledItems.isNotEmpty) {
              secondaryStatusLabel = '${cancelledItems.length} Cancelled';
              secondaryStatusBg = const Color(0xFFFCE8E6);
              secondaryStatusText = AdminAppColors.errorColor;
            } else {
              secondaryStatusLabel = null;
              secondaryStatusBg = null;
              secondaryStatusText = null;
            }
          }

          final displayStatus = AdminOrdersHelper.getStatusLabel(mainStatus);
          final badgeBg = AdminOrdersHelper.getStatusBgColor(mainStatus);
          final badgeText = AdminOrdersHelper.getStatusTextColor(mainStatus);

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
                  child: Wrap(
                    spacing: 6.w,
                    runSpacing: 4.h,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: badgeBg,
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                        child: Text(
                          displayStatus,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                            color: badgeText,
                          ),
                        ),
                      ),
                      if (secondaryStatusLabel != null)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: secondaryStatusBg,
                            borderRadius: BorderRadius.circular(100.r),
                          ),
                          child: Text(
                            secondaryStatusLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                              color: secondaryStatusText,
                            ),
                          ),
                        ),
                    ],
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
