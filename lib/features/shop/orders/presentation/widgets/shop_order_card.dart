import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/shop/orders/presentation/utils/shop_orders_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:street_cart/shared/widgets/product_image_placeholder.dart';
import 'package:street_cart/features/shop/orders/presentation/utils/shop_order_status.dart';
import 'package:street_cart/core/utils/price_utils.dart';

// Shop Order Card
class ShopOrderCard extends StatelessWidget {
  final OrderModel order;
  final String shopId;
  final bool isCancelledView;
  final bool isReturnedView;
  final Function(String nextStatus) onUpdateStatus;

  const ShopOrderCard({
    super.key,
    required this.order,
    required this.shopId,
    this.isCancelledView = false,
    this.isReturnedView = false,
    required this.onUpdateStatus,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Get orders Data
    final cardData = ShopOrdersHelper.getShopOrderCardData(
      order: order,
      shopId: shopId,
      isCancelledView: isCancelledView,
      isReturnedView: isReturnedView,
    );
    if (cardData.isEmpty) return const SizedBox.shrink();

    final displayItem = cardData['firstItem'] as OrderItemModel;
    final totalAmount = cardData['totalAmount'] as double;
    final productNameText =
        cardData['productNameText'] as String? ?? displayItem.productName;

    final orderIdPrefix = ShopOrdersHelper.getOrderIdPrefix(order.id);
    final relevantTime = ShopOrdersHelper.getOrderTimeForStatus(order);
    final timeAgo = ShopOrdersHelper.getRelativeTimeAgo(relevantTime);
    final paymentMethodLabel = ShopOrdersHelper.getDisplayPaymentMethod(
      order.paymentMethod,
    );
    final nextStatusLabel = ShopOrdersHelper.getNextStatusActionLabel(
      ShopOrderStatus.fromString(order.status),
    );
    final nextStatus = ShopOrdersHelper.getNextStatus(
      ShopOrderStatus.fromString(order.status),
    );

    final rStatus = order.returnStatus;
    final hasReturn = isReturnedView && rStatus != null && rStatus.isNotEmpty;
    String? returnStatusLabel;
    Color returnStatusColor = Colors.grey;
    // Return Statuses
    if (hasReturn) {
      if (rStatus.toLowerCase() == 'return_requested') {
        returnStatusLabel = 'Return Requested';
        returnStatusColor = ShopAppColors.error;
      } else if (rStatus.toLowerCase() == 'return_confirmed') {
        returnStatusLabel = 'Return Confirmed';
        returnStatusColor = ShopAppColors.primary;
      } else if (rStatus.toLowerCase() == 'return_picked') {
        if (order.refundStatus == 'refunded') {
          returnStatusLabel = 'Refunded';
          returnStatusColor = ShopAppColors.success;
        } else {
          returnStatusLabel = 'Pending Refund';
          returnStatusColor = ShopAppColors.warning;
        }
      }
    }

    final bool isCOD = paymentMethodLabel == 'COD';
    final badgeColor = isCOD ? ShopAppColors.warning : ShopAppColors.success;
    final bool isRefundPending =
        !isCOD &&
        (order.refundStatus == 'pending' ||
            order.items.any(
              (item) =>
                  item.shopId == shopId &&
                  item.status == 'cancelled' &&
                  item.refundStatus == 'pending',
            ));
    final bool isRefundCompleted =
        !isCOD &&
        !isRefundPending &&
        (order.refundStatus == 'refunded' ||
            order.items.any(
              (item) =>
                  item.shopId == shopId &&
                  item.status == 'cancelled' &&
                  item.refundStatus == 'refunded',
            ));

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? ShopAppColors.darkSurface : Colors.white,
        border: Border.all(
          color: isDark ? ShopAppColors.darkBorder : Colors.grey[200]!,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: CachedNetworkImage(
              imageUrl: displayItem.productImage,
              width: 72.w,
              height: 72.w,
              fit: BoxFit.cover,
              placeholder: (context, url) => ProductImagePlaceholder(
                width: 72.w,
                height: 72.w,
                borderRadius: BorderRadius.circular(12.r),
              ),
              errorWidget: (context, url, error) => ProductImagePlaceholder(
                width: 72.w,
                height: 72.w,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
          SizedBox(width: 16.w),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Order ID
                    Text(
                      'ORDER #$orderIdPrefix'.toUpperCase(),
                      style: TextStyle(
                        color: ShopAppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                      ),
                    ),
                    // Time
                    Text(
                      timeAgo,
                      style: TextStyle(
                        color: isDark
                            ? ShopAppColors.darkTextSecondary
                            : Colors.grey[400],
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                // Product name
                Text(
                  productNameText,
                  style: TextStyle(
                    color: isDark
                        ? ShopAppColors.darkTextPrimary
                        : ShopAppColors.textPrimary,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                // Order Delivery Address
                Text(
                  order.deliveryAddress.fullName,
                  style: TextStyle(
                    color: isDark
                        ? ShopAppColors.darkTextSecondary
                        : Colors.grey[500],
                    fontSize: 13.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Total Amount
                    Text(
                      '₹${PriceUtils.formatPrice(totalAmount)}',
                      style: TextStyle(
                        color: isDark
                            ? ShopAppColors.darkTextPrimary
                            : ShopAppColors.textPrimary,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Return Status Label
                          if (hasReturn && returnStatusLabel != null) ...[
                            Flexible(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: returnStatusColor.withValues(
                                    alpha: 0.08,
                                  ),
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: returnStatusColor.withValues(
                                      alpha: 0.15,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  returnStatusLabel,
                                  style: TextStyle(
                                    color: returnStatusColor,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ] else if (order.status.toLowerCase() ==
                                  'cancelled' ||
                              isCancelledView) ...[
                            if (isRefundPending) ...[
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: ShopAppColors.warning.withValues(
                                    alpha: 0.08,
                                  ),
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: ShopAppColors.warning.withValues(
                                      alpha: 0.15,
                                    ),
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
                            ] else if (isRefundCompleted) ...[
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: ShopAppColors.success.withValues(
                                    alpha: 0.08,
                                  ),
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: ShopAppColors.success.withValues(
                                      alpha: 0.15,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'Refunded',
                                  style: TextStyle(
                                    color: ShopAppColors.success,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ] else ...[
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: ShopAppColors.error.withValues(
                                    alpha: 0.08,
                                  ),
                                  borderRadius: BorderRadius.circular(12.r),
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
                            ],
                          ] else if (order.status.toLowerCase() ==
                              'delivered') ...[
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: ShopAppColors.success.withValues(
                                  alpha: 0.08,
                                ),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: ShopAppColors.success.withValues(
                                    alpha: 0.15,
                                  ),
                                ),
                              ),
                              child: Text(
                                'Completed',
                                style: TextStyle(
                                  color: ShopAppColors.success,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ] else if (nextStatusLabel != null &&
                              nextStatus != null) ...[
                            Flexible(
                              child: Text(
                                nextStatusLabel,
                                style: TextStyle(
                                  color: ShopAppColors.primary,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            // Payment Method Label
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: badgeColor.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: badgeColor.withValues(alpha: 0.15),
                                ),
                              ),
                              // Selected Payment Method Label
                              child: Text(
                                paymentMethodLabel,
                                style: TextStyle(
                                  color: badgeColor,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
