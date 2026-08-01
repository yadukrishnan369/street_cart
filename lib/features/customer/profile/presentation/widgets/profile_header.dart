import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';
import 'package:street_cart/features/customer/profile/data/models/profile_model.dart';
import 'package:street_cart/features/customer/profile/presentation/bloc/profile_bloc.dart';
import 'package:street_cart/features/customer/profile/presentation/pages/edit_profile_page.dart';
import 'package:street_cart/shared/widgets/customer_image_placeholder.dart';
import 'package:street_cart/shared/widgets/image_preview_page.dart';

// Profile Header
class ProfileHeader extends StatelessWidget {
  final ProfileModel profile;

  const ProfileHeader({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark
            ? CustomerAppColors.darkSurface
            : CustomerAppColors.surface,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark
                    ? CustomerAppColors.darkBorder
                    : Colors.grey.shade200,
                width: 2,
              ),
            ),
            child: GestureDetector(
              onTap: profile.profileImageUrl.isNotEmpty
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ImagePreviewPage(
                            images: [profile.profileImageUrl],
                            initialIndex: 0,
                          ),
                        ),
                      );
                    }
                  : null,
              // Profile Image
              child: ClipOval(
                child: SizedBox(
                  width: 100.w,
                  height: 100.w,
                  child: profile.profileImageUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: profile.profileImageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              CustomerImagePlaceholder(size: 100.w),
                          errorWidget: (context, url, error) =>
                              CustomerImagePlaceholder(size: 100.w),
                        )
                      : CustomerImagePlaceholder(size: 100.w),
                ),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          // Customer Name
          Text(
            profile.fullName.isEmpty ? 'User' : profile.fullName,
            style: CustomerAppTextStyles.heading1.copyWith(
              fontSize: 25.sp,
              color: isDark
                  ? CustomerAppColors.darkTextPrimary
                  : CustomerAppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          // Customer Email
          Text(
            profile.email,
            style: CustomerAppTextStyles.heading2.copyWith(
              fontSize: 16.sp,
              color: isDark
                  ? CustomerAppColors.darkTextSecondary
                  : CustomerAppColors.textSecondary,
            ),
          ),
          SizedBox(height: 2.h),
          // Customer Phone
          Text(
            profile.phone.isNotEmpty ? profile.phone : 'No phone number added',
            style: CustomerAppTextStyles.subtitle.copyWith(
              fontSize: 16.sp,
              color: isDark
                  ? CustomerAppColors.darkTextSecondary
                  : CustomerAppColors.textSecondary,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 14.sp,
                color: isDark
                    ? CustomerAppColors.darkTextSecondary
                    : Colors.grey.shade600,
              ),
              SizedBox(width: 4.w),
              // Customer Location
              Text(
                profile.locationName.isEmpty
                    ? 'Unknown Location'
                    : profile.locationName,
                style: CustomerAppTextStyles.subtitle.copyWith(
                  fontSize: 12.sp,
                  color: isDark
                      ? CustomerAppColors.darkTextSecondary
                      : CustomerAppColors.textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          SizedBox(
            width: double.infinity,
            // Edit Profile Button
            child: ElevatedButton(
              onPressed: () {
                final profileBloc = context.read<ProfileBloc>();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: profileBloc,
                      child: EditProfilePage(profile: profile),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomerAppColors.primary,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.r),
                ),
                elevation: 0,
              ),
              child: Text(
                'Edit Profile',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
