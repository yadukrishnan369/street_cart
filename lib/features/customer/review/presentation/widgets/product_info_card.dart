import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:street_cart/shared/widgets/product_image_placeholder.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';

// Product Info Card
class ProductInfoCard extends StatelessWidget {
  final String productName;
  final String productImage;
  final String? size;
  final String? color;
  final double? price;

  const ProductInfoCard({
    super.key,
    required this.productName,
    required this.productImage,
    this.size,
    this.color,
    this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            // Product Image
            child: CachedNetworkImage(
              imageUrl: productImage,
              width: 72.w,
              height: 72.w,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  ProductImagePlaceholder(width: 72.w, height: 72.w),
              errorWidget: (context, url, error) =>
                  ProductImagePlaceholder(width: 72.w, height: 72.w),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name
                Text(
                  productName,
                  style: TextStyle(
                    color: const Color(0xFF1E293B),
                    fontWeight: FontWeight.bold,
                    fontSize: 15.sp,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  'Size: ${size ?? "Standard"} | Color: ${color ?? "Default"}',
                  style: TextStyle(
                    color: const Color(0xFF94A3B8),
                    fontSize: 12.sp,
                  ),
                ),
                // Product Price
                if (price != null) ...[
                  SizedBox(height: 6.h),
                  Text(
                    '₹${price!.toStringAsFixed(0)}',
                    style: TextStyle(
                      color: CustomerAppColors.primary,
                      fontWeight: FontWeight.w900,
                      fontSize: 15.sp,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
