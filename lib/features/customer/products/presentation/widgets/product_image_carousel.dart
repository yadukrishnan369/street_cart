import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/shared/widgets/product_image_placeholder.dart';
import 'package:street_cart/shared/widgets/image_preview_page.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/customer_products_bloc.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/customer_products_event.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/customer_products_state.dart';

// Product Image Carousel
class ProductImageCarousel extends StatelessWidget {
  final List<String> images;

  const ProductImageCarousel({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    final bool hasMultipleImages = images.length > 1;

    // Placeholder for when product has no images
    if (images.isEmpty) {
      return ProductImagePlaceholder(
        width: double.infinity,
        height: 320.h,
        iconSize: 80.sp,
        borderRadius: BorderRadius.circular(16.r),
        backgroundColor: Colors.white,
      );
    }

    return BlocBuilder<CustomerProductsBloc, CustomerProductsState>(
      buildWhen: (prev, curr) {
        if (prev is ProductDetailState && curr is ProductDetailState) {
          return prev.carouselIndex != curr.carouselIndex;
        }
        return false;
      },
      builder: (context, state) {
        final currentIndex = state is ProductDetailState
            ? state.carouselIndex
            : 0;

        return Column(
          children: [
            // Image slider
            CarouselSlider.builder(
              itemCount: images.length,
              options: CarouselOptions(
                height: 320.h,
                viewportFraction: 1.0,
                enlargeCenterPage: false,
                enableInfiniteScroll: hasMultipleImages,
                autoPlay: hasMultipleImages,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                onPageChanged: (index, reason) {
                  // Dispatch index update
                  context.read<CustomerProductsBloc>().add(
                    UpdateCarouselIndex(index),
                  );
                },
              ),
              itemBuilder: (context, index, realIndex) {
                final imageUrl = images[index];
                return GestureDetector(
                  onTap: () {
                    // Full screen image preview
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ImagePreviewPage(
                          images: images,
                          initialIndex: index,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: EdgeInsets.all(12.w),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.r),
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const ProductImagePlaceholder(iconSize: 50),
                        errorWidget: (context, url, error) =>
                            const ProductImagePlaceholder(iconSize: 80),
                      ),
                    ),
                  ),
                );
              },
            ),
            // Dot indicator
            if (hasMultipleImages) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: images.asMap().entries.map((entry) {
                  return Container(
                    width: currentIndex == entry.key ? 16.w : 8.w,
                    height: 8.h,
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.r),
                      color: currentIndex == entry.key
                          ? CustomerAppColors.primary
                          : Colors.grey[300],
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 10.h),
            ],
          ],
        );
      },
    );
  }
}
