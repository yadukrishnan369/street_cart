import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/shared/widgets/product_image_placeholder.dart';
import 'package:street_cart/shared/widgets/image_preview_page.dart';
import 'package:street_cart/core/utils/price_utils.dart';

// Shop Orders Product Header
class ShopOrderProductHeader extends StatelessWidget {
  final OrderItemModel item;

  const ShopOrderProductHeader({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(26.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
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
                MaterialPageRoute(
                  builder: (_) => ImagePreviewPage(
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
              color: const Color(0xFF1E293B),
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
        ],
      ),
    );
  }
}
