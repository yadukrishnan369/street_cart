import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/core/utils/price_utils.dart';
import 'package:street_cart/features/shop/home/presentation/bloc/shop_home_bloc.dart';
import 'package:street_cart/features/shop/home/presentation/bloc/shop_home_state.dart';
import 'package:street_cart/features/shop/orders/presentation/pages/shop_orders_page.dart';
import 'package:street_cart/features/shop/orders/presentation/pages/shop_order_details_page.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/shop/orders/presentation/utils/shop_orders_helper.dart';
import 'package:street_cart/features/shop/orders/presentation/utils/shop_order_status.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/shop/orders/presentation/bloc/shop_orders_bloc.dart';
import 'package:street_cart/features/shop/orders/presentation/bloc/shop_orders_event.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:street_cart/shared/widgets/product_image_placeholder.dart';
import 'empty_recent_orders_view.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';

class RecentOrdersList extends StatelessWidget {
  final String shopId;

  const RecentOrdersList({super.key, required this.shopId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopHomeBloc, ShopHomeState>(
      builder: (context, state) {
        List<OrderModel> newOrders = [];

        if (state is ShopHomeDataLoaded) {
          newOrders = state.orders.where((o) {
            final hasShopItem = o.items.any((i) => i.shopId == shopId);
            final isNew =
                ShopOrderStatus.fromString(o.status) == ShopOrderStatus.placed;
            return hasShopItem && isNew;
          }).toList();
          // Sort based on time
          newOrders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        }

        final displayOrders = newOrders.take(4).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('New Orders', style: ShopAppTextStyles.bodyLargeBold),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: ShopAppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    'Today',
                    style: ShopAppTextStyles.bodyMediumBold.copyWith(
                      color: ShopAppColors.primary,
                      fontSize: 11.sp,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            if (state is ShopHomeLoading || state is ShopHomeInitial)
              const Center(child: SizedBox())
            else if (displayOrders.isEmpty)
              const EmptyRecentOrdersView()
            else
              ...displayOrders.map((order) {
                final shopItems = order.items
                    .where((i) => i.shopId == shopId)
                    .toList();
                if (shopItems.isEmpty) return const SizedBox.shrink();

                final firstItem = shopItems.first;
                final totalAmount = shopItems.fold<double>(
                  0.0,
                  (sum, item) => sum + (item.price * item.quantity),
                );

                final paymentMethodLabel =
                    ShopOrdersHelper.getDisplayPaymentMethod(
                      order.paymentMethod,
                    );
                final bool isCOD = paymentMethodLabel == 'COD';
                final badgeColor = isCOD
                    ? const Color(0xFF0F766E)
                    : const Color(0xFF5E5CE6);

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (_) =>
                              sl<ShopOrdersBloc>()
                                ..add(FetchShopOrdersEvent(shopId)),
                          child: ShopOrderDetailsPage(
                            order: order,
                            shopId: shopId,
                          ),
                        ),
                      ),
                    );
                  },
                  child: _buildOrderItem(
                    order.deliveryAddress.fullName,
                    shopItems.length > 1
                        ? '${firstItem.productName} + ${shopItems.length - 1} more'
                        : firstItem.productName,
                    '₹${PriceUtils.formatPrice(totalAmount)}',
                    paymentMethodLabel,
                    firstItem.productImage,
                    badgeColor,
                  ),
                );
              }),
            // View All Orders
            if (state is ShopHomeDataLoaded) ...[
              SizedBox(height: 8.h),
              PrimaryButton(
                text: 'View All Orders',
                backgroundColor: ShopAppColors.primary,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ShopOrdersPage()),
                  );
                },
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildOrderItem(
    String name,
    String product,
    String price,
    String method,
    String imageUrl,
    Color methodColor,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: ShopAppColors.surface,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: ShopAppColors.border, width: 1.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              width: 54.r,
              height: 54.r,
              fit: BoxFit.cover,
              placeholder: (context, url) => ProductImagePlaceholder(
                width: 54.r,
                height: 54.r,
                borderRadius: BorderRadius.circular(16.r),
              ),
              errorWidget: (context, url, error) => ProductImagePlaceholder(
                width: 54.r,
                height: 54.r,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product,
                  style: ShopAppTextStyles.bodyMediumBold.copyWith(
                    color: ShopAppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  name,
                  style: ShopAppTextStyles.bodySmall.copyWith(
                    color: ShopAppColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: ShopAppTextStyles.bodyMediumBold.copyWith(
                  color: ShopAppColors.textPrimary,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                method,
                style: ShopAppTextStyles.caption.copyWith(
                  color: methodColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 8.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
