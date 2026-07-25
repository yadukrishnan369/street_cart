import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Review Photo Picker
class ReviewPhotoPicker extends StatelessWidget {
  final List<String> existingImageUrls;
  final List<File> selectedImages;
  final VoidCallback onPickImages;
  final ValueChanged<int> onRemoveImage;
  final ValueChanged<int> onRemoveExistingImage;

  const ReviewPhotoPicker({
    super.key,
    required this.existingImageUrls,
    required this.selectedImages,
    required this.onPickImages,
    required this.onRemoveImage,
    required this.onRemoveExistingImage,
  });

  @override
  Widget build(BuildContext context) {
    final totalCount = existingImageUrls.length + selectedImages.length;
    final showUploadButton = totalCount < 5;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          'Add Photos (optional)',
          style: TextStyle(
            color: const Color(0xFF1E293B),
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.h),
        // List of Selected Images
        SizedBox(
          height: 84.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: totalCount + (showUploadButton ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == totalCount) {
                // Image Upload Button
                return GestureDetector(
                  onTap: onPickImages,
                  child: Container(
                    width: 80.w,
                    height: 72.w,
                    margin: EdgeInsets.only(right: 12.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: const Color(0xFFCBD5E1),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate_outlined,
                          color: const Color(0xFF94A3B8),
                          size: 20.sp,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Upload',
                          style: TextStyle(
                            color: const Color(0xFF94A3B8),
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final isExisting = index < existingImageUrls.length;

              if (isExisting) {
                // Render Remote Image
                return Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: existingImageUrls[index],
                      width: 80.w,
                      height: 72.w,
                      imageBuilder: (context, imageProvider) => Container(
                        width: 80.w,
                        height: 72.w,
                        margin: EdgeInsets.only(right: 12.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) => Container(
                        width: 80.w,
                        height: 72.w,
                        margin: EdgeInsets.only(right: 12.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          color: const Color(0xFFF1F5F9),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 80.w,
                        height: 72.w,
                        margin: EdgeInsets.only(right: 12.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          color: const Color(0xFFF1F5F9),
                        ),
                        child: Icon(
                          Icons.broken_image_outlined,
                          color: const Color(0xFF94A3B8),
                          size: 20.sp,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4.w,
                      right: 16.w,
                      child: GestureDetector(
                        onTap: () => onRemoveExistingImage(index),
                        child: Container(
                          padding: EdgeInsets.all(2.r),
                          decoration: const BoxDecoration(
                            color: Colors.black54,
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
              } else {
                // Render Local Picked Image
                final localIndex = index - existingImageUrls.length;
                return Stack(
                  children: [
                    Container(
                      width: 80.w,
                      height: 72.w,
                      margin: EdgeInsets.only(right: 12.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        image: DecorationImage(
                          image: FileImage(selectedImages[localIndex]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4.w,
                      right: 16.w,
                      child: GestureDetector(
                        onTap: () => onRemoveImage(localIndex),
                        child: Container(
                          padding: EdgeInsets.all(2.r),
                          decoration: const BoxDecoration(
                            color: Colors.black54,
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
              }
            },
          ),
        ),
      ],
    );
  }
}
