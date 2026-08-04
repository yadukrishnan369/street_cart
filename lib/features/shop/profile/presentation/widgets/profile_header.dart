import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';

// Shop Profile Header
class ShopProfileHeader extends StatelessWidget {
  final ShopProfileModel profile;
  final VoidCallback onEditPressed;

  const ShopProfileHeader({
    super.key,
    required this.profile,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasImage = profile.profileImageUrl.isNotEmpty;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark ? ShopAppColors.darkSurface : ShopAppColors.surface,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
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
                color: isDark ? ShopAppColors.darkBorder : Colors.grey.shade200,
                width: 2,
              ),
            ),
            // Shop Profile Image
            child: CircleAvatar(
              radius: 40.r,
              backgroundColor: const Color(0xFF1E2E2D),
              backgroundImage: hasImage
                  ? CachedNetworkImageProvider(profile.profileImageUrl)
                  : null,
              child: !hasImage
                  ? Icon(
                      Icons.storefront_outlined,
                      size: 40.sp,
                      color: ShopAppColors.textTertiary,
                    )
                  : null,
            ),
          ),
          SizedBox(height: 16.h),
          // Shop Name
          Text(
            profile.shopName.isEmpty ? 'Shop Name' : profile.shopName,
            textAlign: TextAlign.center,
            style: ShopAppTextStyles.heading2.copyWith(
              fontSize: 22.sp,
              color: isDark
                  ? ShopAppColors.darkTextPrimary
                  : ShopAppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          // Shop Category
          Text(
            profile.category.isEmpty ? 'General Store' : profile.category,
            style: ShopAppTextStyles.bodyMedium.copyWith(
              color: ShopAppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
          Divider(
            color: isDark ? ShopAppColors.darkBorder : ShopAppColors.border,
          ),
          SizedBox(height: 16.h),
          // Owner Name Section
          _buildInfoRow(
            context,
            Icons.person_outline,
            'Owner',
            profile.ownerName,
          ),
          SizedBox(height: 12.h),
          // Email Section
          _buildInfoRow(context, Icons.email_outlined, 'Email', profile.email),
          SizedBox(height: 12.h),
          // Phone Number Section
          _buildInfoRow(
            context,
            Icons.phone_outlined,
            'Phone',
            profile.phone.isNotEmpty ? profile.phone : 'Not added',
          ),
          SizedBox(height: 12.h),
          // Verification Badge Section
          _buildInfoRow(
            context,
            Icons.verified_user_outlined,
            'Status',
            profile.isApproved ? 'Approved Merchant' : 'Verification Pending',
            valueColor: profile.isApproved
                ? ShopAppColors.success
                : ShopAppColors.warning,
          ),
          SizedBox(height: 24.h),
          SizedBox(
            width: double.infinity,
            // Edit Profile Button
            child: ElevatedButton(
              onPressed: onEditPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: ShopAppColors.primary,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.r),
                ),
                elevation: 0,
              ),
              child: Text('Edit Profile', style: ShopAppTextStyles.buttonText),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Icon(
          icon,
          size: 18.sp,
          color: isDark
              ? ShopAppColors.darkTextSecondary
              : ShopAppColors.textSecondary,
        ),
        SizedBox(width: 12.w),
        // Label
        Text(
          '$label:',
          style: ShopAppTextStyles.bodySmall.copyWith(
            color: isDark
                ? ShopAppColors.darkTextSecondary
                : ShopAppColors.textSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            value,
            style: ShopAppTextStyles.bodySmall.copyWith(
              color:
                  valueColor ??
                  (isDark
                      ? ShopAppColors.darkTextPrimary
                      : ShopAppColors.textPrimary),
              fontWeight: valueColor != null
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
