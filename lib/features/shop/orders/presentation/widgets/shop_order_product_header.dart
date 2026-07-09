import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/shared/widgets/product_image_placeholder.dart';

class ShopOrderProductHeader extends StatelessWidget {
  final OrderItemModel item;

  const ShopOrderProductHeader({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: CachedNetworkImage(
              imageUrl: item.productImage,
              width: 160.w,
              height: 160.w,
              fit: BoxFit.cover,
              placeholder: (context, url) => ProductImagePlaceholder(
                width: 160.w,
                height: 160.w,
                borderRadius: BorderRadius.circular(16.r),
              ),
              errorWidget: (context, url, error) => ProductImagePlaceholder(
                width: 160.w,
                height: 160.w,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
          ),
          SizedBox(height: 16.h),
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
          Text(
            '₹${item.price.toStringAsFixed(0)}',
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
