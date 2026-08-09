import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/shop_products_bloc.dart';
import 'package:street_cart/features/shop/products/presentation/pages/product_detail_page.dart';
import 'package:street_cart/features/shop/products/presentation/pages/add_edit_product_page.dart';
import 'package:street_cart/shared/widgets/product_image_placeholder.dart';
import 'package:street_cart/core/utils/price_utils.dart';

// Product List Item
class ProductListItem extends StatelessWidget {
  final ProductModel product;
  final String shopId;
  final ShopProductsBloc productsBloc;
  final VoidCallback onDeleteTap;

  const ProductListItem({
    super.key,
    required this.product,
    required this.shopId,
    required this.productsBloc,
    required this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bool isOutOfStock = product.stockQuantity <= 0;
    final bool isDisabledByAdmin = product.disabledByAdmin;

    return GestureDetector(
      onTap: isDisabledByAdmin
          ? null
          : () {
              // Navigate to Product Detail Page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailPage(
                    product: product,
                    shopId: shopId,
                    productsBloc: productsBloc,
                  ),
                ),
              );
            },
      child: Opacity(
        opacity: isDisabledByAdmin ? 0.6 : 1.0,
        child: Container(
          margin: EdgeInsets.only(bottom: 16.h),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: isDisabledByAdmin
                ? (isDark ? Colors.grey[900] : const Color(0xFFF5F5F5))
                : (isDark ? ShopAppColors.darkSurface : Colors.white),
            border: Border.all(
              color: isDisabledByAdmin
                  ? (isDark ? Colors.grey[800]! : Colors.grey[300]!)
                  : (isDark ? ShopAppColors.darkBorder : Colors.grey[200]!),
            ),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  width: 70.w,
                  height: 70.w,
                  color: isDark
                      ? ShopAppColors.darkInputBackground
                      : Colors.grey[100],
                  // Product Image
                  child: product.images.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: product.images[0],
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const ProductImagePlaceholder(),
                          errorWidget: (context, url, error) =>
                              const ProductImagePlaceholder(),
                        )
                      : const ProductImagePlaceholder(),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name
                    Text(
                      product.name,
                      style: isDark
                          ? ShopAppTextStyles.bodyMediumBold.copyWith(
                              color: ShopAppColors.darkTextPrimary,
                            )
                          : ShopAppTextStyles.bodyMediumBold,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    // Product Price
                    Text(
                      '₹${PriceUtils.formatPrice(product.offerPrice ?? product.originalPrice)}',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: ShopAppColors.primary,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    // Product Status Badge
                    Row(
                      children: [
                        Container(
                          width: 8.r,
                          height: 8.r,
                          decoration: BoxDecoration(
                            color: isDisabledByAdmin
                                ? ShopAppColors.error
                                : (!product.isActive
                                      ? ShopAppColors.error
                                      : (isOutOfStock
                                            ? ShopAppColors.error
                                            : ShopAppColors.success)),
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          isDisabledByAdmin
                              ? 'Disabled by Admin'
                              : (!product.isActive
                                    ? 'Inactive / Deleted'
                                    : (isOutOfStock
                                          ? 'Out of Stock'
                                          : 'Active')),
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: isDisabledByAdmin
                                ? ShopAppColors.error
                                : (!product.isActive
                                      ? ShopAppColors.error
                                      : (isOutOfStock
                                            ? ShopAppColors.error
                                            : ShopAppColors.success)),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        if (!isDisabledByAdmin)
                          Text(
                            isOutOfStock
                                ? 'Restock soon'
                                : '${product.stockQuantity} in stock',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: ShopAppColors.textTertiary,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              if (!isDisabledByAdmin)
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    color: ShopAppColors.textSecondary,
                  ),
                  onSelected: (val) {
                    if (val == 'edit') {
                      // Navigate to Add Edit Product Page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddEditProductPage(
                            shopId: shopId,
                            product: product,
                            productsBloc: productsBloc,
                          ),
                        ),
                      );
                    } else if (val == 'delete') {
                      onDeleteTap();
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'edit', child: Text('Edit')),
                    const PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
