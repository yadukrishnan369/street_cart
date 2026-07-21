import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/core/theme/admin/admin_text_styles.dart';
import 'package:street_cart/features/admin/profile/data/models/admin_profile_model.dart';

// Admin Profile Header
class AdminProfileHeader extends StatelessWidget {
  final AdminProfileModel profile;
  final String initials;
  final bool isWideHeader;
  final VoidCallback onEditProfilePressed;

  const AdminProfileHeader({
    super.key,
    required this.profile,
    required this.initials,
    required this.isWideHeader,
    required this.onEditProfilePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFECEFF1), width: 0.8),
      ),
      child: Column(
        children: [
          // Banner Top
          Container(
            height: 120.h,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 161, 119, 224),
                  AdminAppColors.primaryColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
            ),
          ),
          // Profile Info Section
          Transform.translate(
            offset: Offset(0, -40.h),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: isWideHeader
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CircleAvatar(
                          radius: 50.r,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 46.r,
                            backgroundColor: AdminAppColors.primaryColor,
                            child: Text(
                              initials,
                              style: TextStyle(
                                fontSize: 28.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 24.w),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 8.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    // Full Name
                                    Text(
                                      profile.fullName,
                                      style: AdminAppTextStyles.heading2
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFF1E1E2F),
                                          ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10.w,
                                        vertical: 4.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AdminAppColors.primaryColor,
                                        borderRadius: BorderRadius.circular(
                                          20.r,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.verified_user_outlined,
                                            size: 11.sp,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 4.w),
                                          // Role
                                          Text(
                                            profile.role,
                                            style: TextStyle(
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 6.h),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.mail_outline,
                                      size: 14.sp,
                                      color: const Color(0xFF8A8A9E),
                                    ),
                                    SizedBox(width: 6.w),
                                    // Email
                                    Text(
                                      profile.email,
                                      style: AdminAppTextStyles.bodySmall
                                          .copyWith(
                                            color: const Color(0xFF8A8A9E),
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          // Button for Edit Profile
                          child: OutlinedButton(
                            onPressed: onEditProfilePressed,
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFECEFF1)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 12.h,
                              ),
                            ),
                            child: Text(
                              'Edit Profile',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1E1E2F),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50.r,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 46.r,
                            backgroundColor: AdminAppColors.primaryColor,
                            child: Text(
                              initials,
                              style: TextStyle(
                                fontSize: 28.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              profile.fullName,
                              style: AdminAppTextStyles.heading2.copyWith(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1E1E2F),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8.h),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: AdminAppColors.primaryColor,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.verified_user_outlined,
                                    size: 11.sp,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    profile.role,
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.mail_outline,
                                  size: 14.sp,
                                  color: const Color(0xFF8A8A9E),
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  profile.email,
                                  style: AdminAppTextStyles.bodySmall.copyWith(
                                    color: const Color(0xFF8A8A9E),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        // Button for Edit Profile
                        OutlinedButton(
                          onPressed: onEditProfilePressed,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFECEFF1)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                          ),
                          child: Text(
                            'Edit Profile',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1E1E2F),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
