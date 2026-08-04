import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';

// Image Picker Area
class ImagePickerArea extends StatelessWidget {
  final List<dynamic> images;
  final bool isLoading;
  final VoidCallback onPick;
  final ValueChanged<int> onRemove;

  const ImagePickerArea({
    super.key,
    required this.images,
    required this.isLoading,
    required this.onPick,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: isLoading ? null : onPick,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 14.h),
            decoration: BoxDecoration(
              color: ShopAppColors.primary.withValues(
                alpha: isDark ? 0.2 : 0.08,
              ),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: ShopAppColors.primary.withValues(alpha: 0.4),
                style: BorderStyle.solid,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Loading Indicator
                isLoading
                    ? SizedBox(
                        width: 18.sp,
                        height: 18.sp,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: ShopAppColors.primary,
                        ),
                      )
                    : Icon(
                        Icons.add_photo_alternate_outlined,
                        color: ShopAppColors.primary,
                        size: 20.sp,
                      ),
                SizedBox(width: 10.w),
                Text(
                  images.isEmpty
                      ? 'Select images for this color (up to 8)'
                      : 'Change images',
                  style: TextStyle(
                    color: ShopAppColors.primary,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (images.isNotEmpty) ...[
          SizedBox(height: 12.h),
          SizedBox(
            height: 80.h,
            // List of Product Images
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              separatorBuilder: (_, __) => SizedBox(width: 8.w),
              itemBuilder: (_, i) {
                final img = images[i];
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: img is File
                          ? Image.file(
                              img,
                              width: 80.w,
                              height: 80.h,
                              fit: BoxFit.cover,
                            )
                          : CachedNetworkImage(
                              imageUrl: img as String,
                              width: 80.w,
                              height: 80.h,
                              fit: BoxFit.cover,
                            ),
                    ),
                    Positioned(
                      top: 2.h,
                      right: 2.w,
                      child: GestureDetector(
                        onTap: () => onRemove(i),
                        child: Container(
                          width: 18.r,
                          height: 18.r,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 12.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Text(
            '${images.length} image${images.length == 1 ? '' : 's'} selected',
            style: TextStyle(
              fontSize: 11.sp,
              color: isDark
                  ? ShopAppColors.darkTextSecondary
                  : ShopAppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}
