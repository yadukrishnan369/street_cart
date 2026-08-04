import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/support/presentation/widgets/bullet_item_widget.dart';

// Privacy Policy Data Collection Card
class DataCollectionCard extends StatelessWidget {
  const DataCollectionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark
            ? ShopAppColors.darkSurface
            : const Color.fromARGB(255, 240, 241, 241),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isDark ? ShopAppColors.darkBorder : const Color(0xFFECEFF1),
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Icon
              Icon(
                Icons.storage_outlined,
                color: ShopAppColors.primary,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                '1. Data Collection',
                style: ShopAppTextStyles.bodyMediumBold.copyWith(
                  color: ShopAppColors.primary,
                  fontSize: 15.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            'We collect information necessary to operate your digital storefront, including:',
            style: ShopAppTextStyles.bodyMedium.copyWith(
              color: isDark
                  ? ShopAppColors.darkTextSecondary
                  : ShopAppColors.textSecondary,
              fontSize: 13.sp,
              height: 1.4,
            ),
          ),
          SizedBox(height: 12.h),
          const BulletItemWidget(
            text: 'Business registration details and legal name.',
          ),
          const BulletItemWidget(
            text: 'Contact information (email, phone, business address).',
          ),
          const BulletItemWidget(
            text: 'Payment processing information via secure providers.',
          ),
          const BulletItemWidget(text: 'Inventory and sales transaction data.'),
        ],
      ),
    );
  }
}
