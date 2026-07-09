import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/shop/orders/presentation/pages/shop_order_product_details_page.dart';
import 'package:street_cart/features/shop/orders/presentation/utils/shop_orders_helper.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:street_cart/shared/widgets/product_image_placeholder.dart';

class ItemSummaryCard extends StatelessWidget {
  final OrderModel order;
  final String shopId;

  const ItemSummaryCard({super.key, required this.order, required this.shopId});

  @override
  Widget build(BuildContext context) {
    final shopItems = order.items
        .where((item) => item.shopId == shopId)
        .toList();
    if (shopItems.isEmpty) return const SizedBox.shrink();

    final totalAmount = shopItems.fold<double>(
      0.0,
      (sum, item) => sum + (item.price * item.quantity),
    );

    // Calculate Street cart commission
    final commission = shopItems.fold<double>(
      0.0,
      (sum, item) => sum + item.adminCommission,
    );
    final commissionPercentage = totalAmount > 0
        ? (commission / totalAmount) * 100
        : 0.0;
    final finalEarnings = totalAmount - commission;
    final paymentLabel = ShopOrdersHelper.getDisplayPaymentMethod(
      order.paymentMethod,
    );
    final badgeColor = paymentLabel == 'COD'
        ? const Color(0xFFF2A900)
        : const Color(0xFF10B981);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
                  color: badgeColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: badgeColor.withOpacity(0.15)),
                ),
                child: Text(
                  paymentLabel == 'COD' ? 'COD' : '${paymentLabel}',
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: [
              // Items List
              ...shopItems.map(
                (item) => InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ShopOrderProductDetailsPage(item: item),
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
                              Text(
                                item.productName,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1E293B),
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                '${item.selectedSize ?? "Default Size"}, ${item.selectedColor ?? "Default Color"}',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey[500],
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '₹${item.price.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w800,
                                      color: ShopAppColors.primary,
                                    ),
                                  ),
                                  Text(
                                    'Qty: ${item.quantity.toString().padLeft(2, '0')}',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey[500],
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
                ),
              ),

              const Divider(height: 1.0, thickness: 0.2),

              // Items Total Row
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Items Total',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '₹${totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xFF1E293B),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1.0, thickness: 0.2),

              // Commission Row
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Commission (${commissionPercentage.toStringAsFixed(0)}%)',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '₹-${commission.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xFF1E293B),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1.0, thickness: 0.2),

              // Total Row
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20.r),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Amount (Exclude comm)',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '₹${finalEarnings.toStringAsFixed(2)}',
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
