import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/shop_products_bloc.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/shop_products_state.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/product_detail_ui_cubit.dart';
import 'package:street_cart/features/shop/products/presentation/widgets/product_detail_image_slider.dart';
import 'package:street_cart/features/shop/products/presentation/widgets/product_detail_header.dart';
import 'package:street_cart/features/shop/products/presentation/widgets/product_detail_stats.dart';
import 'package:street_cart/features/shop/products/presentation/widgets/product_detail_sizes_section.dart';
import 'package:street_cart/features/shop/products/presentation/widgets/product_detail_colors_section.dart';
import 'package:street_cart/features/shop/products/presentation/widgets/product_detail_edit_button.dart';
import 'package:street_cart/features/shop/products/presentation/utils/products_page_helper.dart';

class ProductDetailPage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: productsBloc),
        BlocProvider<ProductDetailUiCubit>(
          create: (_) => ProductDetailUiCubit(product),
        ),
      ],
      child: BlocListener<ShopProductsBloc, ShopProductsState>(
        listener: (context, state) {
          if (state is ShopProductsLoaded) {
            final updatedProduct = ProductsPageHelper.getUpdatedProduct(
              state.allProducts,
              product.id,
            );
            if (updatedProduct != null) {
              context.read<ProductDetailUiCubit>().updateProduct(
                updatedProduct,
              );
            }
          }
        },
        child: BlocBuilder<ProductDetailUiCubit, ProductDetailUiState>(
          builder: (context, uiState) {
            final currentProduct = uiState.product;
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
                  icon: Icon(
                    Icons.arrow_back,
                    color: ShopAppColors.textPrimary,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Text(
                  'Product Details',
                  style: ShopAppTextStyles.heading3,
                ),
                actions: [
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      color: ShopAppColors.textPrimary,
                    ),
                    onSelected: (val) {
                      if (val == 'delete') {
                        ProductsPageHelper.confirmDelete(
                          context: context,
                          shopId: shopId,
                          product: currentProduct,
                          productsBloc: productsBloc,
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
                    ProductDetailImageSlider(
                      key: ValueKey(uiState.selectedColor ?? 'default'),
                      images: images,
                      currentImageIndex: 0,
                      onPrev: () {},
                      onNext: () {},
                    ),
                    Padding(
                      padding: EdgeInsets.all(20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProductDetailHeader(
                            category: currentProduct.category,
                            name: currentProduct.name,
                            originalPrice: currentProduct.originalPrice,
                            offerPrice: currentProduct.offerPrice,
                          ),
                          SizedBox(height: 20.h),
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
                          ProductDetailSizesSection(
                            product: currentProduct,
                            uiState: uiState,
                          ),
                          ProductDetailColorsSection(
                            product: currentProduct,
                            uiState: uiState,
                          ),
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
                          ProductDetailEditButton(
                            product: currentProduct,
                            shopId: shopId,
                            productsBloc: productsBloc,
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
      ),
    );
  }
}
