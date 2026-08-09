import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/shop/orders/presentation/pages/shop_order_product_details_page.dart';
import 'package:street_cart/features/shop/orders/presentation/utils/shop_orders_helper.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:street_cart/shared/widgets/product_image_placeholder.dart';
import 'package:street_cart/core/utils/price_utils.dart';
import 'package:street_cart/features/shop/orders/presentation/bloc/shop_orders_bloc.dart';

// Item Summary Card
class ItemSummaryCard extends StatelessWidget {
  final OrderModel order;
  final String shopId;
  final bool isCancelledView;
  final bool isReturnedView;

  const ItemSummaryCard({
    super.key,
    required this.order,
    required this.shopId,
    this.isCancelledView = false,
    this.isReturnedView = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final summaryData = ShopOrdersHelper.getItemSummaryCardData(
      order: order,
      shopId: shopId,
      isCancelledView: isCancelledView,
      isReturnedView: isReturnedView,
    );
    if (summaryData.isEmpty) return const SizedBox.shrink();

    final shopItems = summaryData['shopItems'] as List<OrderItemModel>;
    final totalAmount = summaryData['totalAmount'] as double;
    final commission = summaryData['commission'] as double;
    final commissionPercentage = summaryData['commissionPercentage'] as double;
    final finalEarnings = summaryData['finalEarnings'] as double;
    final paymentLabel = summaryData['paymentLabel'] as String;
    final badgeColor = paymentLabel == 'COD'
        ? ShopAppColors.warning
        : ShopAppColors.success;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Card Title
              Text(
                'ITEM SUMMARY',
                style: TextStyle(
                  color: ShopAppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13.sp,
                  letterSpacing: 0.5,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: badgeColor.withValues(alpha: 0.15)),
                ),
                // Payment Label
                child: Text(
                  paymentLabel,
                  style: TextStyle(
                    color: badgeColor,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),

        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: isDark ? ShopAppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: isDark ? ShopAppColors.darkBorder : Colors.grey[200]!,
            ),
          ),
          child: Column(
            children: [
              // Items List
              ...shopItems.map(
                (item) => InkWell(
                  onTap: () {
                    // Navigate to Shop Order Product Details Page
                    final ordersBloc = context.read<ShopOrdersBloc>();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: ordersBloc,
                          child: ShopOrderProductDetailsPage(item: item),
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          // Product Image
                          child: CachedNetworkImage(
                            imageUrl: item.productImage,
                            width: 60.w,
                            height: 60.w,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                ProductImagePlaceholder(
                                  width: 60.w,
                                  height: 60.w,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                            errorWidget: (context, url, error) =>
                                ProductImagePlaceholder(
                                  width: 60.w,
                                  height: 60.w,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Product name
                              Text(
                                item.productName,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? ShopAppColors.darkTextPrimary
                                      : ShopAppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              // Product Selected Size and Color
                              Text(
                                '${item.selectedSize ?? "Default Size"}, ${item.selectedColor ?? "Default Color"}',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: isDark
                                      ? ShopAppColors.darkTextSecondary
                                      : Colors.grey[500],
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Item Price
                                  Text(
                                    '₹${PriceUtils.formatPrice(item.price)}',
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w800,
                                      color: ShopAppColors.primary,
                                    ),
                                  ),
                                  // Item Quantity
                                  Text(
                                    'Qty: ${item.quantity.toString().padLeft(2, '0')}',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: isDark
                                          ? ShopAppColors.darkTextSecondary
                                          : Colors.grey[500],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              // Cancelled order labels
                              if (item.status == 'cancelled') ...[
                                SizedBox(height: 6.h),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10.w,
                                        vertical: 4.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: ShopAppColors.error.withValues(
                                          alpha: 0.08,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                        border: Border.all(
                                          color: ShopAppColors.error.withValues(
                                            alpha: 0.15,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        'Cancelled',
                                        style: TextStyle(
                                          color: ShopAppColors.error,
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    if (item.refundStatus == 'pending') ...[
                                      SizedBox(width: 8.w),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10.w,
                                          vertical: 4.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: ShopAppColors.warning
                                              .withValues(alpha: 0.08),
                                          borderRadius: BorderRadius.circular(
                                            12.r,
                                          ),
                                          border: Border.all(
                                            color: ShopAppColors.warning
                                                .withValues(alpha: 0.15),
                                          ),
                                        ),
                                        child: Text(
                                          'Refund Pending',
                                          style: TextStyle(
                                            color: ShopAppColors.warning,
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Divider(
                height: 1.0,
                thickness: 0.2,
                color: isDark ? ShopAppColors.darkBorder : Colors.grey[300],
              ),

              // Items Total
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Items Total',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: isDark
                            ? ShopAppColors.darkTextSecondary
                            : Colors.grey[500],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '₹${PriceUtils.formatPrice(totalAmount)}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: isDark
                            ? ShopAppColors.darkTextPrimary
                            : ShopAppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // Commission Amount
              if (order.status.toLowerCase() != 'cancelled' &&
                  !isCancelledView) ...[
                Divider(
                  height: 1.0,
                  thickness: 0.2,
                  color: isDark ? ShopAppColors.darkBorder : Colors.grey[300],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Commission (${commissionPercentage.toStringAsFixed(0)}%)',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: isDark
                              ? ShopAppColors.darkTextSecondary
                              : Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '₹-${PriceUtils.formatPrice(commission)}',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: isDark
                              ? ShopAppColors.darkTextPrimary
                              : ShopAppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              Divider(
                height: 1.0,
                thickness: 0.2,
                color: isDark ? ShopAppColors.darkBorder : Colors.grey[300],
              ),

              // Total Amount
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: isDark
                      ? ShopAppColors.darkBackground
                      : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20.r),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      (order.status.toLowerCase() == 'cancelled' ||
                              isCancelledView)
                          ? 'Total Amount'
                          : 'Total Amount (Exclude comm)',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: isDark
                            ? ShopAppColors.darkTextSecondary
                            : Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '₹${PriceUtils.formatPrice((order.status.toLowerCase() == 'cancelled' || isCancelledView) ? totalAmount : finalEarnings)}',
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: ShopAppColors.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
