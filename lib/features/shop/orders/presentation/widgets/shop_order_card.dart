import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/shop/orders/presentation/utils/shop_orders_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:street_cart/shared/widgets/product_image_placeholder.dart';
import 'package:street_cart/features/shop/orders/presentation/utils/shop_order_status.dart';

class ShopOrderCard extends StatelessWidget {
  final OrderModel order;
  final String shopId;
  final Function(String nextStatus) onUpdateStatus;

  const ShopOrderCard({
    super.key,
    required this.order,
    required this.shopId,
    required this.onUpdateStatus,
  });

  @override
  Widget build(BuildContext context) {
    if (order.items.isEmpty) return const SizedBox.shrink();

    // Filter items in the order that belong to this shop
    final shopItems = order.items
        .where((item) => item.shopId == shopId)
        .toList();
    if (shopItems.isEmpty) return const SizedBox.shrink();

    final firstItem = shopItems.first;
    final totalAmount = shopItems.fold<double>(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );

    final orderIdPrefix = order.id.substring(0, order.id.length.clamp(0, 5));
    final timeAgo = ShopOrdersHelper.getRelativeTimeAgo(order.createdAt);
    final paymentMethodLabel = ShopOrdersHelper.getDisplayPaymentMethod(
      order.paymentMethod,
    );
    final nextStatusLabel = ShopOrdersHelper.getNextStatusActionLabel(
      ShopOrderStatus.fromString(order.status),
    );
    final nextStatus = ShopOrdersHelper.getNextStatus(
      ShopOrderStatus.fromString(order.status),
    );

    final bool isCOD = paymentMethodLabel == 'COD';
    final badgeColor = isCOD
        ? const Color(0xFF0F766E)
        : const Color(0xFF5E5CE6);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
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
              imageUrl: firstItem.productImage,
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
                    Text(
                      'ORDER #$orderIdPrefix'.toUpperCase(),
                      style: TextStyle(
                        color: const Color(0xFF0F766E),
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                      ),
                    ),
                    Text(
                      timeAgo,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Text(
                  shopItems.length > 1
                      ? '${firstItem.productName} + ${shopItems.length - 1} more'
                      : firstItem.productName,
                  style: TextStyle(
                    color: ShopAppColors.textPrimary,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  order.deliveryAddress.fullName,
                  style: TextStyle(color: Colors.grey[500], fontSize: 13.sp),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '₹${totalAmount.toStringAsFixed(0)}',
                      style: TextStyle(
                        color: ShopAppColors.textPrimary,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (nextStatusLabel != null &&
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
                          ],
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: badgeColor.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: badgeColor.withOpacity(0.15),
                              ),
                            ),
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
