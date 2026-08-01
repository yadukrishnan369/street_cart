import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/shared/widgets/product_image_placeholder.dart';

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String brand;
  final String title;
  final String price;
  final String? originalPrice;
  final int? discountPercentage;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;
  final bool isNew;

  final String? selectedColor;
  final String? selectedSize;

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.brand,
    required this.title,
    required this.price,
    this.originalPrice,
    this.discountPercentage,
    this.isFavorite = false,
    this.onFavoriteTap,
    this.isNew = false,
    this.selectedColor,
    this.selectedSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: isDark ? Border.all(color: CustomerAppColors.darkBorder) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image and Wishlist Button
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16.r),
                  ),
                  child: Container(
                    width: double.infinity,
                    color: isDark
                        ? CustomerAppColors.darkInputBackground
                        : Colors.grey[200],
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const ProductImagePlaceholder(),
                      errorWidget: (context, url, error) =>
                          const ProductImagePlaceholder(),
                    ),
                  ),
                ),
                Positioned(
                  top: 8.h,
                  right: 8.w,
                  child: GestureDetector(
                    onTap: onFavoriteTap,
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: isDark
                            ? CustomerAppColors.darkSurface
                            : Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        size: 18.sp,
                        color: isFavorite
                            ? Colors.red
                            : (isDark
                                  ? CustomerAppColors.darkTextSecondary
                                  : Colors.grey),
                      ),
                    ),
                  ),
                ),
                if (isNew)
                  Positioned(
                    bottom: 8.h,
                    left: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: CustomerAppColors.primary,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        'NEW',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                if (discountPercentage != null && discountPercentage! > 0)
                  Positioned(
                    top: 8.h,
                    left: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.50),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        '$discountPercentage% OFF',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Product Details
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    brand.toUpperCase(),
                    style: TextStyle(
                      color: CustomerAppColors.primary,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? CustomerAppColors.darkTextPrimary
                          : CustomerAppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        price,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w900,
                          color: isDark
                              ? CustomerAppColors.darkTextPrimary
                              : CustomerAppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (originalPrice != null) ...[
                        SizedBox(width: 6.w),
                        Flexible(
                          child: Text(
                            originalPrice!,
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: isDark
                                  ? CustomerAppColors.darkTextSecondary
                                  : Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
