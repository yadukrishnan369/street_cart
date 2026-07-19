import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/shop_products_bloc.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/shop_products_event.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/shop_products_state.dart';
import 'package:street_cart/features/shop/products/presentation/widgets/product_detail_image_slider.dart';
import 'package:street_cart/features/shop/products/presentation/widgets/product_detail_header.dart';
import 'package:street_cart/features/shop/products/presentation/widgets/product_detail_stats.dart';
import 'package:street_cart/features/shop/products/presentation/widgets/product_detail_sizes_section.dart';
import 'package:street_cart/features/shop/products/presentation/widgets/product_detail_colors_section.dart';
import 'package:street_cart/features/shop/products/presentation/widgets/product_detail_edit_button.dart';
import 'package:street_cart/features/shop/products/presentation/utils/products_page_helper.dart';

// Product Detail Page
class ProductDetailPage extends StatefulWidget {
  final ProductModel product;
  final String shopId;
  final ShopProductsBloc productsBloc;

  const ProductDetailPage({
    super.key,
    required this.product,
    required this.shopId,
    required this.productsBloc,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  @override
  void initState() {
    super.initState();
    widget.productsBloc.add(InitProductDetailEvent(widget.product));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.productsBloc,
      child: BlocBuilder<ShopProductsBloc, ShopProductsState>(
        builder: (context, uiState) {
          final currentProduct = uiState.detailProduct ?? widget.product;
          final images = ProductsPageHelper.getDisplayImages(
            currentProduct,
            uiState.selectedColor,
          );

          return Scaffold(
            backgroundColor: ShopAppColors.background,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: ShopAppColors.textPrimary,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              // Page Header
              title: Text('Product Details', style: ShopAppTextStyles.heading3),
              actions: [
                PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.more_vert,
                    color: ShopAppColors.textPrimary,
                  ),
                  onSelected: (val) {
                    // Product Delete
                    if (val == 'delete') {
                      ProductsPageHelper.confirmDelete(
                        context: context,
                        shopId: widget.shopId,
                        product: currentProduct,
                        productsBloc: widget.productsBloc,
                      );
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text(
                        'Delete',
                        style: TextStyle(color: ShopAppColors.error),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 8.w),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Detail Image Slider Section
                  ProductDetailImageSlider(
                    key: ValueKey(uiState.selectedColor ?? 'default'),
                    images: images,
                    currentImageIndex: uiState.currentImageIndex,
                    onPageChanged: (idx) {
                      widget.productsBloc.add(SelectImageIndexEvent(idx));
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Detail Header
                        ProductDetailHeader(
                          category: currentProduct.category,
                          name: currentProduct.name,
                          originalPrice: currentProduct.originalPrice,
                          offerPrice: currentProduct.offerPrice,
                        ),
                        SizedBox(height: 20.h),
                        // Product Detail Stats
                        ProductDetailStats(
                          stockQuantity:
                              ProductsPageHelper.calculateDisplayStock(
                                currentProduct,
                                uiState.selectedColor,
                                uiState.selectedSize,
                              ),
                          totalQuantity: currentProduct.stockQuantity,
                          salesCount: currentProduct.salesCount,
                        ),
                        SizedBox(height: 24.h),
                        // Product Detail Sizes Section
                        ProductDetailSizesSection(
                          product: currentProduct,
                          uiState: uiState,
                        ),
                        // Product Detail Colors Section
                        ProductDetailColorsSection(
                          product: currentProduct,
                          uiState: uiState,
                        ),
                        // Product Description
                        Text(
                          'Product Description',
                          style: ShopAppTextStyles.bodyMediumBold,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          currentProduct.description,
                          style: ShopAppTextStyles.bodyMedium.copyWith(
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: 40.h),
                        // Product Detail Edit Button
                        ProductDetailEditButton(
                          product: currentProduct,
                          shopId: widget.shopId,
                          productsBloc: widget.productsBloc,
                        ),
                        SizedBox(height: 40.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
