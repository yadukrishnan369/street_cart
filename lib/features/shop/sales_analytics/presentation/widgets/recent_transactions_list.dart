import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/sales_analytics/presentation/pages/sales_transaction_details_page.dart';
import 'package:street_cart/features/shop/sales_analytics/presentation/utils/sales_analytics_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:street_cart/shared/widgets/product_image_placeholder.dart';
import 'package:street_cart/core/navigation/page_transitions.dart';
import 'package:street_cart/core/animation/staggered_animation.dart';

// Recent Transactions List
class RecentTransactionsList extends StatelessWidget {
  final List<AnalyticsTransactionItem> transactions;
  final String shopId;

  const RecentTransactionsList({
    super.key,
    required this.transactions,
    required this.shopId,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final displayList = transactions;
    // Transaction Empty State
    if (displayList.isEmpty) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          width: double.infinity,
          height: 300.h,
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: isDark ? ShopAppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isDark
                  ? ShopAppColors.darkBorder
                  : const Color(0xFFE2E8F0),
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.receipt_long_outlined, color: ShopAppColors.primary),
                SizedBox(height: 2.h),
                Text(
                  'No transactions found for this period.',
                  style: ShopAppTextStyles.bodyMedium.copyWith(
                    color: ShopAppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    // List of Transaction
    return AppStaggeredAnimation.limiter(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(bottom: 24.h),
        itemCount: displayList.length,
        separatorBuilder: (_, __) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          final tx = displayList[index];

          return AppStaggeredAnimation.staggeredList(
            index: index,
            child: InkWell(
              onTap: () {
                // Navigate to Shop Sales Transaction Details Page
                Navigator.push(
                  context,
                  AppPageTransitions.slide(
                    ShopSalesTransactionDetailsPage(
                      order: tx.order,
                      shopId: shopId,
                      transactionStatus: tx.status,
                    ),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: isDark ? ShopAppColors.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: isDark
                        ? ShopAppColors.darkBorder
                        : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Row(
                  children: [
                    // Product Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Container(
                        width: 48.r,
                        height: 48.r,
                        color: isDark
                            ? ShopAppColors.darkInputBackground
                            : const Color(0xFFF1F5F9),
                        child: tx.productImage.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: tx.productImage,
                                fit: BoxFit.cover,
                                errorWidget: (_, __, ___) =>
                                    ProductImagePlaceholder(
                                      width: 72.w,
                                      height: 72.w,
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                              )
                            : ProductImagePlaceholder(
                                width: 72.w,
                                height: 72.w,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product Name
                          Text(
                            tx.productName,
                            style: ShopAppTextStyles.bodyMediumBold.copyWith(
                              color: isDark
                                  ? ShopAppColors.darkTextPrimary
                                  : ShopAppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.h),
                          // Order ID and Date
                          Text(
                            SalesAnalyticsHelper.formatTransactionHeader(
                              tx.orderId,
                              tx.date,
                            ),
                            style: ShopAppTextStyles.caption.copyWith(
                              color: isDark
                                  ? ShopAppColors.darkTextSecondary
                                  : ShopAppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      // Transaction Amount
                      children: [
                        Text(
                          '₹${tx.amount.toStringAsFixed(0)}',
                          style: ShopAppTextStyles.bodyMediumBold.copyWith(
                            color: ShopAppColors.primary,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        // Status Badge
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: SalesAnalyticsHelper.getStatusBgColor(
                              tx.status,
                            ),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            tx.status.toUpperCase(),
                            style: ShopAppTextStyles.caption.copyWith(
                              color: SalesAnalyticsHelper.getStatusTextColor(
                                tx.status,
                              ),
                              fontWeight: FontWeight.w800,
                              fontSize: 9.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
