import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/shared/widgets/product_image_placeholder.dart';
import 'package:street_cart/shared/widgets/image_preview_page.dart';
import 'package:street_cart/core/utils/price_utils.dart';
import 'package:street_cart/core/navigation/page_transitions.dart';
import 'package:street_cart/features/shop/orders/presentation/bloc/shop_orders_bloc.dart';

// Shop Orders Product Header
class ShopOrderProductHeader extends StatelessWidget {
  final OrderItemModel item;

  const ShopOrderProductHeader({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(26.w),
      decoration: BoxDecoration(
        color: isDark ? ShopAppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              // Navigate to Image Preview Page
              Navigator.push(
                context,
                AppPageTransitions.fade(
                  ImagePreviewPage(
                    images: [item.productImage],
                    initialIndex: 0,
                  ),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              // Product Image
              child: CachedNetworkImage(
                imageUrl: item.productImage,
                width: 260.w,
                height: 160.w,
                fit: BoxFit.cover,
                placeholder: (context, url) => ProductImagePlaceholder(
                  width: 260.w,
                  height: 160.w,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                errorWidget: (context, url, error) => ProductImagePlaceholder(
                  width: 260.w,
                  height: 160.w,
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          // Product name
          Text(
            item.productName,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? ShopAppColors.darkTextPrimary
                  : ShopAppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          // Order Price
          Text(
            '₹${PriceUtils.formatPrice(item.price)}',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
              color: ShopAppColors.primary,
            ),
          ),
          SizedBox(height: 8.h),
          // Product Status Badge
          BlocBuilder<ShopOrdersBloc, ShopOrdersState>(
            builder: (context, state) {
              final data = state.productStatusMap[item.productId];
              final isDeletedOrInactive = data?['isDeletedOrInactive'] ?? false;
              final disabledByAdmin = data?['disabledByAdmin'] ?? false;

              String labelText = 'Active';
              Color badgeBg = const Color(0xFFDEF7EC);
              Color badgeText = const Color(0xFF03543F);

              if (isDeletedOrInactive) {
                labelText = disabledByAdmin
                    ? 'Disabled by Admin'
                    : 'Deleted / Inactive';
                badgeBg = const Color(0xFFFDE8E8);
                badgeText = const Color(0xFF9B1C1C);
              }

              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(100.r),
                  border: Border.all(color: badgeText.withValues(alpha: 0.15)),
                ),
                child: Text(
                  labelText,
                  style: TextStyle(
                    color: badgeText,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
