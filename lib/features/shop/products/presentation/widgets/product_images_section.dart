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

  const ProductImagesSection({
    super.key,
    required this.images,
    required this.onPickImage,
    required this.onRemoveImage,
  });

  @override
  Widget build(BuildContext context) {
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

        // Primary Image Upload Box
        GestureDetector(
          onTap: () => onPickImage(0),
          child: Container(
            width: double.infinity,
            height: 160.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: ShopAppColors.primary.withOpacity(0.3),
                style: BorderStyle.solid,
                width: 1.5.w,
              ),
            ),
            child: images[0] != null
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16.r),
                        child: images[0] is File
                            ? Image.file(images[0] as File, fit: BoxFit.cover)
                            : CachedNetworkImage(
                                imageUrl: images[0] as String,
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
                      Positioned(
                        top: 8.h,
                        right: 8.w,
                        child: GestureDetector(
                          onTap: () => onRemoveImage(0),
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
                        'Upload Primary Image',
                        style: ShopAppTextStyles.bodyMedium,
                      ),
                    ],
                  ),
          ),
        ),
        SizedBox(height: 12.h),

        // 2 Optional Small Image Slots
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_buildOptionalImageSlot(1), _buildOptionalImageSlot(2)],
        ),
      ],
    );
  }

  Widget _buildOptionalImageSlot(int index) {
    return GestureDetector(
      onTap: () => onPickImage(index),
      child: Container(
        width: 165.w,
        height: 100.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey[300]!, width: 1.5.w),
        ),
        child: images[index] != null
            ? Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: images[index] is File
                        ? Image.file(images[index] as File, fit: BoxFit.cover)
                        : CachedNetworkImage(
                            imageUrl: images[index] as String,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
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
                  Positioned(
                    top: 4.h,
                    right: 4.w,
                    child: GestureDetector(
                      onTap: () => onRemoveImage(index),
                      child: Container(
                        padding: EdgeInsets.all(4.r),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close_outlined,
                          color: ShopAppColors.error,
                          size: 16.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Center(
                child: Icon(Icons.add, size: 24.sp, color: Colors.grey[400]),
              ),
      ),
    );
  }
}
