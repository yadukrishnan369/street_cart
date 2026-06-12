import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';

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
    final hasImage = profile.profileImageUrl.isNotEmpty;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: ShopAppColors.surface,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
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
              border: Border.all(color: Colors.grey.shade200, width: 2),
            ),
            child: CircleAvatar(
              radius: 40.r,
              backgroundColor: const Color(0xFF1E2E2D),
              backgroundImage: hasImage
                  ? CachedNetworkImageProvider(profile.profileImageUrl)
                  : null,
              child: !hasImage
                  ? Icon(Icons.storefront_outlined, size: 40.sp, color: ShopAppColors.textTertiary)
                  : null,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            profile.shopName.isEmpty ? 'Shop Name' : profile.shopName,
            textAlign: TextAlign.center,
            style: ShopAppTextStyles.heading2.copyWith(fontSize: 22.sp),
          ),
          SizedBox(height: 4.h),
          Text(
            profile.category.isEmpty ? 'General Store' : profile.category,
            style: ShopAppTextStyles.bodyMedium.copyWith(
              color: ShopAppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
          const Divider(color: ShopAppColors.border),
          SizedBox(height: 16.h),
          _buildInfoRow(Icons.person_outline, 'Owner', profile.ownerName),
          SizedBox(height: 12.h),
          _buildInfoRow(Icons.email_outlined, 'Email', profile.email),
          SizedBox(height: 12.h),
          _buildInfoRow(
            Icons.phone_outlined,
            'Phone',
            profile.phone.isNotEmpty ? profile.phone : 'Not added',
          ),
          SizedBox(height: 12.h),
          _buildInfoRow(
            Icons.verified_user_outlined,
            'Status',
            profile.isApproved ? 'Approved Merchant' : 'Verification Pending',
            valueColor: profile.isApproved ? ShopAppColors.success : ShopAppColors.warning,
          ),
          SizedBox(height: 24.h),
          SizedBox(
            width: double.infinity,
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
              child: Text(
                'Edit Profile',
                style: ShopAppTextStyles.buttonText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {Color? valueColor}) {
    return Row(
      children: [
        Icon(icon, size: 18.sp, color: ShopAppColors.textSecondary),
        SizedBox(width: 12.w),
        Text(
          '$label:',
          style: ShopAppTextStyles.bodySmall.copyWith(
            color: ShopAppColors.textSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            value,
            style: ShopAppTextStyles.bodySmall.copyWith(
              color: valueColor ?? ShopAppColors.textPrimary,
              fontWeight: valueColor != null ? FontWeight.bold : FontWeight.normal,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
