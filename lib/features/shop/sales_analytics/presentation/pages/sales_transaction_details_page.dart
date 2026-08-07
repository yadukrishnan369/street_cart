import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/shop/sales_analytics/presentation/utils/sales_analytics_helper.dart';
import 'package:street_cart/features/shop/sales_analytics/presentation/widgets/transaction_customer_info.dart';
import 'package:street_cart/features/shop/sales_analytics/presentation/widgets/transaction_item_summary.dart';
import 'package:street_cart/features/shop/sales_analytics/presentation/widgets/transaction_status_banner.dart';
import 'package:street_cart/features/shop/sales_analytics/presentation/widgets/shimmer/sales_transaction_details_shimmer.dart';
import 'package:street_cart/shared/widgets/app_error_view.dart';

// Shop Sales Transaction Details Page
class ShopSalesTransactionDetailsPage extends StatelessWidget {
  final OrderModel order;
  final String shopId;
  final String? transactionStatus;

  const ShopSalesTransactionDetailsPage({
    super.key,
    required this.order,
    required this.shopId,
    this.transactionStatus,
  });

  @override
  Widget build(BuildContext context) {
    final orderIdPrefix = SalesAnalyticsHelper.formatTransID(order.id);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? ShopAppColors.darkBackground
          : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: isDark ? ShopAppColors.darkBackground : Colors.white,
        centerTitle: true,
        leading: BackButton(
          color: isDark
              ? ShopAppColors.darkTextPrimary
              : ShopAppColors.textPrimary,
        ),
        elevation: isDark ? null : 1.5,
        shape: Border(
          bottom: BorderSide(
            color: isDark
                ? ShopAppColors.darkBorder
                : ShopAppColors.border.withValues(alpha: 1.0),
            width: 0.5,
          ),
        ),
        // Page Header
        title: Text(
          'Transaction #$orderIdPrefix',
          style: TextStyle(
            color: isDark
                ? ShopAppColors.darkTextPrimary
                : ShopAppColors.textPrimary,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<void>(
        future: Future.delayed(const Duration(milliseconds: 600)),
        builder: (context, snapshot) {
          // Loading shimmer
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SalesTransactionDetailsShimmer();
          }
          // Error view
          if (snapshot.hasError) {
            return AppErrorView(
              message: snapshot.error.toString(),
              onRetry: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => ShopSalesTransactionDetailsPage(
                    order: order,
                    shopId: shopId,
                  ),
                ),
              ),
            );
          }
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Transaction Status Banner
                TransactionStatusBanner(
                  order: order,
                  transactionStatus: transactionStatus,
                ),
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
