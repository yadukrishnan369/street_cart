import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:street_cart/shared/widgets/product_image_placeholder.dart';
import 'package:street_cart/features/customer/cart/data/models/cart_item_model.dart';

// Cart Item Card
class CartItemCard extends StatelessWidget {
  final CartItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onDelete;
  final VoidCallback? onBuyNow;
  final VoidCallback onView;
  final bool isUnavailable;
  final bool isViewDisabled;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onDelete,
    this.onBuyNow,
    required this.onView,
    this.isUnavailable = false,
    this.isViewDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Format variant string
    final List<String> variantDetails = [];
    if (item.selectedSize != null) {
      variantDetails.add('Size: ${item.selectedSize}');
    }
    if (item.selectedColor != null) {
      variantDetails.add('Color: ${item.selectedColor}');
    }
    final String variantText = variantDetails.join(' • ');

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isDark
            ? CustomerAppColors.darkSurface
            : CustomerAppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isDark
              ? CustomerAppColors.darkBorder
              : CustomerAppColors.border,
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: CachedNetworkImage(
                  imageUrl: item.productImage,
                  width: 80.w,
                  height: 80.h,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => ProductImagePlaceholder(
                    width: 80.w,
                    height: 80.h,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  errorWidget: (context, url, error) => ProductImagePlaceholder(
                    width: 80.w,
                    height: 80.h,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              // Product Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            item.productName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? CustomerAppColors.darkTextPrimary
                                  : CustomerAppColors.textPrimary,
                            ),
                          ),
                        ),
                        // Unavailable badge
                        if (isUnavailable) ...[
                          SizedBox(width: 6.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: CustomerAppColors.error.withValues(
                                alpha: 0.12,
                              ),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              'Unavailable',
                              style: TextStyle(
                                fontSize: 9.sp,
                                fontWeight: FontWeight.bold,
                                color: CustomerAppColors.error,
                              ),
                            ),
                          ),
                          SizedBox(width: 4.w),
                        ],
                        SizedBox(width: 8.w),
                        // View Product detail option
                        GestureDetector(
                          onTap: isViewDisabled ? null : onView,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: isViewDisabled
                                  ? (isDark
                                        ? Colors.grey[850]
                                        : Colors.grey[200])
                                  : CustomerAppColors.primary.withValues(
                                      alpha: 0.1,
                                    ),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text(
                              'View',
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.bold,
                                color: isViewDisabled
                                    ? (isDark
                                          ? Colors.grey[600]
                                          : Colors.grey[500])
                                    : CustomerAppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (variantText.isNotEmpty) ...[
                      SizedBox(height: 4.h),
                      Text(
                        variantText,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: isDark
                              ? CustomerAppColors.darkTextSecondary
                              : CustomerAppColors.textSecondary,
                        ),
                      ),
                    ],
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '₹${item.price.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: CustomerAppColors.primary,
                          ),
                        ),
                        // Quantity control
                        Container(
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF2A2A2A)
                                : Colors.grey[50],
                            border: Border.all(
                              color: isDark
                                  ? CustomerAppColors.darkBorder
                                  : CustomerAppColors.border,
                            ),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: onDecrement,
                                child: Container(
                                  padding: EdgeInsets.all(6.w),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? const Color(0xFF1F1F1F)
                                        : Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.remove,
                                    size: 14.sp,
                                    color: isDark
                                        ? CustomerAppColors.darkTextSecondary
                                        : CustomerAppColors.textSecondary,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12.w),
                                child: Text(
                                  '${item.quantity}',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? CustomerAppColors.darkTextPrimary
                                        : CustomerAppColors.textPrimary,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: onIncrement,
                                child: Container(
                                  padding: EdgeInsets.all(6.w),
                                  decoration: const BoxDecoration(
                                    color: CustomerAppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    size: 14.sp,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(
            color: isDark
                ? CustomerAppColors.darkBorder
                : CustomerAppColors.border,
            height: 16.h,
            thickness: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton.icon(
                onPressed: onDelete,
                icon: Icon(
                  Icons.delete_outline,
                  size: 16.sp,
                  color: CustomerAppColors.error.withAlpha(150),
                ),
                label: Text(
                  'Remove',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: CustomerAppColors.error.withAlpha(150),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: CustomerAppColors.error.withAlpha(150),
                  side: BorderSide(
                    color: CustomerAppColors.error.withAlpha(150),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
              SizedBox(width: 38.w),
              ElevatedButton.icon(
                onPressed: onBuyNow,
                icon: Icon(
                  Icons.bolt,
                  size: 16.sp,
                  color: onBuyNow == null
                      ? (isDark ? Colors.grey[600] : Colors.grey[500])
                      : Colors.white,
                ),
                label: Text(
                  'Buy Now',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: onBuyNow == null
                        ? (isDark ? Colors.grey[600] : Colors.grey[500])
                        : Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomerAppColors.primary,
                  disabledBackgroundColor: isDark
                      ? Colors.grey[850]
                      : Colors.grey[300],
                  disabledForegroundColor: isDark
                      ? Colors.grey[600]
                      : Colors.grey[500],
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
