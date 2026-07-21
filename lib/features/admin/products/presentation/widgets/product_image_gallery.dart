import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/shared/widgets/image_preview_page.dart';

// Product Image Gallery
class ProductImageGallery extends StatelessWidget {
  final ProductModel product;

  const ProductImageGallery({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final p = product;
    final displayImagesList = p.allImages;

    // No images placeholder
    if (displayImagesList.isEmpty) {
      return Container(
        height: 400.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFE8E7ED), width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 64.sp,
              color: const Color(0xFF8A8A9E),
            ),
            SizedBox(height: 12.h),
            Text(
              'No product images uploaded',
              style: TextStyle(fontSize: 14.sp, color: const Color(0xFF8A8A9E)),
            ),
          ],
        ),
      );
    }

    // ValueNotifier for selected image index
    final selectedIndex = ValueNotifier<int>(0);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE8E7ED), width: 1.5),
      ),
      padding: EdgeInsets.all(24.w),
      child: ValueListenableBuilder<int>(
        valueListenable: selectedIndex,
        builder: (context, index, _) {
          final safeIndex = index.clamp(0, displayImagesList.length - 1);

          return Column(
            children: [
              // Main image and open full preview
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ImagePreviewPage(
                        images: displayImagesList,
                        initialIndex: safeIndex,
                      ),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: CachedNetworkImage(
                    imageUrl: displayImagesList[safeIndex],
                    height: 380.h,
                    width: double.infinity,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(
                        color: AdminAppColors.primaryColor,
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.image_not_supported_outlined),
                  ),
                ),
              ),

              if (displayImagesList.length > 1) ...[
                SizedBox(height: 24.h),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(displayImagesList.length, (i) {
                      final isSelected = i == safeIndex;
                      return GestureDetector(
                        onTap: () => selectedIndex.value = i,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 18.w),
                          width: 80.w,
                          height: 80.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                              color: isSelected
                                  ? AdminAppColors.primaryColor
                                  : const Color(0xFFE8E7ED),
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: CachedNetworkImage(
                              imageUrl: displayImagesList[i],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
