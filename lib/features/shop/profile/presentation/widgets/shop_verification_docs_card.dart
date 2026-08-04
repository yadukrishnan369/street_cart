import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'shop_profile_section_block.dart';

// Shop Verification Docs Card
class ShopVerificationDocsCard extends StatelessWidget {
  final ShopProfileModel profile;

  const ShopVerificationDocsCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return ShopProfileSectionBlock(
      title: 'VERIFICATION DETAILS',
      child: Column(
        // Business Licence
        children: [
          _buildDocVerificationItem(
            context: context,
            title: 'Business License',
            icon: Icons.description_outlined,
            isUploaded: profile.businessLicenseUrl.isNotEmpty,
          ),
          // GST ID
          SizedBox(height: 12.h),
          _buildDocVerificationItem(
            context: context,
            title: 'GST Number',
            icon: Icons.article_outlined,
            isUploaded: profile.gstNumber.isNotEmpty,
          ),
          SizedBox(height: 12.h),
          // Owner ID
          _buildDocVerificationItem(
            context: context,
            title: 'Owner ID Proof',
            icon: Icons.badge_outlined,
            isUploaded: profile.ownerIdUrl.isNotEmpty,
          ),
        ],
      ),
    );
  }

  Widget _buildDocVerificationItem({
    required BuildContext context,
    required String title,
    required IconData icon,
    required bool isUploaded,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isDark ? ShopAppColors.darkInputBackground : Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: isDark ? ShopAppColors.darkBorder : ShopAppColors.border,
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: isDark
                ? ShopAppColors.darkTextSecondary
                : ShopAppColors.textSecondary,
            size: 20.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            // Title
            child: Text(
              title,
              style: ShopAppTextStyles.bodyMediumBold.copyWith(
                color: isDark
                    ? ShopAppColors.darkTextPrimary
                    : ShopAppColors.textPrimary,
                fontSize: 13.sp,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: isUploaded
                  ? (isDark
                        ? ShopAppColors.primary.withValues(alpha: 0.15)
                        : const Color(0xFFE8F5E9))
                  : (isDark
                        ? ShopAppColors.darkSurface
                        : const Color(0xFFECEFF1)),
              borderRadius: BorderRadius.circular(4.r),
            ),
            // Label
            child: Text(
              isUploaded ? 'VERIFIED' : 'NOT PROVIDED',
              style: ShopAppTextStyles.bodySmallBold.copyWith(
                color: isUploaded
                    ? ShopAppColors.primary
                    : (isDark
                          ? ShopAppColors.darkTextSecondary
                          : const Color(0xFF546E7A)),
                fontSize: 10.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
