import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';

// Submitted Info Card
class SubmittedInformationCard extends StatelessWidget {
  final ShopProfileModel shop;

  const SubmittedInformationCard({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          'Submitted Information',
          style: ShopAppTextStyles.heading3.copyWith(
            color: isDark
                ? ShopAppColors.darkTextPrimary
                : ShopAppColors.textPrimary,
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: isDark ? ShopAppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
                blurRadius: 10.r,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: isDark
                  ? ShopAppColors.darkBorder
                  : ShopAppColors.textSecondary.withValues(alpha: 0.1),
            ),
          ),
          child: Column(
            children: [
              // Shop name
              _buildDetailRow(
                Icons.storefront_outlined,
                'Shop Name',
                shop.shopName,
                isDark,
              ),
              Divider(
                height: 24.h,
                color: isDark
                    ? ShopAppColors.darkBorder
                    : ShopAppColors.textSecondary.withValues(alpha: 0.1),
              ),
              // Owner name
              _buildDetailRow(
                Icons.person_outline_rounded,
                'Owner Name',
                shop.ownerName,
                isDark,
              ),
              Divider(
                height: 24.h,
                color: isDark
                    ? ShopAppColors.darkBorder
                    : ShopAppColors.textSecondary.withValues(alpha: 0.1),
              ),
              // Email Address
              _buildDetailRow(
                Icons.mail_outline_rounded,
                'Email Address',
                shop.email,
                isDark,
              ),
              Divider(
                height: 24.h,
                color: isDark
                    ? ShopAppColors.darkBorder
                    : ShopAppColors.textSecondary.withValues(alpha: 0.1),
              ),
              // Business category
              _buildDetailRow(
                Icons.category_outlined,
                'Category',
                shop.category,
                isDark,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value,
    bool isDark,
  ) {
    return Row(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: ShopAppTextStyles.bodySmall.copyWith(
                  color: isDark
                      ? ShopAppColors.darkTextSecondary
                      : ShopAppColors.textSecondary,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                value,
                style: ShopAppTextStyles.bodyMediumBold.copyWith(
                  color: isDark
                      ? ShopAppColors.darkTextPrimary
                      : ShopAppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
