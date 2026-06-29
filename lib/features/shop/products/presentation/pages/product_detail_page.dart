import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/shop_products_bloc.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/shop_products_event.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/shop_products_state.dart';
import 'package:street_cart/features/shop/products/presentation/pages/add_edit_product_page.dart';
import 'package:street_cart/shared/widgets/custom_confirmation_modal.dart';
import 'package:street_cart/features/shop/products/presentation/widgets/product_detail_image_slider.dart';
import 'package:street_cart/features/shop/products/presentation/widgets/product_detail_header.dart';
import 'package:street_cart/features/shop/products/presentation/widgets/product_detail_stats.dart';

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
  late ProductModel _product;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _product = widget.product;
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (dialogContext) => ConfirmationModal(
        title: 'Delete Product',
        content:
            'Are you sure you want to delete this product? This action cannot be undone.',
        confirmText: 'Delete',
        confirmColor: ShopAppColors.error,
        onConfirm: () {
          Navigator.pop(dialogContext);
          showDialog(
            context: context,
            builder: (doubleConfirmContext) => ConfirmationModal(
              title: 'Confirm Deletion',
              content:
                  'Please confirm once more. Delete "${_product.name}" permanently?',
              confirmText: 'Permanently Delete',
              confirmColor: ShopAppColors.error,
              onConfirm: () {
                Navigator.pop(doubleConfirmContext);
                widget.productsBloc.add(
                  DeleteProductEvent(widget.shopId, _product.id),
                );
                Navigator.pop(context); // Go back to products page
              },
              onCancel: () => Navigator.pop(doubleConfirmContext),
            ),
          );
        },
        onCancel: () => Navigator.pop(dialogContext),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final images = _product.images.isNotEmpty ? _product.images : [null];

    return BlocProvider.value(
      value: widget.productsBloc,
      child: BlocListener<ShopProductsBloc, ShopProductsState>(
        listener: (context, state) {
          if (state is ShopProductsLoaded) {
            final updatedList = state.allProducts.where(
              (p) => p.id == _product.id,
            );
            if (updatedList.isNotEmpty) {
              setState(() {
                _product = updatedList.first;
              });
            }
          }
        },
        child: Scaffold(
          backgroundColor: ShopAppColors.background,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: ShopAppColors.textPrimary),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text('Product Details', style: ShopAppTextStyles.heading3),
            actions: [
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: ShopAppColors.textPrimary),
                onSelected: (val) {
                  if (val == 'delete') {
                    _confirmDelete();
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
                // Image Slider
                ProductDetailImageSlider(
                  images: images,
                  currentImageIndex: _currentImageIndex,
                  onPrev: () {
                    setState(() {
                      _currentImageIndex =
                          (_currentImageIndex - 1 + images.length) %
                          images.length;
                    });
                  },
                  onNext: () {
                    setState(() {
                      _currentImageIndex =
                          (_currentImageIndex + 1) % images.length;
                    });
                  },
                ),
                Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProductDetailHeader(
                        category: _product.category,
                        name: _product.name,
                        originalPrice: _product.originalPrice,
                        offerPrice: _product.offerPrice,
                      ),
                      SizedBox(height: 20.h),

                      ProductDetailStats(
                        stockQuantity: _product.stockQuantity,
                        salesCount: 128, // Dummy sales count
                      ),
                      SizedBox(height: 24.h),

                      // Sizes Section
                      Text(
                        'Available Sizes (Standard: ${_product.sizeStandard})',
                        style: ShopAppTextStyles.bodyMediumBold,
                      ),
                      SizedBox(height: 8.h),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: _product.sizes.map((size) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(color: ShopAppColors.primary),
                            ),
                            child: Text(
                              size,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: ShopAppColors.primary,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 24.h),

                      // Colors Section
                      Text(
                        'Available Colors',
                        style: ShopAppTextStyles.bodyMediumBold,
                      ),
                      SizedBox(height: 10.h),
                      Wrap(
                        spacing: 12.w,
                        runSpacing: 12.h,
                        children: _product.colors.map((colorName) {
                          final color = ShopAppColors.getColorFromName(
                            colorName,
                          );
                          final isWhite = color.value == 0xFFFFFFFF;
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(color: Colors.grey[300]!),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.02),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 14.r,
                                  height: 14.r,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isWhite
                                          ? Colors.grey[400]!
                                          : Colors.transparent,
                                      width: 1.w,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  colorName,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: ShopAppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 24.h),

                      // Description Section
                      Text(
                        'Product Description',
                        style: ShopAppTextStyles.bodyMediumBold,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        _product.description,
                        style: ShopAppTextStyles.bodyMedium.copyWith(
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 40.h),

                      // Edit Button
                      SizedBox(
                        width: double.infinity,
                        height: 56.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ShopAppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddEditProductPage(
                                  shopId: widget.shopId,
                                  product: _product,
                                  productsBloc: widget.productsBloc,
                                ),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.edit, color: Colors.white),
                              SizedBox(width: 8.w),
                              Text(
                                'Edit Product',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
