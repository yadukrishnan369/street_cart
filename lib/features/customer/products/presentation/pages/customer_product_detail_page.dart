import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/customer/products/presentation/widgets/product_image_carousel.dart';
import 'package:street_cart/features/customer/products/presentation/widgets/product_info_section.dart';
import 'package:street_cart/features/customer/products/presentation/widgets/product_pricing_section.dart';
import 'package:street_cart/features/customer/products/presentation/widgets/product_sold_by_section.dart';
import 'package:street_cart/features/customer/products/presentation/widgets/product_size_selection.dart';
import 'package:street_cart/features/customer/products/presentation/widgets/product_color_selection.dart';
import 'package:street_cart/features/customer/products/presentation/widgets/product_description_section.dart';
import 'package:street_cart/features/customer/products/presentation/widgets/product_action_buttons.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/wishlist_bloc.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/wishlist_event.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/wishlist_state.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/product_detail_ui_cubit.dart';
import 'package:street_cart/features/customer/products/presentation/widgets/stock_status_badge.dart';

class CustomerProductDetailPage extends StatelessWidget {
  final ProductModel product;
  final ShopProfileModel shop;
  final String? initialColor;
  final String? initialSize;

  const CustomerProductDetailPage({
    super.key,
    required this.product,
    required this.shop,
    this.initialColor,
    this.initialSize,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductDetailUiCubit()..init(product, initialColor, initialSize),
      child: BlocBuilder<ProductDetailUiCubit, ProductDetailUiState>(
        builder: (context, uiState) {
          final selectedColor = uiState.selectedColor;
          final selectedSize = uiState.selectedSize;
          final currentQty = (selectedColor == null || selectedSize == null)
              ? 0
              : product.stockForVariant(selectedColor, selectedSize);

          final currentImages = selectedColor == null
              ? product.displayImages
              : product.imagesForColor(selectedColor);

          return Scaffold(
            backgroundColor: CustomerAppColors.background,
            appBar: AppBar(
              backgroundColor: CustomerAppColors.surface,
              elevation: 0.5,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: CustomerAppColors.textPrimary),
                onPressed: () => Navigator.pop(context),
              ),
              centerTitle: true,
              title: Text(
                'Product Details',
                style: TextStyle(
                  color: CustomerAppColors.textPrimary,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                BlocBuilder<WishlistBloc, WishlistState>(
                  builder: (context, wishlistState) {
                    final isWishlisted = wishlistState is WishlistLoaded && wishlistState.isWishlisted(product.id);
                    return IconButton(
                      icon: Icon(
                        isWishlisted ? Icons.favorite : Icons.favorite_border,
                        color: isWishlisted ? Colors.red : CustomerAppColors.textPrimary,
                      ),
                      onPressed: () {
                        if (isWishlisted) {
                          context.read<WishlistBloc>().add(RemoveProductFromWishlist(productId: product.id));
                          CustomSnackBar.show(context, message: 'Removed from wishlist');
                        } else {
                          context.read<WishlistBloc>().add(
                                AddProductToWishlist(
                                  product: product,
                                  shop: shop,
                                  selectedColor: selectedColor,
                                  selectedSize: selectedSize,
                                ),
                              );
                          CustomSnackBar.show(context, message: 'Added to wishlist');
                        }
                      },
                    );
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductImageCarousel(images: currentImages),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProductInfoSection(productName: product.name, shopName: shop.shopName),
                        SizedBox(height: 12.h),
                        ProductPricingSection(originalPrice: product.originalPrice, offerPrice: product.offerPrice),
                        SizedBox(height: 20.h),
                        if (uiState.variantWarningMessage != null) ...[
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                            decoration: BoxDecoration(
                              color: Colors.red[50]!,
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(color: Colors.red[200]!),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.warning_amber_rounded, color: Colors.red[700]!, size: 20.sp),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Text(
                                    uiState.variantWarningMessage!,
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: Colors.red[700]!,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16.h),
                        ],
                        ProductSoldBySection(shop: shop),
                        SizedBox(height: 20.h),
                        if (product.allColors.isNotEmpty)
                          ProductColorSelection(
                            colors: product.allColors,
                            selectedColor: selectedColor,
                            onColorSelected: (color) {
                              context.read<ProductDetailUiCubit>().selectColor(color, product);
                            },
                          ),
                        if (product.allSizes.isNotEmpty)
                          ProductSizeSelection(
                            sizes: product.allSizes,
                            selectedSize: selectedSize,
                            sizeStock: selectedColor != null
                                ? {
                                    for (final size in product.allSizes)
                                      size: product.stockForVariant(selectedColor, size),
                                  }
                                : {},
                            onSizeSelected: (size) {
                              context.read<ProductDetailUiCubit>().selectSize(size);
                            },
                          ),
                        if (selectedColor != null && selectedSize != null) StockStatusBadge(qty: currentQty),
                        SizedBox(height: 8.h),
                        ProductDescriptionSection(description: product.description),
                        SizedBox(height: 16.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: ProductActionButtons(product: product, availableQty: currentQty),
          );
        },
      ),
    );
  }
}
