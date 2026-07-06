import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/shared/widgets/image_preview_page.dart';
import 'package:street_cart/shared/widgets/product_image_placeholder.dart';

class ProductDetailImageSlider extends StatefulWidget {
  final List<String?> images;
  final int currentImageIndex;
  final VoidCallback onNext;
  final VoidCallback onPrev;

  const ProductDetailImageSlider({
    super.key,
    required this.images,
    required this.currentImageIndex,
    required this.onNext,
    required this.onPrev,
  });

  @override
  State<ProductDetailImageSlider> createState() =>
      _ProductDetailImageSliderState();
}

class _ProductDetailImageSliderState extends State<ProductDetailImageSlider> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final validImages = widget.images.whereType<String>().toList();
    final bool hasMultipleImages = validImages.length > 1;

    if (validImages.isEmpty) {
      return ProductImagePlaceholder(
        width: double.infinity,
        height: 320.h,
        iconSize: 80.sp,
        borderRadius: BorderRadius.circular(16.r),
        backgroundColor: Colors.white,
      );
    }

    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
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
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
              itemBuilder: (context, index, realIndex) {
                final imageUrl = validImages[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ImagePreviewPage(
                          images: validImages,
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
          ],
        ),
        if (hasMultipleImages) ...[
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: validImages.asMap().entries.map((entry) {
              return Container(
                width: _currentIndex == entry.key ? 16.w : 8.w,
                height: 8.h,
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.r),
                  color: _currentIndex == entry.key
                      ? ShopAppColors.primary
                      : Colors.grey[300],
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
