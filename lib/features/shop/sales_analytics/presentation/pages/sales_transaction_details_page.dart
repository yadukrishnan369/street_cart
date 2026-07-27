import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/shop/sales_analytics/presentation/utils/sales_analytics_helper.dart';
import 'package:street_cart/features/shop/sales_analytics/presentation/widgets/transaction_customer_info.dart';
import 'package:street_cart/features/shop/sales_analytics/presentation/widgets/transaction_item_summary.dart';
import 'package:street_cart/features/shop/sales_analytics/presentation/widgets/transaction_status_banner.dart';
import 'package:street_cart/features/shop/sales_analytics/presentation/widgets/shimmer/sales_transaction_details_shimmer.dart';

// Shop Sales Transaction Details Page
class ShopSalesTransactionDetailsPage extends StatelessWidget {
  final OrderModel order;
  final String shopId;

  const ShopSalesTransactionDetailsPage({
    super.key,
    required this.order,
    required this.shopId,
  });

  @override
  Widget build(BuildContext context) {
    final orderIdPrefix = SalesAnalyticsHelper.formatTransID(order.id);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        // Page Header
        title: Text(
          'Transaction #$orderIdPrefix',
          style: TextStyle(
            color: ShopAppColors.textPrimary,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<void>(
        future: Future.delayed(const Duration(milliseconds: 600)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SalesTransactionDetailsShimmer();
          }
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Transaction Status Banner
                TransactionStatusBanner(order: order),
                SizedBox(height: 12.h),
                //Transaction Customer Info
                TransactionCustomerInfo(order: order),
                SizedBox(height: 12.h),
                // Transaction Item Summary
                TransactionItemSummary(order: order, shopId: shopId),
                SizedBox(height: 30.h),
              ],
            ),
          );
        },
      ),
    );
  }
}
