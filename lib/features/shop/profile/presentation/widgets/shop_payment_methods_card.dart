import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'shop_profile_section_block.dart';

class ShopPaymentMethodsCard extends StatelessWidget {
  final ShopProfileModel profile;

  const ShopPaymentMethodsCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return ShopProfileSectionBlock(
      title: 'PAYMENT METHODS',
      child: Row(
        children: profile.paymentMethods.isEmpty
            ? [
                Text(
                  'No payment methods selected',
                  style: ShopAppTextStyles.bodyMedium,
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
                    color: const Color(0xFFF4F7F6),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: const Color(0xFFE2EBE9),
                      width: 1,
                    ),
                  ),
                  child: Row(
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
