import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';

class ProductDetailImageSlider extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final bool hasMultipleImages = images.length > 1;

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: double.infinity,
          height: 320.h,
          color: Colors.white,
          padding: EdgeInsets.all(12.w),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: images[currentImageIndex] != null
                ? CachedNetworkImage(
                    imageUrl: images[currentImageIndex]!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: ShopAppColors.primary,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(
                      Icons.image,
                      size: 80.sp,
                      color: Colors.grey[300],
                    ),
                  )
                : Icon(
                    Icons.image,
                    size: 80.sp,
                    color: Colors.grey[300],
                  ),
          ),
        ),
        // Back Arrow
        Positioned(
          left: 16.w,
          child: GestureDetector(
            onTap: hasMultipleImages ? onPrev : null,
            child: Opacity(
              opacity: hasMultipleImages ? 1.0 : 0.4,
              child: Container(
                padding: EdgeInsets.all(8.r),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.chevron_left,
                  color: ShopAppColors.textPrimary,
                  size: 24.sp,
                ),
              ),
            ),
          ),
        ),
        // Forward Arrow
        Positioned(
          right: 16.w,
          child: GestureDetector(
            onTap: hasMultipleImages ? onNext : null,
            child: Opacity(
              opacity: hasMultipleImages ? 1.0 : 0.4,
              child: Container(
                padding: EdgeInsets.all(8.r),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.chevron_right,
                  color: ShopAppColors.textPrimary,
                  size: 24.sp,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
