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

class CustomerProductDetailPage extends StatefulWidget {
  final ProductModel product;
  final ShopProfileModel shop;

  const CustomerProductDetailPage({
    super.key,
    required this.product,
    required this.shop,
  });

  @override
  State<CustomerProductDetailPage> createState() =>
      _CustomerProductDetailPageState();
}

class _CustomerProductDetailPageState extends State<CustomerProductDetailPage> {
  String? _selectedSize;
  String? _selectedColor;

  @override
  void initState() {
    super.initState();
    if (widget.product.sizes.isNotEmpty) {
      _selectedSize = widget.product.sizes.first;
    }
    if (widget.product.colors.isNotEmpty) {
      _selectedColor = widget.product.colors.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomerAppColors.background,
      appBar: AppBar(
        backgroundColor: CustomerAppColors.surface,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: CustomerAppColors.textPrimary,
          ),
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
              final isWishlisted = wishlistState is WishlistLoaded &&
                  wishlistState.isWishlisted(widget.product.id);

              return IconButton(
                icon: Icon(
                  isWishlisted ? Icons.favorite : Icons.favorite_border,
                  color: isWishlisted ? Colors.red : CustomerAppColors.textPrimary,
                ),
                onPressed: () {
                  if (isWishlisted) {
                    context.read<WishlistBloc>().add(
                          RemoveProductFromWishlist(
                            productId: widget.product.id,
                          ),
                        );
                    CustomSnackBar.show(context, message: 'Removed from wishlist');
                  } else {
                    context.read<WishlistBloc>().add(
                          AddProductToWishlist(
                            product: widget.product,
                            shop: widget.shop,
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
            ProductImageCarousel(images: widget.product.images),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductInfoSection(
                    productName: widget.product.name,
                    shopName: widget.shop.shopName,
                  ),
                  SizedBox(height: 12.h),
                  ProductPricingSection(
                    originalPrice: widget.product.originalPrice,
                    offerPrice: widget.product.offerPrice,
                  ),
                  SizedBox(height: 20.h),
                  ProductSoldBySection(shop: widget.shop),
                  SizedBox(height: 20.h),
                  ProductSizeSelection(
                    sizes: widget.product.sizes,
                    selectedSize: _selectedSize,
                    onSizeSelected: (size) {
                      setState(() {
                        _selectedSize = size;
                      });
                    },
                  ),
                  ProductColorSelection(
                    colors: widget.product.colors,
                    selectedColor: _selectedColor,
                    onColorSelected: (color) {
                      setState(() {
                        _selectedColor = color;
                      });
                    },
                  ),
                  ProductDescriptionSection(
                    description: widget.product.description,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ProductActionButtons(product: widget.product),
    );
  }
}
