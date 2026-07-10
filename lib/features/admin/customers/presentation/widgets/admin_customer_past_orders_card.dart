import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/core/utils/price_utils.dart';
import 'package:street_cart/core/utils/date_formatter.dart';
import 'package:street_cart/features/admin/orders/presentation/utils/admin_orders_helper.dart';
import 'package:street_cart/shared/widgets/admin_pagination.dart';

class AdminCustomerPastOrdersCard extends StatefulWidget {
  final List<OrderModel> orders;

  const AdminCustomerPastOrdersCard({super.key, required this.orders});

  @override
  State<AdminCustomerPastOrdersCard> createState() =>
      _AdminCustomerPastOrdersCardState();
}

class _AdminCustomerPastOrdersCardState
    extends State<AdminCustomerPastOrdersCard> {
  int _currentPage = 1;
  static const int _perPage = 5;

  @override
  Widget build(BuildContext context) {
    final totalPages = (widget.orders.length / _perPage).ceil().clamp(
      1,
      999999,
    );
    final paginatedOrders = widget.orders
        .skip((_currentPage - 1) * _perPage)
        .take(_perPage)
        .toList();

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
          if (widget.orders.isEmpty)
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
                  decoration: const BoxDecoration(
                    color: Color(0xFFF4F5F7),
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFE8E7ED), width: 1.5),
                    ),
                  ),
                  children: [
                    _buildTableHeaderCell('ORDER ID'),
                    _buildTableHeaderCell('PRODUCTS'),
                    _buildTableHeaderCell('DATE'),
                    _buildTableHeaderCell('AMOUNT'),
                    _buildTableHeaderCell('STATUS'),
                    _buildTableHeaderCell('ACTIONS'),
                  ],
                ),
                ...paginatedOrders.map((order) {
                  final status = order.status;
                  final displayStatus = AdminOrdersHelper.getStatusLabel(
                    status,
                  );
                  final badgeBg = AdminOrdersHelper.getStatusBgColor(status);
                  final badgeText = AdminOrdersHelper.getStatusTextColor(
                    status,
                  );
                  final displayId = AdminOrdersHelper.getDisplayOrderId(
                    order.id,
                  );
                  final dateStr = DateFormatter.formatToReadableDate(
                    order.createdAt,
                  );
                  final amountStr =
                      '₹${PriceUtils.formatPrice(order.totalAmount)}';

                  // If there is more than 1 product, show the first name and the remaining count
                  String productNamesDisplay = '';
                  if (order.items.isNotEmpty) {
                    final firstProduct = order.items.first.productName;
                    if (order.items.length > 1) {
                      productNamesDisplay =
                          '$firstProduct + ${order.items.length - 1} more product';
                    } else {
                      productNamesDisplay = firstProduct;
                    }
                  } else {
                    productNamesDisplay = 'No Products';
                  }

                  return TableRow(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xFFF0EFF5),
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
                          displayId,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: AdminAppColors.primaryColor,
                          ),
                        ),
                      ),
                      // Products
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Text(
                          productNamesDisplay,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: const Color(0xFF1E1E2F),
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
                            color: const Color(0xFF6C6C80),
                          ),
                        ),
                      ),
                      // Amount
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Text(
                          amountStr,
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
                      // Actions
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
            if (totalPages > 1) ...[
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: AdminPagination(
                  currentPage: _currentPage,
                  totalPages: totalPages,
                  onPageChanged: (page) {
                    setState(() {
                      _currentPage = page;
                    });
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
