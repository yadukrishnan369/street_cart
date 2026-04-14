import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:street_cart/features/customer/profile/data/models/profile_model.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';

class EditProfileHeader extends StatelessWidget {
  final ProfileModel? profile;
  final String activeName;
  final VoidCallback? onPickImage;
  final VoidCallback? onRemoveImage;
  final bool isUploading;

  const EditProfileHeader({
    super.key,
    this.profile,
    required this.activeName,
    this.onPickImage,
    this.onRemoveImage,
    this.isUploading = false,
  });

  @override
  Widget build(BuildContext context) {
    final String? imageUrl = profile?.profileImageUrl;
    final bool hasImage = imageUrl != null && imageUrl.isNotEmpty;

    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: CustomerAppColors.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: GestureDetector(
                  onTap: onPickImage,
                  child: CircleAvatar(
                    radius: 50.r,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: hasImage
                        ? CachedNetworkImageProvider(imageUrl)
                        : null,
                    child: !hasImage
                        ? Icon(
                            Icons.person,
                            size: 50.sp,
                            color: Colors.grey.shade400,
                          )
                        : null,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: onPickImage,
                  child: Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: CustomerAppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: CustomerAppColors.surface,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white,
                      size: 16.sp,
                    ),
                  ),
                ),
              ),
              if (isUploading)
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black26,
                    ),
                    child: Center(
                      child: SizedBox(
                        width: 30.w,
                        height: 30.w,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            activeName.isEmpty ? 'Your Name' : activeName,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: onPickImage,
                child: Text(
                  hasImage ? 'Change photo' : 'Add photo',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: CustomerAppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (hasImage) ...[
                SizedBox(width: 16.w),
                Container(
                  width: 1.w,
                  height: 12.h,
                  color: Colors.grey.shade300,
                ),
                SizedBox(width: 16.w),
                GestureDetector(
                  onTap: onRemoveImage,
                  child: Text(
                    'Remove photo',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.red.shade600,
                      fontWeight: FontWeight.w600,
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
