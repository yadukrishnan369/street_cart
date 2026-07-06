import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';

class SubmittedInformationCard extends StatelessWidget {
  final ShopProfileModel shop;

  const SubmittedInformationCard({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Submitted Information', style: ShopAppTextStyles.heading3),
        SizedBox(height: 16.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(10),
                blurRadius: 10.r,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: ShopAppColors.textSecondary.withAlpha(26),
            ),
          ),
          child: Column(
            children: [
              _buildDetailRow(
                Icons.storefront_outlined,
                'Shop Name',
                shop.shopName,
              ),
              Divider(
                height: 24.h,
                color: ShopAppColors.textSecondary.withAlpha(26),
              ),
              _buildDetailRow(
                Icons.person_outline_rounded,
                'Owner Name',
                shop.ownerName,
              ),
              Divider(
                height: 24.h,
                color: ShopAppColors.textSecondary.withAlpha(26),
              ),
              _buildDetailRow(
                Icons.mail_outline_rounded,
                'Email Address',
                shop.email,
              ),
              Divider(
                height: 24.h,
                color: ShopAppColors.textSecondary.withAlpha(26),
              ),
              _buildDetailRow(
                Icons.category_outlined,
                'Category',
                shop.category,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: ShopAppColors.textSecondary, size: 20.sp),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: ShopAppTextStyles.bodySmall.copyWith(
                  color: ShopAppColors.textSecondary,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                value,
                style: ShopAppTextStyles.bodyMediumBold.copyWith(
                  color: ShopAppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
