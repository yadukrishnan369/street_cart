import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'shop_profile_section_block.dart';

// Shop Payment Methods Card
class ShopPaymentMethodsCard extends StatelessWidget {
  final ShopProfileModel profile;

  const ShopPaymentMethodsCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ShopProfileSectionBlock(
      // Title
      title: 'PAYMENT METHODS',
      child: Row(
        children: profile.paymentMethods.isEmpty
            ? [
                Text(
                  'No payment methods selected',
                  style: ShopAppTextStyles.bodyMedium.copyWith(
                    color: isDark
                        ? ShopAppColors.darkTextSecondary
                        : ShopAppColors.textPrimary,
                  ),
                ),
              ]
            : profile.paymentMethods.map((method) {
                IconData icon = Icons.account_balance_wallet_outlined;
                if (method.toLowerCase().contains('cash')) {
                  icon = Icons.payments_outlined;
                }
                return Container(
                  margin: EdgeInsets.only(right: 12.w),
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? ShopAppColors.darkInputBackground
                        : const Color(0xFFF4F7F6),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: isDark
                          ? ShopAppColors.darkBorder
                          : const Color(0xFFE2EBE9),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    // Payment Methods
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, size: 14.sp, color: ShopAppColors.primary),
                      SizedBox(width: 6.w),
                      Text(
                        method,
                        style: ShopAppTextStyles.bodySmallBold.copyWith(
                          color: ShopAppColors.primary,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
      ),
    );
  }
}
