import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';

class ProductImagesSection extends StatelessWidget {
  final List<dynamic> images;
  final Function(int index) onPickImage;
  final Function(int index) onRemoveImage;
  final VoidCallback onPickMultiImage;
  final int focusedImageIndex;
  final ValueChanged<int> onFocusedImageIndexChanged;

  const ProductImagesSection({
    super.key,
    required this.images,
    required this.onPickImage,
    required this.onRemoveImage,
    required this.onPickMultiImage,
    required this.focusedImageIndex,
    required this.onFocusedImageIndexChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasNoImages = images.every((img) => img == null);
    final dynamic activeImage = images[focusedImageIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PRODUCT IMAGES',
          style: ShopAppTextStyles.caption.copyWith(
            color: ShopAppColors.primary,
          ),
        ),
        SizedBox(height: 12.h),

        if (hasNoImages)
          // Multi Image Upload Box
          GestureDetector(
            onTap: onPickMultiImage,
            child: Container(
              width: double.infinity,
              height: 180.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: ShopAppColors.primary.withOpacity(0.3),
                  style: BorderStyle.solid,
                  width: 1.5.w,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.collections_outlined,
                    size: 48.sp,
                    color: ShopAppColors.primary,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Upload Product Images (Select up to 10)',
                    style: ShopAppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: ShopAppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'Primary image is mandatory, other 9 are optional',
                    style: ShopAppTextStyles.bodySmall.copyWith(
                      color: ShopAppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          )
        else ...[
          // Focused Image Display
          GestureDetector(
            onTap: () => onPickImage(focusedImageIndex),
            child: Container(
              width: double.infinity,
              height: 180.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: ShopAppColors.primary.withOpacity(0.3),
                  style: BorderStyle.solid,
                  width: 1.5.w,
                ),
              ),
              child: activeImage != null
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16.r),
                          child: activeImage is File
                              ? Image.file(activeImage, fit: BoxFit.cover)
                              : CachedNetworkImage(
                                  imageUrl: activeImage as String,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                    child: SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: ShopAppColors.primary,
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                        ),
                        // Label showing image index/role
                        Positioned(
                          top: 8.h,
                          left: 8.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              focusedImageIndex == 0
                                  ? 'Primary Image'
                                  : 'Image #${focusedImageIndex + 1}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8.h,
                          right: 8.w,
                          child: GestureDetector(
                            onTap: () => onRemoveImage(focusedImageIndex),
                            child: Container(
                              padding: EdgeInsets.all(4.r),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close_outlined,
                                color: ShopAppColors.error,
                                size: 20.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate_outlined,
                          size: 40.sp,
                          color: ShopAppColors.primary,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          focusedImageIndex == 0
                              ? 'Upload Primary Image (Mandatory)'
                              : 'Upload Image #${focusedImageIndex + 1} (Optional)',
                          style: ShopAppTextStyles.bodyMedium,
                        ),
                      ],
                    ),
            ),
          ),
          SizedBox(height: 16.h),

          // Horizontal scrollable list
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: List.generate(10, (index) {
                final isSelected = index == focusedImageIndex;
                final image = images[index];

                return GestureDetector(
                  onTap: () => onFocusedImageIndexChanged(index),
                  child: Container(
                    margin: EdgeInsets.only(right: 10.w, top: 4.h, bottom: 4.h),
                    width: 75.w,
                    height: 75.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: isSelected
                            ? ShopAppColors.primary
                            : Colors.grey[300]!,
                        width: isSelected ? 2.5.w : 1.5.w,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: ShopAppColors.primary.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (image != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.r),
                            child: image is File
                                ? Image.file(image, fit: BoxFit.cover)
                                : CachedNetworkImage(
                                    imageUrl: image as String,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const Center(
                                      child: SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 1.5,
                                          color: ShopAppColors.primary,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error, size: 16),
                                  ),
                          )
                        else
                          Center(
                            child: Icon(
                              index == 0 ? Icons.star_border : Icons.add,
                              size: 20.sp,
                              color: index == 0
                                  ? ShopAppColors.primary.withOpacity(0.5)
                                  : Colors.grey[400],
                            ),
                          ),
                        // Number indicator
                        Positioned(
                          bottom: 2.h,
                          right: 4.w,
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontSize: 9.sp,
                              fontWeight: FontWeight.bold,
                              color: image != null
                                  ? Colors.white
                                  : Colors.grey[500],
                              shadows: image != null
                                  ? const [
                                      Shadow(
                                        blurRadius: 2.0,
                                        color: Colors.black,
                                        offset: Offset(1.0, 1.0),
                                      ),
                                    ]
                                  : null,
                            ),
                          ),
                        ),
                        if (image != null)
                          Positioned(
                            top: 2.h,
                            right: 2.w,
                            child: GestureDetector(
                              onTap: () {
                                onRemoveImage(index);
                              },
                              child: Container(
                                padding: EdgeInsets.all(2.r),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.close,
                                  color: ShopAppColors.error,
                                  size: 12.sp,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ],
    );
  }
}
