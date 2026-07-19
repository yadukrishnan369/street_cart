import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/core/utils/price_utils.dart';

// Product Detail Header
class ProductDetailHeader extends StatelessWidget {
  final String category;
  final String name;
  final double originalPrice;
  final double? offerPrice;

  const ProductDetailHeader({
    super.key,
    required this.category,
    required this.name,
    required this.originalPrice,
    this.offerPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: ShopAppColors.primaryLight,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  // Product Category
                  category.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: ShopAppColors.primary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Product Price
                  Text(
                    '₹${PriceUtils.formatPrice(offerPrice ?? originalPrice)}',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: ShopAppColors.primary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (offerPrice != null)
                    // Product Offer Price
                    Text(
                      '₹${PriceUtils.formatPrice(originalPrice)}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: ShopAppColors.textTertiary,
                        decoration: TextDecoration.lineThrough,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Text(name, style: ShopAppTextStyles.heading2),
      ],
    );
  }
}
