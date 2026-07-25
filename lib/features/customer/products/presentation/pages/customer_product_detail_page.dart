import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/customer_products_bloc.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/customer_products_event.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/customer_products_state.dart';
import 'package:street_cart/features/customer/products/presentation/utils/products_helper.dart';
import 'package:street_cart/features/customer/products/presentation/widgets/product_image_carousel.dart';
import 'package:street_cart/features/customer/products/presentation/widgets/product_info_section.dart';
import 'package:street_cart/features/customer/products/presentation/widgets/product_pricing_section.dart';
import 'package:street_cart/features/customer/products/presentation/widgets/product_sold_by_section.dart';
import 'package:street_cart/features/customer/products/presentation/widgets/product_size_selection.dart';
import 'package:street_cart/features/customer/products/presentation/widgets/product_color_selection.dart';
import 'package:street_cart/features/customer/products/presentation/widgets/product_description_section.dart';
import 'package:street_cart/features/customer/products/presentation/widgets/product_action_buttons.dart';
import 'package:street_cart/features/customer/products/presentation/widgets/product_detail_app_bar.dart';
import 'package:street_cart/features/customer/products/presentation/widgets/stock_status_badge.dart';
import 'package:street_cart/features/customer/products/presentation/widgets/variant_warning_banner.dart';
import 'package:street_cart/features/customer/products/presentation/widgets/product_reviews_section.dart';
import 'package:street_cart/shared/widgets/app_error_view.dart';

// Customer Product Detail Page
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
      create: (context) => sl<CustomerProductsBloc>()
        ..add(
          InitProductDetail(
            product: product,
            initialColor: initialColor,
            initialSize: initialSize,
          ),
        ),
      child: BlocBuilder<CustomerProductsBloc, CustomerProductsState>(
        buildWhen: (prev, curr) =>
            curr is ProductDetailState || curr is CustomerProductsError,
        builder: (context, state) {
          if (state is CustomerProductsError) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Product Details'),
                backgroundColor: CustomerAppColors.surface,
                elevation: 0.5,
              ),
              body: AppErrorView(
                message: state.message,
                onRetry: () {
                  context.read<CustomerProductsBloc>().add(
                    InitProductDetail(
                      product: product,
                      initialColor: initialColor,
                      initialSize: initialSize,
                    ),
                  );
                },
              ),
            );
          }
          if (state is! ProductDetailState) return const SizedBox.shrink();
          final selectedColor = state.selectedColor;
          final selectedSize = state.selectedSize;
          // Get Current Stock and Images
          final currentQty = ProductsHelper.getVariantStock(
            product,
            selectedColor,
            selectedSize,
          );
          final currentImages = ProductsHelper.getImagesForColor(
            product,
            selectedColor,
          );
          return Scaffold(
            backgroundColor: CustomerAppColors.background,
            //  App Bar
            appBar: ProductDetailAppBar(
              product: product,
              shop: shop,
              selectedColor: selectedColor,
              selectedSize: selectedSize,
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Carousel
                  ProductImageCarousel(images: currentImages),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Name and Shop Name
                        ProductInfoSection(
                          productName: product.name,
                          shopName: shop.shopName,
                          rating: product.rating,
                        ),
                        SizedBox(height: 12.h),
                        // Original and Offer Price
                        ProductPricingSection(
                          originalPrice: product.originalPrice,
                          offerPrice: product.offerPrice,
                        ),
                        SizedBox(height: 20.h),
                        // Variant Unavailable Warning Banner
                        if (state.variantWarningMessage != null) ...[
                          VariantWarningBanner(
                            warningMessage: state.variantWarningMessage!,
                          ),
                          SizedBox(height: 16.h),
                        ],
                        // Shop Info Sold-by
                        ProductSoldBySection(shop: shop),
                        SizedBox(height: 20.h),
                        // Color Variant Chips
                        if (product.allColors.isNotEmpty)
                          ProductColorSelection(
                            colors: product.allColors,
                            selectedColor: selectedColor,
                            onColorSelected: (color) {
                              context.read<CustomerProductsBloc>().add(
                                SelectProductColor(
                                  color: color,
                                  product: product,
                                ),
                              );
                            },
                          ),
                        // Size Variant Chips
                        if (product.allSizes.isNotEmpty)
                          ProductSizeSelection(
                            sizes: product.allSizes,
                            selectedSize: selectedSize,
                            sizeStock: selectedColor != null
                                ? {
                                    for (final size in product.allSizes)
                                      size: product.stockForVariant(
                                        selectedColor,
                                        size,
                                      ),
                                  }
                                : {},
                            onSizeSelected: (size) {
                              context.read<CustomerProductsBloc>().add(
                                SelectProductSize(size),
                              );
                            },
                          ),
                        // Stock Badge
                        if (selectedColor != null && selectedSize != null)
                          StockStatusBadge(qty: currentQty),
                        SizedBox(height: 8.h),
                        // Product Description
                        ProductDescriptionSection(
                          description: product.description,
                        ),
                        SizedBox(height: 24.h),
                        // Ratings & Reviews
                        ProductReviewsSection(
                          reviews: state.reviews,
                          product: product,
                          shop: shop,
                          selectedColor: state.selectedColor,
                          selectedSize: state.selectedSize,
                        ),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Add to Cart and Buy Now Buttons Section
            bottomNavigationBar: ProductActionButtons(
              product: product,
              availableQty: currentQty,
            ),
          );
        },
      ),
    );
  }
}
