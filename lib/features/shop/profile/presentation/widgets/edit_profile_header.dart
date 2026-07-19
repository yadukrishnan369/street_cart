import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';

// Shop Edit Profile Header
class ShopEditProfileHeader extends StatelessWidget {
  final String? profileImageUrl;
  final VoidCallback? onPickImage;
  final VoidCallback? onRemoveImage;
  final bool isUploading;

  const ShopEditProfileHeader({
    super.key,
    required this.profileImageUrl,
    required this.onPickImage,
    required this.onRemoveImage,
    this.isUploading = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = profileImageUrl != null && profileImageUrl!.isNotEmpty;

    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: isUploading ? null : onPickImage,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade200, width: 2),
                  ),
                  // Shop Profile Image
                  child: CircleAvatar(
                    radius: 54.r,
                    backgroundColor: const Color(0xFF1E2E2D),
                    backgroundImage: hasImage && !isUploading
                        ? CachedNetworkImageProvider(profileImageUrl!)
                        : null,
                    child: isUploading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : (!hasImage
                              ? Icon(
                                  Icons.storefront_outlined,
                                  size: 54.sp,
                                  color: ShopAppColors.textTertiary,
                                )
                              : null),
                  ),
                ),
                Positioned(
                  bottom: 4.h,
                  right: 4.w,
                  child: Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: const BoxDecoration(
                      color: ShopAppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white,
                      size: 18.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 12.h),

          Text(
            'Shop Profile Picture',
            style: ShopAppTextStyles.bodyMediumBold.copyWith(fontSize: 16.sp),
          ),

          SizedBox(height: 16.h),

          if (!isUploading)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Change Profile Image
                GestureDetector(
                  onTap: onPickImage,
                  child: Text(
                    'Tap to change',
                    style: ShopAppTextStyles.bodySmall.copyWith(
                      color: ShopAppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                if (hasImage) ...[
                  SizedBox(width: 8.w),

                  Container(
                    width: 1.w,
                    height: 14.h,
                    color: Colors.grey.shade400,
                  ),

                  SizedBox(width: 8.w),
                  // Remove Profile Image
                  GestureDetector(
                    onTap: onRemoveImage,
                    child: Text(
                      'Remove Photo',
                      style: ShopAppTextStyles.bodySmall.copyWith(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
        ],
      ),
    );
  }
}
