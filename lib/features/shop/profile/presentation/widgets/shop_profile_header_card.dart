import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/location/presentation/pages/shop_location_page.dart';
import 'package:street_cart/features/shop/profile/presentation/bloc/shop_profile_bloc.dart';
import 'package:street_cart/features/shop/profile/presentation/bloc/shop_profile_event.dart';

class ShopProfileHeaderCard extends StatelessWidget {
  final ShopProfileModel profile;

  const ShopProfileHeaderCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final hasImage = profile.profileImageUrl.isNotEmpty;

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 24.w),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade100, width: 3),
                ),
                child: CircleAvatar(
                  radius: 56.r,
                  backgroundColor: const Color(0xFF1E2E2D),
                  backgroundImage: hasImage
                      ? CachedNetworkImageProvider(profile.profileImageUrl)
                      : null,
                  child: !hasImage
                      ? Icon(Icons.storefront_outlined, size: 56.sp, color: ShopAppColors.textTertiary)
                      : null,
                ),
              ),
              if (profile.isApproved)
                Positioned(
                  bottom: 2.h,
                  right: 2.w,
                  child: Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: const BoxDecoration(
                      color: ShopAppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.verified,
                      color: Colors.white,
                      size: 16.sp,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            profile.shopName.isEmpty ? 'Shop Name' : profile.shopName,
            style: ShopAppTextStyles.heading2.copyWith(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          Text(
            profile.category.isEmpty ? 'Category' : profile.category,
            style: ShopAppTextStyles.bodyMediumBold.copyWith(
              color: ShopAppColors.primary,
              fontSize: 14.sp,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 6.h),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ShopLocationPermissionPage(isFromProfile: true),
                ),
              ).then((result) {
                if (result == true && context.mounted) {
                  context.read<ShopProfileBloc>().add(FetchShopProfileData());
                }
              });
            },
            borderRadius: BorderRadius.circular(8.r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_on_outlined, size: 14.sp, color: ShopAppColors.textSecondary),
                  SizedBox(width: 4.w),
                  Text(
                    '${profile.city.isNotEmpty ? profile.city : 'Location'}, ${profile.state.isNotEmpty ? profile.state : 'State'}',
                    style: ShopAppTextStyles.bodySmall.copyWith(
                      color: ShopAppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(color: const Color(0xFFC8E6C9), width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.verified_user_outlined,
                  color: ShopAppColors.primary,
                  size: 14.sp,
                ),
                SizedBox(width: 6.w),
                Text(
                  'Verified Seller',
                  style: ShopAppTextStyles.bodySmallBold.copyWith(
                    color: ShopAppColors.primary,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
