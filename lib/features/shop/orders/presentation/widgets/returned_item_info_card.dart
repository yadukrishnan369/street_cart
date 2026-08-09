import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/utils/price_utils.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/shared/widgets/product_image_placeholder.dart';
import 'package:street_cart/features/shop/orders/presentation/utils/shop_orders_helper.dart';

// Returned Item Info Card
class ReturnedItemInfoCard extends StatelessWidget {
  final OrderModel order;
  final String shopId;

  const ReturnedItemInfoCard({
    super.key,
    required this.order,
    required this.shopId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Get returned item Data
    final returnedData = ShopOrdersHelper.getReturnedItemCardData(
      order: order,
      shopId: shopId,
    );
    if (returnedData.isEmpty) return const SizedBox.shrink();

    final returnedItems = returnedData['returnedItems'] as List<OrderItemModel>;
    final paymentLabel = returnedData['paymentLabel'] as String;
    final badgeColor = returnedData['badgeColor'] as Color;
    final totalAmount = returnedData['totalAmount'] as double;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Title
              Text(
                'RETURNED ITEM${returnedItems.length > 1 ? "S" : ""}',
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
          width: double.infinity,
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
              ...List.generate(returnedItems.length, (index) {
                final item = returnedItems[index];
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
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
                                // Product Name
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.productName,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                          color: isDark
                                              ? ShopAppColors.darkTextPrimary
                                              : ShopAppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                    // Product Status Badge
                                    FutureBuilder<Map<String, bool>>(
                                      future:
                                          ShopOrdersHelper.checkProductStatus(
                                            item.productId,
                                          ),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                                ConnectionState.done &&
                                            snapshot.hasData) {
                                          final data = snapshot.data!;
                                          final isDeletedOrInactive =
                                              data['isDeletedOrInactive'] ??
                                              false;
                                          final disabledByAdmin =
                                              data['disabledByAdmin'] ?? false;

                                          if (isDeletedOrInactive) {
                                            return Container(
                                              margin: EdgeInsets.only(
                                                left: 8.w,
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 8.w,
                                                vertical: 2.h,
                                              ),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFFDE8E8),
                                                borderRadius:
                                                    BorderRadius.circular(6.r),
                                                border: Border.all(
                                                  color: const Color(
                                                    0xFFFBD5D5,
                                                  ),
                                                ),
                                              ),
                                              child: Text(
                                                disabledByAdmin
                                                    ? 'Disabled by Admin'
                                                    : 'Deleted / Inactive',
                                                style: TextStyle(
                                                  color: ShopAppColors.error,
                                                  fontSize: 9.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            );
                                          }
                                        }
                                        return const SizedBox.shrink();
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Selected Size and Color
                                    Text(
                                      '${item.selectedSize ?? "Default Size"}, ${item.selectedColor ?? "Default Color"}',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: isDark
                                            ? ShopAppColors.darkTextSecondary
                                            : Colors.grey[500],
                                      ),
                                    ),
                                    if (item.returnStatus != null &&
                                        item.returnStatus!.isNotEmpty)
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.w,
                                          vertical: 2.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              item.returnStatus ==
                                                      'return_picked' ||
                                                  item.returnStatus ==
                                                      'returned'
                                              ? (isDark
                                                    ? const Color(
                                                        0xFF1B5E20,
                                                      ).withValues(alpha: 0.3)
                                                    : const Color(0xFFE8F5E9))
                                              : item.returnStatus ==
                                                    'return_confirmed'
                                              ? (isDark
                                                    ? const Color(
                                                        0xFF0D47A1,
                                                      ).withValues(alpha: 0.3)
                                                    : const Color(0xFFE3F2FD))
                                              : (isDark
                                                    ? const Color(
                                                        0xFFE65100,
                                                      ).withValues(alpha: 0.3)
                                                    : const Color(0xFFFFF3E0)),
                                          borderRadius: BorderRadius.circular(
                                            6.r,
                                          ),
                                        ),
                                        // Return Status
                                        child: Text(
                                          item.returnStatus ==
                                                      'return_picked' ||
                                                  item.returnStatus ==
                                                      'returned'
                                              ? 'Picked'
                                              : item.returnStatus ==
                                                    'return_confirmed'
                                              ? 'Confirmed'
                                              : 'Requested',
                                          style: TextStyle(
                                            color:
                                                item.returnStatus ==
                                                        'return_picked' ||
                                                    item.returnStatus ==
                                                        'returned'
                                                ? ShopAppColors.success
                                                : item.returnStatus ==
                                                      'return_confirmed'
                                                ? Colors.blue[700]
                                                : ShopAppColors.warning,
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                SizedBox(height: 6.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Price
                                    Text(
                                      '₹${PriceUtils.formatPrice(item.price)}',
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w800,
                                        color: ShopAppColors.primary,
                                      ),
                                    ),
                                    // Quantity
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
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (index < returnedItems.length - 1)
                      Divider(
                        height: 1.0,
                        thickness: 0.2,
                        color: isDark
                            ? ShopAppColors.darkBorder
                            : Colors.grey[300],
                      ),
                  ],
                );
              }),
              Divider(
                height: 1.0,
                thickness: 0.2,
                color: isDark ? ShopAppColors.darkBorder : Colors.grey[300],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title
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
                    // Item Amount
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
              Divider(
                height: 1.0,
                thickness: 0.2,
                color: isDark ? ShopAppColors.darkBorder : Colors.grey[300],
              ),
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
                    // Title
                    Text(
                      'Total Amount',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: isDark
                            ? ShopAppColors.darkTextSecondary
                            : Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Total Amount
                    Text(
                      '₹${PriceUtils.formatPrice(totalAmount)}',
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
