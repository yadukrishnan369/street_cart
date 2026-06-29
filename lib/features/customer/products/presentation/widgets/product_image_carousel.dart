import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';

class ProductImageCarousel extends StatefulWidget {
  final List<String> images;

  const ProductImageCarousel({
    super.key,
    required this.images,
  });

  @override
  State<ProductImageCarousel> createState() => _ProductImageCarouselState();
}

class _ProductImageCarouselState extends State<ProductImageCarousel> {
  int _currentImageIndex = 0;

  void _nextImage() {
    if (widget.images.isNotEmpty) {
      setState(() {
        _currentImageIndex = (_currentImageIndex + 1) % widget.images.length;
      });
    }
  }

  void _previousImage() {
    if (widget.images.isNotEmpty) {
      setState(() {
        _currentImageIndex =
            (_currentImageIndex - 1 + widget.images.length) %
                widget.images.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasMultipleImages = widget.images.length > 1;

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(24.r),
            child: AspectRatio(
              aspectRatio: 1.35,
              child: Container(
                color: Colors.grey[200],
                width: double.infinity,
                child: widget.images.isNotEmpty
                    ? Image.network(
                        widget.images[_currentImageIndex],
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
              ),
            ),
          ),
          if (hasMultipleImages) ...[
            Positioned(
              left: 12.w,
              child: GestureDetector(
                onTap: _previousImage,
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: const BoxDecoration(
                    color: Colors.white70,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    size: 18.sp,
                    color: CustomerAppColors.textPrimary,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 12.w,
              child: GestureDetector(
                onTap: _nextImage,
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: const BoxDecoration(
                    color: Colors.white70,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 18.sp,
                    color: CustomerAppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
