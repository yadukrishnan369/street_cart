import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/shared/widgets/product_image_placeholder.dart';

// Return Item Card
class ReturnItemCard extends StatelessWidget {
  final OrderItemModel item;

  const ReturnItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: isDark ? Border.all(color: CustomerAppColors.darkBorder) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      // Returned Product Image
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: CachedNetworkImage(
              imageUrl: item.productImage,
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
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name
                Text(
                  item.productName,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? CustomerAppColors.darkTextPrimary
                        : CustomerAppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                if (item.selectedSize != null ||
                    item.selectedColor != null) ...[
                  // Size and Color
                  Text(
                    [
                      if (item.selectedSize != null)
                        'Size: ${item.selectedSize}',
                      if (item.selectedColor != null)
                        'Color: ${item.selectedColor}',
                    ].join(' | '),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: isDark
                          ? CustomerAppColors.darkTextSecondary
                          : Colors.grey[500],
                    ),
                  ),
                  SizedBox(height: 6.h),
                ],
                // Product Price
                Text(
                  '₹${item.price.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: CustomerAppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
