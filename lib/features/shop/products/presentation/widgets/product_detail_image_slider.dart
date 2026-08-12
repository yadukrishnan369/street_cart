import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/shared/widgets/image_preview_page.dart';
import 'package:street_cart/shared/widgets/product_image_placeholder.dart';
import 'package:street_cart/core/navigation/page_transitions.dart';

// Product Detail Image Slider
class ProductDetailImageSlider extends StatelessWidget {
  final List<String?> images;
  final int currentImageIndex;
  final ValueChanged<int> onPageChanged;

  const ProductDetailImageSlider({
    super.key,
    required this.images,
    required this.currentImageIndex,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final validImages = images.whereType<String>().toList();
    final bool hasMultipleImages = validImages.length > 1;

    if (validImages.isEmpty) {
      // Image Placeholder
      return ProductImagePlaceholder(
        width: double.infinity,
        height: 320.h,
        iconSize: 80.sp,
        borderRadius: BorderRadius.circular(16.r),
        backgroundColor: isDark ? ShopAppColors.darkSurface : Colors.white,
      );
    }

    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // Product Image Carousal
            CarouselSlider.builder(
              itemCount: validImages.length,
              options: CarouselOptions(
                height: 320.h,
                viewportFraction: 1.0,
                enlargeCenterPage: false,
                enableInfiniteScroll: hasMultipleImages,
                autoPlay: hasMultipleImages,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                onPageChanged: (index, reason) => onPageChanged(index),
              ),
              itemBuilder: (context, index, realIndex) {
                final imageUrl = validImages[index];
                return GestureDetector(
                  onTap: () {
                    // Navigate to Image Preview Page
                    Navigator.push(
                      context,
                      AppPageTransitions.fade(
                        ImagePreviewPage(
                          images: validImages,
                          initialIndex: index,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    color: isDark ? ShopAppColors.darkBackground : Colors.white,
                    padding: EdgeInsets.all(12.w),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.r),
                      // Product Image
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
          ],
        ),
        if (hasMultipleImages) ...[
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: validImages.asMap().entries.map((entry) {
              return Container(
                width: currentImageIndex == entry.key ? 16.w : 8.w,
                height: 8.h,
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.r),
                  color: currentImageIndex == entry.key
                      ? ShopAppColors.primary
                      : (isDark ? ShopAppColors.darkBorder : Colors.grey[300]),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
