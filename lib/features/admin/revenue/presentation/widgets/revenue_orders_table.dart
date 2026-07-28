import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:street_cart/core/router/admin/route_paths.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/core/utils/price_utils.dart';
import 'package:street_cart/features/admin/customers/data/models/customer_model.dart';
import 'package:street_cart/features/admin/revenue/presentation/utils/admin_revenue_helper.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';

// Revenue Orders Table
class RevenueOrdersTable extends StatelessWidget {
  final List<OrderModel> orders;
  final List<ShopProfileModel> shops;
  final List<CustomerModel> customers;

  const RevenueOrdersTable({
    super.key,
    required this.orders,
    required this.shops,
    required this.customers,
  });

  @override
  Widget build(BuildContext context) {
    // Empty State
    if (orders.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 64.h),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.bar_chart_outlined,
                size: 56.sp,
                color: AdminAppColors.primaryColor,
              ),
              SizedBox(height: 16.h),
              Text(
                'No revenue transactions found',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: AdminAppColors.primaryColor,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Table(
      // Table Rows
      columnWidths: const {
        0: FlexColumnWidth(1.6), // Order ID
        1: FlexColumnWidth(1.4), // Date
        2: FlexColumnWidth(2.0), // Customer Name
        3: FlexColumnWidth(2.0), // Shop Name
        4: FlexColumnWidth(1.6), // Amount
        5: FlexColumnWidth(1.4), // Commission Amount
        6: FlexColumnWidth(1.0), // View Action
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
          // Table Titles
          children: [
            _headerCell('ORDER ID'),
            _headerCell('DATE'),
            _headerCell('CUSTOMER'),
            _headerCell('SHOP'),
            _headerCell('AMOUNT'),
            _headerCell('COMMISSION'),
            _headerCell('ACTION'),
          ],
        ),
        ...orders.map((order) => _buildRow(context, order)),
      ],
    );
  }

  Widget _headerCell(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
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

  TableRow _buildRow(BuildContext context, OrderModel order) {
    final commission = AdminRevenueHelper.computeOrderCommission(order);
    final shopName = AdminRevenueHelper.getShopName(order, shops);
    final customerName = AdminRevenueHelper.getCustomerName(order, customers);

    return TableRow(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFF0EFF5), width: 1.0),
        ),
      ),
      children: [
        // Order ID
        _cell(
          Text(
            AdminRevenueHelper.formatOrderId(order.id),
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: AdminAppColors.primaryColor,
            ),
          ),
        ),
        // Order Placed Date
        _cell(
          Text(
            AdminRevenueHelper.formatDate(order.createdAt),
            style: TextStyle(fontSize: 12.sp, color: const Color(0xFF6C6C80)),
          ),
        ),

        // Customer Name
        _cell(
          Text(
            customerName,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: AdminAppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // Shop Name
        _cell(
          Text(
            shopName,
            style: TextStyle(
              fontSize: 13.sp,
              color: AdminAppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // Amount
        _cell(
          Text(
            '₹${PriceUtils.formatPrice(order.totalAmount)}',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: AdminAppColors.textPrimary,
            ),
          ),
        ),
        // Commission Amount
        _cell(
          Text(
            '₹${PriceUtils.formatPrice(commission)}',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: AdminAppColors.primaryColor,
            ),
          ),
        ),
        // View Order Details
        _cell(
          InkWell(
            onTap: () {
              context.push(RoutePaths.orderDetails.replaceAll(':id', order.id));
            },
            child: Text(
              'View',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                color: AdminAppColors.primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _cell(Widget child) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: child,
    );
  }
}
