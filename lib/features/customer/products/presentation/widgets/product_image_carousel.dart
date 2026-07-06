import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/shared/widgets/product_image_placeholder.dart';
import 'package:street_cart/shared/widgets/image_preview_page.dart';

class ProductImageCarousel extends StatefulWidget {
  final List<String> images;

  const ProductImageCarousel({super.key, required this.images});

  @override
  State<ProductImageCarousel> createState() => _ProductImageCarouselState();
}

class _ProductImageCarouselState extends State<ProductImageCarousel> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final bool hasMultipleImages = widget.images.length > 1;

    if (widget.images.isEmpty) {
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
              itemCount: widget.images.length,
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
                final imageUrl = widget.images[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ImagePreviewPage(
                          images: widget.images,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.images.asMap().entries.map((entry) {
              return Container(
                width: _currentIndex == entry.key ? 16.w : 8.w,
                height: 8.h,
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.r),
                  color: _currentIndex == entry.key
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
  }
}
